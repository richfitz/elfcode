context("ops")

test_that("banr", {
  p <- elfcode_compile(c("#ip 0", "banr 1 2 0"))
  r <- elfcode_run(p, c(0, 5, 3, 0, 0, 0))
  expect_identical(r, list(c(1L, 5L, 3L, 0L, 0L, 0L), 1))
})


test_that("borr", {
  p <- elfcode_compile(c("#ip 0", "borr 1 2 0"))
  r <- elfcode_run(p, c(0, 5, 3, 0, 0, 0))
  expect_identical(r, list(c(7L, 5L, 3L, 0L, 0L, 0L), 1))
})


test_that("gtri", {
  p <- elfcode_compile(c("#ip 0", "gtri 1 2 0"))
  r <- elfcode_run(p, c(0, 5, 3, 0, 0, 0))
  expect_identical(r, list(c(1L, 5L, 3L, 0L, 0L, 0L), 1))
})


test_that("eqir", {
  p <- elfcode_compile(c("#ip 0", "eqir 1 1 0"))
  r <- elfcode_run(p, c(0, 1, 0, 0, 0, 0))
  expect_identical(r, list(c(1L, 1L, 0L, 0L, 0L, 0L), 1))
})
