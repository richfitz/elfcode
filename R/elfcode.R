preprocess <- function(lines) {
  lines <- sub("\\s*;;.*$", "", lines)
  lines <- lines[!grepl("^\\s*$", lines)]

  stopifnot(grepl("^#ip [0-9]$", lines[[1]]))
  ip <- lines[[1]]
  lines <- lines[-1L]

  labels <- grep("\\[[A-Z]\\]", lines)
  if (length(labels) > 0L) {
    tmp <- lines[labels + 1]
    names(labels) <- substr(lines[labels], 2, 2)
    lines <- lines[-labels]
    labels <- labels - seq_along(labels) - 1L

    for (l in names(labels)) {
      lines <- gsub(l, labels[[l]], lines)
    }
  }

  c(ip, lines)
}


compile <- function(lines) {
  ops <- c("addr", "addi", "mulr", "muli", "banr", "bani", "borr", "bori",
           "setr", "seti", "gtir", "gtri", "gtrr", "eqir", "eqri", "eqrr")
  re1 <- "^#ip (\\d)"
  re2 <- "^([a-z]+) (\\d+ \\d+ \\d+)"
  p <- sub(re2, "\\1", lines[-1])
  err <- setdiff(p, ops)
  if (length(err) > 0L) {
    stop("Unknown op code: ", paste(sprintf("'%s'", err), collapse = ", "))
  }
  r <- lapply(strsplit(sub(re2, "\\2", lines[-1]), " "), as.integer)
  i <- lengths(r) != 3
  if (any(i)) {
    stop("All instructions must be length 3")
  }
  program <- as.integer(unlist(Map(c, match(p, ops) - 1L, r)))
  ip <- as.integer(sub(re1, "\\1", lines[[1]]))
  ret <- list(ip = ip, program = program)
  class(ret) <- "elfcode"
  ret
}


##' Compile an ElfCode program
##' @title Compile an ElfCode program
##' @param lines Lines of elfcode (one instruction per line)
##' @param file File to read elfcode from
##' @export
elfcode_compile <- function(lines, file = NULL) {
  if (!is.null(file)) {
    lines <- readLines(file)
  }
  compile(preprocess(lines))
}


##' Run an elfcode program
##' @title Run an elfcode program
##' @param elfcode Program, "compiled" by \code{\link{elfcode_compile}}
##' @param r Initial register states
##' @param max Maximium number of steps to run
##' @param print Logical, indicating if we should print
##' @export
elfcode_run <- function(elfcode, r = rep(0, 6), max = 0, print = FALSE) {
  stopifnot(is.numeric(r) && length(r) == 6 && all(is.finite(r)))
  stopifnot(is.numeric(max) && length(max) == 1 && is.finite(max))
  stopifnot(is.logical(print) && length(print) == 1 && is.finite(print))
  stopifnot(inherits(elfcode, "elfcode"))

  r <- as.integer(r)
  max <- as.integer(max)
  res <- .Call(Crun, r, elfcode$ip, elfcode$program, max, print)
  res
}
