library(combineR)
library(dplyr)
library(magrittr)
context("Explain rows and count keys")

small <- data_frame(a = c(1:3, 1), b = c(1:3, 1))

test_that("explain rows correctly outputs.", {
  expect_identical(explain_rows(small), data_frame(names = "small",
                                               number_of_rows = as.integer(4),
                                               number_of_unique_rows = as.integer(3),
                                               number_of_columns = as.integer(2)))
  expect_error(explain_rows("hello"))
})


test_that("count keys uses key field consistently.", {
  expect_identical(count_keys(small, keys = "a"), data_frame(a = c(1, 2, 3), small = as.integer(c(2, 1, 1))))
  expect_identical(count_keys(small, small, keys = "a"), data_frame(a = c(1, 2, 3), small = as.integer(c(2, 1, 1))))
  expect_error(count_keys(small, small))
  expect_error(count_keys("hello"))
})
