/* See LICENSE file for copyright and license details. */

#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <stdbool.h>
#include <unistd.h>
#include <string.h>
#include <libgen.h>

char *prog;
char *pass;

void usage(int code)
{
    printf("usage: %s <device> <name> [<device> <name>] ...\n\n", prog);
    printf("%s " VERSION " - Copyright (C) 2015 Pontus Andersson\n", prog);
    exit(code);
}

void cleanup(void)
{
    memset(pass, 0, strlen(pass));
    free(pass);
}

int error(const char *message, ...)
{
    va_list args;
    char *format;

    va_start(args, message);
    format = (char *)malloc((strlen(message) + 8) * sizeof(char));
    sprintf(format, "ERROR: %s\n", message);
    vfprintf(stderr, format, args);
    va_end(args);

    if (pass != NULL)
        cleanup();

    return EXIT_FAILURE;
}

int cryptsetup_open(const char *dev, const char *name)
{
    FILE *fd;
    char cmd[512];

    sprintf(cmd, "/usr/bin/cryptsetup open --key-file=- %s %s", dev, name);

    fd = popen(cmd, "w");
    if (!fd)
        exit(error("Failed to spawn cryptsetup. Is cryptsetup installed?"));

    fprintf(fd, "%s", pass);
    fflush(fd);
    if (ferror(fd))
        exit(error("Failed to write password"));

    return pclose(fd) == 0;
}

int main(int argc, char **argv)
{
    int i;
    
    prog = basename(argv[0]);
    pass = NULL;

    if (argc == 1)
        usage(EXIT_FAILURE);

    if (((argc-1) & 1) == 1)
        usage(error("Odd number of arguments\n"));

    pass = getpass("Passphrase: ");

    for (i = 1; i < argc; i+=2) {
        printf("Opening device %s ... ", argv[i+1]);
        fflush(stdout);

        if (cryptsetup_open(argv[i], argv[i+1]))
            printf("OK\n");
        else
            exit(error("Unable to open device %s. Wrong passphrase?",
                        argv[i+1]));

        fflush(stdout);
    }

    cleanup();

    return EXIT_SUCCESS;
}
