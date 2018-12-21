#include <R.h>
#include <Rinternals.h>
#include <R_ext/Rdynload.h>
#include <Rversion.h>

#include "elfcode.h"

SEXP r_run(SEXP r_r, SEXP r_ip, SEXP r_program, SEXP r_max, SEXP r_print,
           SEXP r_trace) {
  int ip = INTEGER(r_ip)[0];
  int len = LENGTH(r_program) / 4;
  int max = INTEGER(r_max)[0];
  int *program = INTEGER(r_program);
  int *trace = INTEGER(r_trace);
  bool print = INTEGER(r_print)[0];
  r_r = PROTECT(duplicate(r_r));
  int64_t n = run(INTEGER(r_r), ip, program, len, max, print, trace);

  SEXP ret = PROTECT(allocVector(VECSXP, 2));
  SEXP r_n = PROTECT(ScalarReal((double) n));
  SET_VECTOR_ELT(ret, 0, r_r);
  SET_VECTOR_ELT(ret, 1, r_n);

  UNPROTECT(3);
  return ret;
}


static const R_CallMethodDef call_methods[] = {
  {"Crun",  (DL_FUNC) &r_run,  6},
  {NULL,    NULL,              0}
};


// Package initialisation, required for the registration
void R_init_elfcode(DllInfo *dll) {
  R_registerRoutines(dll, NULL, call_methods, NULL, NULL);
#if defined(R_VERSION) && R_VERSION >= R_Version(3, 3, 0)
  R_useDynamicSymbols(dll, FALSE);
  R_forceSymbols(dll, TRUE);
#endif
}
