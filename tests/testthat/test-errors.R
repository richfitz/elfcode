context("error paths")

test_that("reject unknown opcode", {
  expect_error(compile(c("#ip 0", "divr 0 0 0")),
               "Unknown op code: 'divr'", fixed = TRUE)
  expect_error(compile(c("#ip 0", "mulr 0 0 0", "divr 0 0 0", "seti 0 0 0")),
               "Unknown op code: 'divr'", fixed = TRUE)
})


test_that("reject incorrect instruction length", {
  expect_error(compile(c("#ip 0", "mulr 0 0")),
               "All instructions must be length 3")
  expect_error(compile(c("#ip 0", "mulr 0 0 0 0")),
               "All instructions must be length 3")
})


test_that("malformed code", {
  expect_error(compile(c("hello", "mulr 0 0")),
               "Program does not start with an '#ip' declaration",
               fixed = TRUE)
  expect_error(compile(c("#ip 0", "mulr 0 0 0", "world", "seti 0 0 0")),
               "Program lines must be in the format <oppcode> <registers>",
               fixed = TRUE)
})
