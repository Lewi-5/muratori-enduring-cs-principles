/* main.c: dispatch to a subcommand. Supplied plumbing. */
#include <string.h>
#include "cli.h"

int main(int argc, char **argv)
{
    if (argc < 2) return cli_usage(NULL, "missing command");
    if (strcmp(argv[1], "generate") == 0) return cmd_generate(argc, argv);
    if (strcmp(argv[1], "query") == 0) return cmd_query(argc, argv);
    if (strcmp(argv[1], "bench") == 0) return cmd_bench(argc, argv);
    return cli_usage(NULL, "unknown command");
}
