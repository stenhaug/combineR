#' Find the number of rows, columns, and unique number of rows in your data sets
#'
#' @description Enter as many data frames as you would like and find the number of rows, the number of columns, and the number of unique rows in your data sets
#'
#' @param ... enter as many data frames as you would like
#'
#' @importFrom magrittr %>%
#' @importFrom purrr map_lgl map_int
#' @importFrom tibble data_frame
#' @importFrom dplyr n_distinct
#' @export
#'
#' @examples
#' explain_rows(demographics, math, ell)

##################
# stenhaug code, kjerman initial pass
##################

explain_rows <- function(...) {
  # grab inputs
  df_list <- list(...)
  names <- as.character(as.list(match.call()))[-1]

  # error check
  if(!all(df_list %>% map_lgl(~ "data.frame" %in% class(.)))){
    stop("Not all inputs are data frames.")
  }

  # return output
  data_frame(
    names = names,
    number_of_rows = df_list %>% map_int(nrow),
    number_of_unique_rows = df_list %>% map_int(n_distinct),
    number_of_columns = df_list %>% map_int(ncol)
  )
}
