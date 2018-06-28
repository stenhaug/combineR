library(combineR)
library(dplyr)
library(magrittr)
context("Get all missing functionality")

a <- data_frame(a = c(1:3, NA), b = c(1:3, 1), c = 1:4)
b <- data_frame(a = c(1:3, NA), b = c(1:3, NA), c = 2:5)

test_that("get all missing throws an error with poorly defined columns.", {
  expect_error(get_all_missing(a, b, keys = "a"))
  expect_error(get_all_missing(a, b, keys = "b"))
  expect_error(get_all_missing(a, b))
})

test_that("get all missing counts missing correctly", {
  expect_equal(get_all_missing(a, b, keys = "c")[[1]]$join_missing, rep(1, 4))
  expect_equal(get_all_missing(b, a, keys = "c")[[1]]$join_missing, rep(1, 4))
  expect_equal(get_all_missing(a, b, keys = "c")[[1]]$coded_missing, c(0, 0, 1, 1))
  expect_equal(get_all_missing(b, a, keys = "c")[[1]]$coded_missing, c(1, 1, 0, 0))
})
