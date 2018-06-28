library(combineR)
library(dplyr)
library(magrittr)
context("Helper functions")

a <- data_frame(a = c(1:3, NA), b = c(1:3, 1), c = 1:4)

test_that("add suffix doesn't change keys", {
  expect_equal(names(add_suffix(a, suffix = "suf")), c("a_suf", "b_suf", "c_suf"))
  expect_equal(names(add_suffix(a, suffix = "suf", keys = "a")), c("a", "b_suf", "c_suf"))
})
