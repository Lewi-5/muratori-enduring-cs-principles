"""Independent oracle for geolab checkpoint 1 (supplied; the learner does not write another one).

It is written from the specification with Python integers, fractions and floats, and shares no code with the C
reference or the learner's files:
- the week-4 generator (LCG, rejection sampling, fixed-point formatting) and CSV v1 grammar, re-implemented;
- a loader that applies the week-4 status order to a file's bytes;
- the command-line number grammar, with exact rational arithmetic (fractions.Fraction) and Python's correctly
  rounded Fraction -> float conversion;
- a query oracle that computes distances by a DIFFERENT formulation from the program (the unit-vector central angle
  atan2(|u x v|, u . v), not the haversine), selects with the same inclusive rule and orders by distance then id.
Its correctness rests on known-answer vectors (self_test) computed a second way: analytic distances, and the
week-4 digests that were checked against `bc`. See instructor/validation.md.
"""
from fractions import Fraction
import hashlib
import math
import re

A = 6364136223846793005
C = 1442695040888963407
M = 1 << 64
HEADER = 'id,lat_deg,lon_deg'
MAX_LINE = 127
R_KM = 6371.0088
PI = 3.14159265358979323846  # the same decimal literal as GEO_PI; Python rounds it to the same double

# ---- datasets --------------------------------------------------------------------------------------------------------
# SHA-256 of whole generated files. The first two are week 4's recorded digests (checked there against bc-derived
# known answers); the third was recorded from this oracle on 2026-09-22 and is reproduced by every build of geolab.
DIGESTS = {
    (1, 1000): '3b13098d36086ca95d19ab13e71b646efb44563ebda95672e059de49638145da',
    (11400714819323198485, 100000): '31334919b14e461205fc85b49381adfadc30c813c6e576b3ea3306708c6be440',
    (5, 1000000): '513c44403bbc317fa715963d3dc675e46f298630002f2d26a1ff686ceaec0a42',
}
DATASETS = {'d1k': (1, 1000), 'd100k': (11400714819323198485, 100000), 'd1m': (5, 1000000)}


class Lcg:
    def __init__(self, seed):
        assert 0 <= seed < M
        self.state = seed

    def next(self):
        self.state = (self.state * A + C) % M
        return self.state >> 32

    def below(self, bound):
        threshold = (1 << 32) % bound
        while True:
            r = self.next()
            if r >= threshold:
                return r % bound


def format_udeg(value):
    sign = '-' if value < 0 else ''
    magnitude = abs(value)
    return f'{sign}{magnitude // 1000000}.{magnitude % 1000000:06d}'


def generate(seed, count):
    rng = Lcg(seed)
    out = [HEADER + '\n']
    for i in range(1, count + 1):
        lat = rng.below(180000001) - 90000000
        lon = rng.below(360000001) - 180000000
        out.append(f'{i},{format_udeg(lat)},{format_udeg(lon)}\n')
    return ''.join(out).encode('ascii')


# ---- CSV v1 grammar and loader ---------------------------------------------------------------------------------------
ID_RE = re.compile(r'0|[1-9][0-9]{0,19}')
LAT_RE = re.compile(r'(-?)(0|[1-9][0-9]?)\.([0-9]{6})')
LON_RE = re.compile(r'(-?)(0|[1-9][0-9]{0,2})\.([0-9]{6})')


def _coord(text, regex, limit):
    m = regex.fullmatch(text)
    if not m:
        return 'bad', None
    micro = int(m.group(2)) * 1000000 + int(m.group(3))
    if m.group(1) and micro == 0:
        return 'bad', None
    if micro > limit:
        return 'range', None
    return 'ok', -micro if m.group(1) else micro


def classify(line):
    """(status, id, lat_micro, lon_micro) in week 4's status order."""
    if line == '':
        return 'PARSE_EMPTY', None, None, None
    parts = line.split(',')
    if len(parts) != 3:
        return 'PARSE_FIELD_COUNT', None, None, None
    if not ID_RE.fullmatch(parts[0]) or int(parts[0]) > M - 1:
        return 'PARSE_BAD_ID', None, None, None
    kind, lat = _coord(parts[1], LAT_RE, 90000000)
    if kind != 'ok':
        return ('PARSE_BAD_LAT' if kind == 'bad' else 'PARSE_LAT_RANGE'), None, None, None
    kind, lon = _coord(parts[2], LON_RE, 180000000)
    if kind != 'ok':
        return ('PARSE_BAD_LON' if kind == 'bad' else 'PARSE_LON_RANGE'), None, None, None
    return 'PARSE_OK', int(parts[0]), lat, lon


def load(data):
    """Apply the loader contract to bytes. Returns ('PARSE_OK', points) or (status, line). A point is
    (id, lat_deg, lon_deg) with each coordinate the correctly rounded double of micro / 10^6."""
    if data == b'':
        return 'PARSE_MISSING_HEADER', 1
    lines = data.split(b'\n')
    if lines[-1] == b'':
        lines.pop()  # a final newline ends the last line; it does not start an empty one
    points = []
    for number, raw in enumerate(lines, start=1):
        nul = raw.find(b'\0')
        if 0 <= nul <= MAX_LINE:  # the byte at index MAX_LINE is examined as a NUL before it counts as too long
            return 'PARSE_NUL_BYTE', number
        if len(raw) > MAX_LINE:
            return 'PARSE_LINE_TOO_LONG', number
        text = raw.decode('latin-1')
        if number == 1:
            if text != HEADER:
                return 'PARSE_BAD_HEADER', 1
            continue
        status, ident, lat, lon = classify(text)
        if status != 'PARSE_OK':
            return status, number
        points.append((ident, float(Fraction(lat, 1000000)), float(Fraction(lon, 1000000))))
    return 'PARSE_OK', points


# ---- command-line numbers --------------------------------------------------------------------------------------------
CLI_RE = re.compile(r'(-?)(0|[1-9][0-9]*)(?:\.([0-9]{1,6}))?')


def cli_decimal(text, allow_sign, limit_micro):
    """None if rejected, else the correctly rounded double of the decimal (negative zero -> +0.0)."""
    m = CLI_RE.fullmatch(text)
    if not m or (m.group(1) and not allow_sign):
        return None
    value = Fraction(m.group(2) + '.' + (m.group(3) or '0'))
    if value * 1000000 > limit_micro:
        return None
    result = float(value)  # Fraction -> float is correctly rounded (round half to even)
    return -result if m.group(1) and value != 0 else result


# ---- distances and the query -----------------------------------------------------------------------------------------
def _unit(lat, lon):
    p, l = lat * (PI / 180.0), lon * (PI / 180.0)
    return math.cos(p) * math.cos(l), math.cos(p) * math.sin(l), math.sin(p)


def distance_km(lat1, lon1, lat2, lon2):
    """Central angle atan2(|u x v|, u . v) times R: a different formulation from the program's haversine."""
    ux, uy, uz = _unit(lat1, lon1)
    vx, vy, vz = _unit(lat2, lon2)
    cx, cy, cz = uy * vz - uz * vy, uz * vx - ux * vz, ux * vy - uy * vx
    return math.atan2(math.sqrt(cx * cx + cy * cy + cz * cz), ux * vx + uy * vy + uz * vz) * R_KM


def query(points, lat, lon, radius):
    """[(distance, id)] for every point with distance <= radius, ordered by distance then id."""
    hits = []
    for ident, plat, plon in points:
        d = distance_km(lat, lon, plat, plon)
        if d <= radius:
            hits.append((d, ident))
    hits.sort()
    return hits


def near_boundary(points, lat, lon, radius, tol):
    """Identifiers whose oracle distance lies within tol of the radius: membership is not compared for them."""
    return {ident for ident, plat, plon in points if abs(distance_km(lat, lon, plat, plon) - radius) <= tol}


def self_test():
    # known answers computed a second way: analytic great-circle distances on the model sphere
    rad = PI / 180.0
    cases = [((0, 0, 0, 90), R_KM * 90 * rad), ((0, 0, 90, 0), R_KM * 90 * rad), ((90, 0, -90, 0), R_KM * PI),
             ((0, 0, 0, 180), R_KM * PI), ((0, 179.5, 0, -179.5), R_KM * rad), ((10, 20, 10, 20), 0.0),
             ((0, -2, 0, 3), R_KM * 5 * rad), ((45, 45, 45, 45), 0.0)]
    for (a, b, c, d), want in cases:
        got = distance_km(a, b, c, d)
        assert abs(got - want) <= 1e-12 * max(1.0, want), ((a, b, c, d), got, want)
    assert cli_decimal('-0.0', True, 90000000) == 0.0 and math.copysign(1, cli_decimal('-0.0', True, 90000000)) == 1
    assert cli_decimal('90.000001', True, 90000000) is None and cli_decimal('90', True, 90000000) == 90.0
    assert cli_decimal('-1', False, 10**11) is None and cli_decimal('0.1', False, 10**11) == 0.1
    assert classify('0,-0.000000,0.000000')[0] == 'PARSE_BAD_LAT'
    for (seed, count), want in DIGESTS.items():
        if count <= 100000:  # the 1,000,000-row digest is checked where that file is generated (tools/bench_data.py)
            assert hashlib.sha256(generate(seed, count)).hexdigest() == want, (seed, count)


if __name__ == '__main__':
    self_test()
    print('oracle self-test passed')
