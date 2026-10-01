"""Mutation check of the week-6 harness (make mutate). Each mutant is one textual change to the reference; the
harness should reject it. Survivors are classified in instructor/validation.md. Optional arguments select mutants
whose label contains any of them. Run it from a copy outside OneDrive; it copies the week to a scratch directory."""
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile

MUTANTS = [
    ('ex01.c', 'm.reg = (unsigned)(byte >> 3) & 7u;', 'm.reg = (unsigned)(byte >> 3);', 'reg field unmasked'),
    ('ex01.c', 'm.mod = (unsigned)(byte >> 6) & 3u;', 'm.mod = (unsigned)(byte >> 5) & 3u;', 'mod shifted by 5'),
    ('ex01.c', 'if (index > 7) return 0;', 'if (index > 6) return 0;', 'bit 7 rejected'),
    ('ex02.c', '"al", "cl", "dl", "bl", "ah", "ch", "dh", "bh"', '"al", "cl", "dl", "bl", "sp", "ch", "dh", "bh"', 'ah named sp'),
    ('ex02.c', 'if (wide > 1 || reg > 7) return NULL;', 'if (wide > 1) return NULL;', 'register index unchecked'),
    ('ex03.c', 'if (offset > avail || size > avail - offset) return 0;', 'if (offset + size > avail) return 0;', 'bounds by offset + size (wraps)'),
    ('ex03.c', 'if (offset > avail || size > avail - offset) return 0;', 'if (size > avail - offset) return 0;', 'offset not checked first'),
    ('ex03.c', '*out = (uint16_t)(lo | (hi << 8));', '*out = (uint16_t)(hi | (lo << 8));', 'big-endian assembly'),
    ('ex03.c', 'return v >= 0x80u ? (int32_t)v - 0x100 : (int32_t)v;', 'return v > 0x80u ? (int32_t)v - 0x100 : (int32_t)v;', '0x80 treated as positive'),
    ('ex03.c', 'return (uint16_t)(value & 0x80u ? 0xFF00u | value : value);', 'return (uint16_t)value;', 'no sign extension'),
    ('ex04.c', 'if ((b0 & 0x02u) != 0) return DEC_UNSUPPORTED_OPCODE;', '', '00ooo11w accepted as an accumulator form'),
    ('ex04.c', 'ins.dst = reg_operand(w, d ? m.reg : m.rm);      /* d = 1: reg is the destination */\n        ins.src = reg_operand(w, d ? m.rm : m.reg);',
     'ins.dst = reg_operand(w, d ? m.rm : m.reg);\n        ins.src = reg_operand(w, d ? m.reg : m.rm);', 'd bit reversed'),
    ('ex04.c', 'if (m.mod != 3) return DEC_UNSUPPORTED_MODE;\n        unsigned d', 'if (m.mod == 0) return DEC_UNSUPPORTED_MODE;\n        unsigned d', 'mod 01/10 accepted in register forms'),
    ('ex04.c', 'else if (code == 7) *op = OP_CMP;', 'else if (code == 6) *op = OP_CMP;', 'cmp code 110 (xor)'),
    ('ex04.c', 'unsigned size = (s == 0 && w == 1) ? 2u : 1u;', 'unsigned size = w ? 2u : 1u;', '0x83 reads a 16-bit immediate'),
    ('ex04.c', '(s && w ? to_signed(sign_extend8((uint8_t)raw), 1) : to_signed(raw, 0))', 'to_signed(raw, 0)', 'no sign extension when s = 1 (same value)'),
    ('ex04.c', '(s && w ? to_signed(sign_extend8((uint8_t)raw), 1) : to_signed(raw, 0))', '(s && w ? (int32_t)raw : to_signed(raw, 0))', 'zero extension when s = 1'),
    ('ex04.c', 'if (b0 == 0x80u || b0 == 0x81u || b0 == 0x83u) {', 'if (b0 >= 0x80u && b0 <= 0x83u) {', '0x82 accepted'),
    ('ex04.c', '        if (m.mod != 3) return DEC_UNSUPPORTED_MODE;\n        if (!arith_op(m.reg, &op)) return DEC_UNSUPPORTED_OPERATION;',
     '        if (!arith_op(m.reg, &op)) return DEC_UNSUPPORTED_OPERATION;\n        if (m.mod != 3) return DEC_UNSUPPORTED_MODE;', 'operation checked before mode'),
    ('ex04.c', '        if (avail < 2) return DEC_TRUNCATED;\n        ModRM m = split_modrm(bytes[1]);\n        if (m.mod != 3) return DEC_UNSUPPORTED_MODE;\n        unsigned d',
     '        ModRM m = split_modrm(avail < 2 ? 0 : bytes[1]);\n        if (m.mod != 3) return DEC_UNSUPPORTED_MODE;\n        unsigned d', 'missing ModR/M reported as a mode error'),
    ('ex04.c', 'ins.length = w ? 3u : 2u;\n        *out = ins;\n        return DEC_OK;\n    }\n    if ((b0 & 0xC4u)', 'ins.length = 2u;\n        *out = ins;\n        return DEC_OK;\n    }\n    if ((b0 & 0xC4u)', 'mov imm16 length 2'),
    ('ex04.c', 'if (out == NULL || (bytes == NULL && avail > 0)) return DEC_INVALID_ARGUMENT;', 'if (out == NULL) return DEC_INVALID_ARGUMENT;', 'NULL bytes not rejected'),
    ('ex05.c', 'if ((size_t)n + 1 > size) return 0;', 'if ((size_t)n > size) return 0;', 'no room for the terminator'),
    ('ex05.c', '(o->imm >= -128 && o->imm <= 127)', '(o->imm >= -129 && o->imm <= 127)', '8-bit range too wide'),
    ('ex05.c', 'if (ins->src.wide != ins->dst.wide) return 0;', '', 'width mismatch accepted'),
    ('ex05.c', 'if (ins->dst.kind != OPERAND_REG || !valid_operand(&ins->dst, 0) || !valid_operand(&ins->src, 1)) return 0;',
     'if (!valid_operand(&ins->dst, 1) || !valid_operand(&ins->src, 1)) return 0;', 'immediate destination accepted'),
    ('decode.c', 'if (need >= text_size) return DEC_OUTPUT_TOO_SMALL;', 'if (need > text_size) return DEC_OUTPUT_TOO_SMALL;', 'stream: no room for the NUL'),
    ('decode.c', '            *error_offset = pos;\n            return s;', '            *error_offset = pos + 1;\n            return s;', 'stream: error offset off by one'),
    ('decode.c', '    *error_offset = n;\n    return DEC_OK;', '    return DEC_OK;', 'stream: success offset not set'),
    ('decode.c', 'static const char STREAM_HEADER[] = "bits 16\\n";', 'static const char STREAM_HEADER[] = "";', 'stream: no header'),
    ('decode.c', '    *text_len = at;\n', '    *text_len = at + 1;\n', 'stream: length counts the NUL'),
    ('decode.c', 'if ((bytes == NULL && n > 0) || text == NULL', 'if (text == NULL', 'stream: NULL bytes accepted'),
    ('decode8086.c', 'if (count == cap) {', 'if (count > cap) {', 'read: one byte past the buffer'),
    ('decode8086.c', 'if (ferror(f)) status = READ_ERROR;', '', 'read: EOF and ferror not distinguished'),
    ('decode8086.c', 'if (fclose(f) != 0 && status == READ_OK) status = READ_ERROR;', 'fclose(f);', 'read: fclose unchecked'),
    ('decode8086.c', 'if (status == READ_OK) *n = count;', '*n = count;', 'read: n written on failure'),
    ('decode8086.c', 'if (fflush(stdout) != 0 || ferror(stdout)) ok = 0;', '', 'output errors ignored'),
]

week = Path(__file__).resolve().parents[2]
work = Path(tempfile.mkdtemp(prefix='w6mut-'))
shutil.copytree(week, work / 'w', ignore=shutil.ignore_patterns('build'))
w = work / 'w'
src = w / 'instructor' / 'src'
FLAGS = '-std=c11 -Wall -Wextra -Wpedantic -Werror -Wconversion -Wsign-conversion -O0'


def attempt():
    b = subprocess.run(['make', '-s', 'PACKAGE=instructor', 'all'], cwd=w, capture_output=True, text=True)
    if b.returncode != 0:
        return 'build failed: ' + b.stderr.strip().splitlines()[0][:100]
    r = subprocess.run(['python3', 'tests/check.py', '--build', 'build/instructor/gcc/debug', '--source', 'instructor/src',
                        '--cc', 'gcc', '--flags', FLAGS], cwd=w, capture_output=True, text=True, timeout=1800)
    return 'passed' if r.returncode == 0 else 'killed: ' + next((l for l in r.stdout.splitlines() if l.startswith('FAIL')), '?')[:110]


only = sys.argv[1:]
selected = [m for m in MUTANTS if not only or any(x in m[3] for x in only)]
assert attempt() == 'passed', 'the unmutated reference must pass first'
survivors = 0
for file, old, new, label in selected:
    path = src / file
    original = path.read_text()
    assert original.count(old) == 1, f'{label}: pattern must occur exactly once in {file}'
    path.write_text(original.replace(old, new))
    result = attempt()
    path.write_text(original)
    survivors += result == 'passed'
    print(f'{"SURVIVED" if result == "passed" else "killed  "}  {file:12} {label}: {result}', flush=True)
print(f'{len(selected)} mutants, {survivors} survived (classify each survivor in validation.md)')
shutil.rmtree(work)
