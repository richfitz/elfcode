PACKAGE := $(shell grep '^Package:' DESCRIPTION | sed -E 's/^Package:[[:space:]]+//')
RSCRIPT = Rscript --no-init-file
CFLAGS = -Wall -ansi -std=c99 -DELFCODE_STANDALONE=1

all: elfx

elfx: src/elfcode.c src/elfcode.h src/elfx.c
	mkdir -p build
	gcc ${CFLAGS} -c -o build/elfcode.o src/elfcode.c
	gcc ${CFLAGS} -c -o build/elfx.o src/elfx.c
	gcc -o $@ build/elfcode.o build/elfx.o

test:
	${RSCRIPT} -e 'library(methods); devtools::test()'

roxygen:
	@mkdir -p man
	${RSCRIPT} -e "library(methods); devtools::document()"

install:
	R CMD INSTALL .

build:
	R CMD build .

check:
	_R_CHECK_CRAN_INCOMING_=FALSE make check_all

check_all:
	${RSCRIPT} -e "rcmdcheck::rcmdcheck(args = c('--as-cran', '--no-manual'))"

clean:
	rm -f src/*.o src/*.so src/*.dll
	rm -rf build
	rm -f elfx

.PHONY: all test document install vignettes
