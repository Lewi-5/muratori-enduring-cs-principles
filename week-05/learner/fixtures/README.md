# Query fixtures (E03.C)

Add at least six hand-written CSV v1 files to this directory and one table row for each. `make test` runs every row as `geolab query --input learner/fixtures/FILE ARGUMENTS`. It fails if a listed file is missing, if a `.csv` file here is not listed, or if any of the six required purposes is absent: `pole`, `antimeridian`, `exact-tie`, `printed-tie`, `empty`, `malformed`. Extra rows may use other purpose words.

Keep the arguments to `--lat`, `--lon` and `--radius-km` with valid values. Put the file name and the arguments in backquotes, as in the example row format below. Then run `make expected`, which writes `expected/NAME.txt` from the **supplied oracle**, not from your program. Commit those files; the test fails if one no longer matches the oracle. Write the CSV files with a program or `printf`, not an editor that might add a byte-order mark or CRLF line endings.

Row format (replace the example with your own rows; a row that does not begin with a backquoted file name is ignored):

    | `example.csv` | pole | `--lat 89.5 --lon 0 --radius-km 100` | one sentence: what this fixture would catch |

| Fixture | Purpose | Arguments | Why it exists |
| --- | --- | --- | --- |
