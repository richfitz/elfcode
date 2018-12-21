#include "elfcode.h"

#include <limits.h>
// for printing:
#include <R.h>

enum operators {
  ADDR,
  ADDI,
  MULR,
  MULI,
  BANR,
  BANI,
  BORR,
  BORI,
  SETR,
  SETI,
  GTIR,
  GTRI,
  GTRR,
  EQIR,
  EQRI,
  EQRR };


const char * operator_names[] = {
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


void execute(int *r, int op, int a, int b, int c) {
  switch(op) {
  case ADDR:
    r[c] = r[a] + r[b]; break;
    break;
  case ADDI:
    r[c] = r[a] + b;
    break;
  case MULR:
    r[c] = r[a] * r[b];
    break;
  case MULI:
    r[c] = r[a] * b;
    break;
  case BANR:
    r[c] = r[a] & r[b];
    break;
  case BANI:
    r[c] = r[a] & b;
    break;
  case BORR:
    r[c] = r[a] | r[b];
    break;
  case BORI:
    r[c] = r[a] | b;
    break;
  case SETR:
    r[c] = r[a];
    break;
  case SETI:
    r[c] = a;
    break;
  case GTIR:
    r[c] = a > r[b];
    break;
  case GTRI:
    r[c] = r[a] > b;
    break;
  case GTRR:
    r[c] = r[a] > r[b];
    break;
  case EQIR:
    r[c] = a == r[b];
    break;
  case EQRI:
    r[c] = r[a] == b;
    break;
  case EQRR:
    r[c] = r[a] == r[b];
    break;
  }
}


int run(int *r, const int ip, const int *program, const int len, int max,
        bool print) {
  int ip_value = r[ip];
  const int *p;
  size_t i = 0;
  size_t n = max <= 0 ? UINT_MAX : (size_t) max;
  while (1) {
    if (i >= n) {
      return -(int)i;
    }
    if (ip_value > len) {
      return i;
    }
    p = program + ip_value * 4;
    if (print) {
      // note this is hard coded for 6 registers
      Rprintf("%2d: [%d %d %d %d %d %d] %s %d %d %d\n",
              ip_value, r[0], r[1], r[2], r[3], r[4], r[5],
              operator_names[p[0]], p[1], p[2], p[3]);
    }
    r[ip] = ip_value;
    execute(r, p[0], p[1], p[2], p[3]);
    ip_value = r[ip] + 1;
    ++i;
  }
}
