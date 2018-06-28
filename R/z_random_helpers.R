#' Helper functions when creating get_all_missing()
#'
#' @description Helper functions when creating get_all_missing(). Adds a suffix
#'
#' @param df a data frame
#' @param suffix a suffix to add
#' @param keys the joining keys
#'
#' @importFrom magrittr %>%
#' @export
add_suffix <- function(df, suffix, keys = c()){
  suffix_location <- which(!(names(df) %in% keys))
  names(df)[suffix_location] <- paste0(names(df)[suffix_location], "_", suffix)
  df
}
#'
#' Helper functions when creating get_all_missing()
#'
#' @description Helper functions when creating get_all_missing(). Tallys the missing entries
#'
#' @param df a data frame
#' @param keys the joining keys
#'
#' @importFrom dplyr intersect group_by_ summarise_all ungroup
#' @export
tally_missing <- function(df, keys){
  keys <- intersect(names(df), keys)

  df %>%
    group_by_(.dots = keys) %>%
    summarise_all(~ sum(is.na(.))) %>%
    ungroup()
}
#'
#' Helper functions when creating get_all_missing()
#'
#' @description Helper functions when creating get_all_missing(). Conducts a full join
#'
#' @param x the first data frame
#' @param y the second data frame
#'
#' @importFrom dplyr full_join
#' @export
fullJoin <- function(x, y){suppressMessages(full_join(x, y))}
#'
#' Helper functions when creating get_all_missing()
#'
#' @description Helper functions when creating get_all_missing(). Conducts a left join
#'
#' @param x the first data frame
#' @param y the second data frame
#'
#' @importFrom dplyr left_join
#' @export
leftJoin <- function(x, y){suppressMessages(left_join(x, y))}
