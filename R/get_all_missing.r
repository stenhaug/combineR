#' Get insight onto where missing values will enter when joining your data frames
#'
#' @description Enter data frames and a joining key and generate a table that shows you the variable, number of NA values in the data frames, and number of NA values introduced when full joining the data frames. Additionally, see this output in two different bar plots called 'Coded Missing Values Within Datasets' and 'Missing Values In Datasets Resulting From Joins'. This function enables you to specify as many data frames as you wish. You specify the keys, where each data frame must have at least one of the keys in it. The function gives insight into missing values and if they come from your current data or result from the join.
#'
#' @param df_names the data frame names
#' @param keys the primary key in your data frames
#' @param ... enter as many data frames as you would like
#'
#' @importFrom magrittr %>%
#' @importFrom purrr map_lgl map2 map map_int
#' @importFrom dplyr setdiff mutate bind_rows distinct
#' @importFrom tibble data_frame
#' @importFrom ggplot2 ggplot aes geom_col coord_flip theme_bw labs
#' @importFrom stats reorder
#' @export
#'
#' @examples
#' get_all_missing(demographics, math, ell, keys = c("student_id", "year"))
#' get_all_missing(list(demographics, math, ell),
#'      df_names = c("demographics", "math", "ell"),
#'      keys = c("student_id", "year"))

##################
# start stenhaug code
##################

get_all_missing <- function(..., df_names = NULL, keys){
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

  missing <- map2(df_list, df_names, add_suffix, keys) %>% map(tally_missing, keys)
  missing_names <- missing %>% map(~ setdiff(names(.), keys))
  the_count_keys <- count_keys(df_list, df_names = df_names, keys = keys)

    missingTable <- data_frame(df = rep(missing, missing_names %>% map_int(length)),
        thename = unlist(missing_names)) %>%
        mutate(what = map2(df, thename, get_missings, the_count_keys, keys)) %>%
        .$what %>%
        bind_rows() %>%
        distinct()
        
##################
# start kjerman code
##################

    plot1 <- missingTable %>%
        ggplot(aes(reorder(variable, -coded_missing), coded_missing)) +
        geom_col() +
        coord_flip() +
        theme_bw() +
        labs(
        title = "Coded Missing Values Within Datasets",
        y = "Number of Missing Variables already in your Dataset",
        x = "Variable_Dataset"
        )

    plot2 <- missingTable %>%
        ggplot(aes(reorder(variable, -join_missing), join_missing)) +
        geom_col() +
        coord_flip() +
        theme_bw() +
        labs(
        title = "Missing Values In Datasets Resulting From Joins",
        y = "Number of Missing Variables Created By Joining",
        x = "Variable_Dataset"
        )

return(list(missingTable, plot1, plot2))
}
