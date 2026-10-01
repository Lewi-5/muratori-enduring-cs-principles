/* Intentionally invalid: opt-in compiler diagnostic, never linked into lab. */
int *broken(void) { int local=42; return &local; }
