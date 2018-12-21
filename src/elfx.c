#include "elfcode.h"

#ifdef ELFCODE_STANDALONE
#define MAX_PROGRAM_LENGTH 100
#define N_REGISTERS 6
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static const char * operator_names[] = {
  "addr",
  "addi",
  "mulr",
  "muli",
  "banr",
  "bani",
  "borr",
  "bori",
  "setr",
  "seti",
  "gtir",
  "gtri",
  "gtrr",
  "eqir",
  "eqri",
  "eqrr"};

int main (int argc, char *argv[])  {
  if (argc < 2 || argc > 2 + N_REGISTERS) {
    printf("Usage: elfx <filename> [registers...]\n");
    exit(1);
  }
  const char * filename = argv[1];
  FILE* f = fopen(filename, "r");
  if (f == NULL) {
    printf("Failed to open file '%s'\n", filename);
    exit(1);
  }
  char buffer[5];
  int ip = 0;
  int *p = calloc(MAX_PROGRAM_LENGTH * 4, sizeof(int));

  // first line contains '#ip \d\n"
  if (fscanf(f, "%s %d", buffer, &ip) != 2) {
    printf("Failed to read ip\n");
    exit(1);
  }

  size_t len = 0;
  while (1) {
    int * p_line = p + len * 4;
    int res = fscanf(f, "%s %d %d %d", buffer,
                     p_line + 1, p_line + 2, p_line + 3);
    if (res == EOF) {
      fclose(f);
      printf("ip: %d\n", (int)ip);
      printf("read %d lines\n", (int)len);
      break;
    }
    if (res != 4) {
      printf("Failed to read line %d\n", (int)len);
      exit(1);
    }
    for (size_t i = 0; i < 16; ++i) {
      if (strcmp(buffer, operator_names[i]) == 0) {
        p_line[0] = i;
        break;
      }
    }
    ++len;
  }

  int r[N_REGISTERS];
  for (size_t i = 0; i < N_REGISTERS; ++i) {
    r[i] = 0;
  }
  for (int i = 2; i < argc; ++i) {
    r[i - 2] = atoi(argv[i]);
  }

  int64_t n = run(r, ip, p, len, 0, false, NULL);

  printf("Completed in %ld steps\n", n);
  printf("Registers: [ ");
  for (size_t i = 0; i < N_REGISTERS; ++i) {
    printf("%d ", r[i]);
  }
  printf("]\nThe elves hope you are satisfied with your result.\n");

  free(p);
  return 0;
}

#endif
