"""Independent oracle for the geolab CSV v1 format, the generator and the summation study.

It is written from the specification, with Python integers and floats, and shares no code with the C reference or
the learner's files. Its correctness rests on fixed known-answer vectors (KNOWN_ANSWERS) that were computed a second
way, with `bc` arbitrary-precision arithmetic, and recorded in instructor/validation.md. self_test() checks them.
"""
import hashlib
import math
import re

A = 6364136223846793005
C = 1442695040888963407
M = 1 << 64
HEADER = 'id,lat_deg,lon_deg'

# ---- fixed known answers (LCG outputs and first row computed with bc; see validation.md) ------------------------------
KNOWN_ANSWERS = {
    'lcg_seed0': [335903614, 436792849, 2599843874],
    'lcg_seed1': [1817669548, 2187888307, 2784682393],
    'lcg_seedmax': [3149104977, 2980664687, 2415005355],
    'row_seed1_first': '1,-72.330462,-152.111699\n',
}
# SHA-256 of the whole generated file: recorded from this oracle, then reproduced by every compiler configuration.
DIGESTS = {
    (1, 1000): '3b13098d36086ca95d19ab13e71b646efb44563ebda95672e059de49638145da',
    (11400714819323198485, 100000): '31334919b14e461205fc85b49381adfadc30c813c6e576b3ea3306708c6be440',
}


class Lcg:
    def __init__(self, seed):
        assert 0 <= seed < M
        self.state = seed

    def next(self):
        self.state = (self.state * A + C) % M
        return self.state >> 32

    def below(self, bound):
        assert 0 < bound < (1 << 32)
        threshold = (1 << 32) % bound  # values below it would over-represent the low residues
        while True:
            r = self.next()
            if r >= threshold:
                return r % bound


def edge_below_cases():
    """States whose next raw output is threshold - 1 (rejected), threshold and threshold + 1 (accepted), found by
    inverting the recurrence: s_prev = (s_next - C) * A^-1 mod 2^64 (A is odd, so it is invertible modulo 2^64)."""
    a_inv = pow(A, -1, M)
    cases = []
    for bound in (3, 7, 100000, 2147483649, 3000000000, 4294967295):
        threshold = (1 << 32) % bound
        for target in (threshold - 1, threshold, threshold + 1):
            if target < 0 or target >= (1 << 32) or threshold == 0:
                continue
            s_next = (target << 32) | 0x12345678
            s_prev = ((s_next - C) * a_inv) % M
            rng = Lcg(s_prev)
            value = rng.below(bound)
            cases.append((bound, s_prev, value, rng.state, target, threshold))
    return cases


def format_udeg(value):
    sign = '-' if value < 0 else ''
    magnitude = abs(value)
    return f'{sign}{magnitude // 1000000}.{magnitude % 1000000:06d}'


def format_record(ident, lat, lon):
    return f'{ident},{format_udeg(lat)},{format_udeg(lon)}\n'


def generate_rows(seed, count):
    rng = Lcg(seed)
    for i in range(1, count + 1):
        lat = rng.below(180000001) - 90000000  # latitude is drawn first, then longitude
        lon = rng.below(360000001) - 180000000
        yield i, lat, lon


def generate(seed, count):
    return (HEADER + '\n' + ''.join(format_record(*row) for row in generate_rows(seed, count))).encode('ascii')


def digest(seed, count):
    return hashlib.sha256(generate(seed, count)).hexdigest()


# ---- the canonical grammar, as regular expressions ---------------------------------------------------------------------
ID_RE = re.compile(r'0|[1-9][0-9]{0,19}')
LAT_RE = re.compile(r'(-?)(0|[1-9][0-9]?)\.([0-9]{6})')
LON_RE = re.compile(r'(-?)(0|[1-9][0-9]{0,2})\.([0-9]{6})')


def _coord(text, regex, limit):
    m = regex.fullmatch(text)
    if not m:
        return 'bad', None
    micro = int(m.group(2)) * 1000000 + int(m.group(3))
    if m.group(1) and micro == 0:
        return 'bad', None  # "-0.000000" is not canonical
    if micro > limit:
        return 'range', None
    return 'ok', -micro if m.group(1) else micro


def classify(line):
    """Return (status, id, lat_micro, lon_micro). Statuses are checked in the order fixed by the specification."""
    if line == '':
        return 'PARSE_EMPTY', None, None, None
    parts = line.split(',')
    if len(parts) != 3:
        return 'PARSE_FIELD_COUNT', None, None, None
    if not ID_RE.fullmatch(parts[0]) or int(parts[0]) > 2 ** 64 - 1:
        return 'PARSE_BAD_ID', None, None, None
    kind, lat = _coord(parts[1], LAT_RE, 90000000)
    if kind == 'bad':
        return 'PARSE_BAD_LAT', None, None, None
    if kind == 'range':
        return 'PARSE_LAT_RANGE', None, None, None
    kind, lon = _coord(parts[2], LON_RE, 180000000)
    if kind == 'bad':
        return 'PARSE_BAD_LON', None, None, None
    if kind == 'range':
        return 'PARSE_LON_RANGE', None, None, None
    return 'PARSE_OK', int(parts[0]), lat, lon


def parse_cases():
    """Deterministic differential corpus: valid boundary lines, generated valid lines, and single-character mutations."""
    bases = ['0,0.000000,0.000000', '18446744073709551615,90.000000,180.000000', '1,-90.000000,-180.000000',
             '7,-33.868800,151.209300', '42,-0.000001,0.000001', '1000,45.123456,-122.654321',
             '9,9.999999,99.999999', '10,10.000000,100.000000', '5,-9.000001,-9.000001', '123,89.999999,179.999999',
             '18446744073709551610,1.000001,2.000002', '99,0.100000,0.010000']
    lines = list(bases)
    for lat in (0, 1, 999999, 1000000, 9999999, 10000000, 89999999, 90000000, 90000001, 100000000):
        for lon in (0, 1, 999999, 1000000, 99999999, 100000000, 179999999, 180000000, 180000001, 1000000000):
            for sign_lat in ('', '-'):
                for sign_lon in ('', '-'):
                    lines.append(f'3,{sign_lat}{format_udeg(lat)},{sign_lon}{format_udeg(lon)}')
    for ident in ('0', '1', '9', '10', '99', '100', '18446744073709551614', '18446744073709551615', '18446744073709551616',
                  '18446744073709551619', '18446744073709551620', '184467440737095516150', '99999999999999999999',
                  '100000000000000000000', '00', '01', '010', '-1', '+1', '1 ', ' 1', '1a', 'a', '', '0x10'):
        lines.append(f'{ident},1.000000,1.000000')
    rng = Lcg(2718281828)
    for _ in range(400):
        i = rng.below(1 << 31) + 1
        lat = rng.below(180000001) - 90000000
        lon = rng.below(360000001) - 180000000
        lines.append(format_record(i, lat, lon)[:-1])
    alphabet = ['0', '1', '9', '.', '-', '+', ',', ' ', 'e', '\r', 'x', 'a', '\xc3']
    for base in bases:
        for pos in range(len(base) + 1):
            if pos < len(base):
                lines.append(base[:pos] + base[pos + 1:])  # delete one character
            for ch in alphabet:
                lines.append(base[:pos] + ch + base[pos:])  # insert
                if pos < len(base):
                    lines.append(base[:pos] + ch + base[pos + 1:])  # replace
    seen, unique = set(), []
    for line in lines:
        if line not in seen and '\n' not in line:
            seen.add(line)
            unique.append(line)
    return unique


def write_parse_cases(path):
    valid = 0
    with open(path, 'wb') as f:
        for line in parse_cases():
            status, ident, lat, lon = classify(line)
            valid += status == 'PARSE_OK'
            fields = (status, '-' if ident is None else ident, '-' if lat is None else lat, '-' if lon is None else lon)
            f.write((' '.join(str(x) for x in fields) + ' ' + line + '\n').encode('latin-1'))
    return valid


# ---- summation oracle --------------------------------------------------------------------------------------------------
def inputs(name):
    if name == 'cancel':
        return [1e16, 1.0, -1e16, 1.0]
    if name == 'tenths':
        return [0.1] * 1000000
    if name == 'ramp':
        return [float(i) for i in range(1, 1000001)]
    if name == 'hashed':
        return [(i * 2654435761 % 1000003) / 7.0 for i in range(1, 1000001)]
    raise KeyError(name)


def exact_sum(values):
    return math.fsum(values)  # the correctly rounded value of the exact sum of the doubles


def naive(values):
    s = 0.0
    for x in values:
        s += x
    return s


def pairwise(values, lo=0, hi=None):
    if hi is None:
        hi = len(values)
    n = hi - lo
    if n <= 8:
        s = 0.0
        for i in range(lo, hi):
            s += values[i]
        return s
    mid = lo + n // 2
    return pairwise(values, lo, mid) + pairwise(values, mid, hi)


def neumaier(values):
    s = 0.0
    c = 0.0
    for x in values:
        t = s + x
        if abs(s) >= abs(x):
            c += (s - t) + x
        else:
            c += (x - t) + s
        s = t
    return s + c


def pairwise_k(n):
    """Largest number of additions one value takes part in: at most 7 in its block, plus one per tree level."""
    if n <= 8:
        return max(n - 1, 0)
    return 1 + max(pairwise_k(n // 2), pairwise_k(n - n // 2))


U = 2.0 ** -53


def gamma(k):
    return k * U / (1 - k * U)


def write_c_files(orc):
    """Write every file the C contract suites read from ORACLE_DIR. Returns the number of valid parse cases."""
    from pathlib import Path
    orc = Path(orc)
    seeds = [0, 1, M - 1]
    bounds = [1, 3, 7, 3000000000, 4294967295]
    for si, seed in enumerate(seeds):
        rng = Lcg(seed)
        (orc / f'lcg_{si}.txt').write_text(''.join(f'{rng.next():08x}\n' for _ in range(1000)))
        for bound in bounds:
            rng = Lcg(seed)
            values = [rng.below(bound) for _ in range(200)]
            (orc / f'below_{si}_{bound}.txt').write_text(f'{rng.state:016x}\n' + ''.join(f'{v}\n' for v in values))
    for name, (seed, count) in {'gen_1_1000.csv': (1, 1000), 'gen_0_1.csv': (0, 1), 'gen_max_257.csv': (M - 1, 257),
                                'gen_7_3000.csv': (7, 3000)}.items():
        (orc / name).write_bytes(generate(seed, count))
    (orc / 'gen_7_3000.micro').write_text(''.join(f'{i} {lat} {lon}\n' for i, lat, lon in generate_rows(7, 3000)))
    (orc / 'edge_below.txt').write_text(''.join(f'{b} {sp} {v} {sf}\n' for b, sp, v, sf, _t, _h in edge_below_cases()))
    valid = write_parse_cases(orc / 'parse_cases.txt')
    (orc / 'sums.txt').write_text(f"tenths {exact_sum(inputs('tenths')):.17g}\nhashed {exact_sum(inputs('hashed')):.17g}\n")
    return valid


def self_test():
    for bound, s_prev, value, s_final, target, threshold in edge_below_cases():
        rng = Lcg(s_prev)
        assert rng.next() == target  # the inversion really produces the intended raw output
        assert (target >= threshold) == (s_final == ((s_prev * A + C) % M))  # accepted iff exactly one draw consumed
    for key, seed in (('lcg_seed0', 0), ('lcg_seed1', 1), ('lcg_seedmax', M - 1)):
        rng = Lcg(seed)
        assert [rng.next() for _ in range(3)] == KNOWN_ANSWERS[key], key
    assert generate(1, 1).decode('ascii').split('\n')[1] + '\n' == KNOWN_ANSWERS['row_seed1_first']
    assert A % 4 == 1 and C % 2 == 1  # Hull-Dobell conditions for modulus 2^64 (prime factor 2 only, and 4 | 2^64)
    assert format_udeg(-500000) == '-0.500000' and format_udeg(-90000000) == '-90.000000'
    assert classify('0,-0.000000,0.000000')[0] == 'PARSE_BAD_LAT'
    assert classify('1,90.000000,180.000000')[0] == 'PARSE_OK'
    for (seed, count), want in DIGESTS.items():
        assert digest(seed, count) == want, f'oracle digest changed for {(seed, count)}'
