#' See how many unique values of the joining key exist in your data.
#'
#' @description Give this function as many data frames as you want and the key and it tells you how many unique values are in each data frame for the keys you specify.
#'
#' @param keys the primary key or other key you wish to analyze
#' @param df_names the data frame names
#' @param ... enter as many data frames as you would like
#'
#' @importFrom magrittr %>%
#' @importFrom purrr map_lgl set_names map2 reduce
#' @importFrom dplyr count_ intersect mutate_at vars setdiff
#' @export
#'
#' @examples
#' count_keys(demographics, math, ell, keys = c("student_id", "year"))
#' count_keys(list(demographics, math, ell),
#'      df_names = c("demographics", "math", "ell"),
#'      keys = c("student_id", "year"))
#'

##################
# stenhaug code
##################

count_keys <- function(..., df_names = NULL, keys){
  # grab inputs
  df_list <- list(...)
  if (!is.null(df_names)){
    df_list <- df_list[[1]]
  }

  if (is.null(df_names)){
    df_names <-  as.character(as.list(match.call()))
    df_names <- df_names[c(-1, -length(df_names))]
  }

  # error check
  if(!all(df_list %>% map_lgl(~ "data.frame" %in% class(.)))){
    stop("Not all inputs are data frames.")
  } else if (!all(df_list %>% map_lgl(~ any(names(.) %in% keys)))){
    stop("There is at least one data frame that does not contain any of the keys.")
  } else if (length(df_list) != length(df_names)){
    stop("Lengths of data frames and names do not match.")
  }

  # count keys for one of the data frames
  count_keys_single <- function(df, df_name){
    df %>%
      count_(intersect(keys, names(.))) %>%
      set_names(intersect(keys, names(.)), df_name)
  }

  # to clean up output
  na_to_0 <- function(x){x[is.na(x)] <- 0; as.integer(x)}

  # apply functions to each dataframe
  map2(df_list, df_names, count_keys_single) %>%
    reduce(fullJoin) %>%
    mutate_at(vars(setdiff(names(.), keys)), na_to_0)
}
