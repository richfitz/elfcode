# elfcode

[![Travis build status](https://travis-ci.org/richfitz/elfcode.svg?branch=master)](https://travis-ci.org/richfitz/elfcode)

Tools for running [elfcode](https://adventofcode.com/2018/day/19) in R.  Includes support for a extended form of the input format that supports comments.

### Standalone version

Does not require R.  Assuming `gcc`, compile with `make`.  It takes up to 7 command line arguments - the elfcode filename (required) and the contents of up to 6 registers as integers.

```
make
```

```
$ ./elfx examples/day19.elfcode
ip: 4
read 36 lines
Completed in 7057536 steps
Registers: [ 1256 1 940 940 256 939 ]
The elves hope you are satisfied with your result.
```

or to set registers

```
$ ./elfx examples/day19-tuned.elfcode 0 0 0 0 0 10551339
ip: 4
read 35 lines
Completed in 375601589 steps
Registers: [ 16137576 1 3249 10556001 99 10551339 ]
The elves hope you are satisfied with your result.
```
