context("advent of code")

test_that("day19", {
  p <- elfcode_compile(file = "input19.txt")
  res <- elfcode_run(p, max = 7057537)
  expect_identical(res, list(c(1256L, 1L, 940L, 940L, 256L, 939L), 7057536L))
})


test_that("day21", {
  p <- elfcode_compile(file = "input21.txt")
  r1 <- c(11285115, rep(0, 5))
  res <- elfcode_run(p, r = r1, max = 1849)
  expect_identical(res, list(c(11285115L, 11285115L, 30L, 1L, 1L, 1L), 1848L))
})


test_that("day19 - tuned", {
  p <- elfcode_compile(file = "tuned19.txt")
  r <- c(0, 0, 0, 0, 0, 939)
  res <- elfcode_run(p, r = r, max = 18801)
  expect_identical(res, list(c(1256L, 1L, 31L, 961L, 99L, 939L), 18800L))
})
