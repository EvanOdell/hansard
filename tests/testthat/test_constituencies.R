library(hansard)
context("constituencies")

test_that("constituencies functions return expected format", {
  skip_on_cran()
  skip_if(Sys.getenv(x = "TRAVIS_R_VERSION_STRING") == "devel")

  ctx <- hansard_constituencies(current = TRUE, verbose = TRUE)
  expect_length(ctx, 7)
  expect_true(tibble::is_tibble(ctx))
  expect_equal(nrow(ctx), 650)
  expect_true(names(ctx)[6] == "started_date_value")
})
