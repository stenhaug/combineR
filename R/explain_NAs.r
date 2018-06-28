#' Given one dataset, find the number of NA values in each column for that dataset
#'
#' @description Given one dataset, find the number of NA values in each column for that dataset. Outputs a sentence, a data frame, and two plots
#'
#' @param dataframe Enter a dataset
#'
#' @importFrom magrittr %>%
#' @importFrom purrr map_df
#' @importFrom reshape melt.list
#' @importFrom dplyr arrange desc rename mutate
#' @importFrom ggplot2 ggplot aes geom_col coord_flip theme_bw labs scale_y_continuous
#' @importFrom stats reorder
#' @export
#'
#' @examples
#' explain_NAs(math)
#' explain_NAs(math)[[2]] # gives only the second part, which is the data frame
#' explain_NAs(math)[[3]] # gives only the third part, which is the first plot

##################
# kjerman code
##################

explain_NAs <- function(dataframe) {
    
    # error check
    if (!is.data.frame(dataframe)) {
        stop("Not all inputs are data frames.")
        break
    }
    
    # Tells the user about what this does and the total number of rows
    a <- (paste0("Here are the NA values in each column of the given dataframe, you have ", nrow(dataframe), " total rows in your dataset"))
    
    # Creates a data frame of all columns in the data set, the count of their NA values, and the percentage of the total rows that that is
    b <- dataframe %>%
    map_df(function(x) sum(is.na(x))) %>%
    reshape::melt.list(.) %>%
    arrange(desc(value)) %>%
    rename(
    variable = L1,
    number_of_NA_values = value
    ) %>%
    mutate(percentage_of_total_dataset = round((number_of_NA_values / nrow(dataframe) * 100), digits = 2))
    
    # Visualizes this
    c <- b %>%
    ggplot(aes(reorder(variable, number_of_NA_values), number_of_NA_values)) +
    geom_col() +
    coord_flip() +
    theme_bw() +
    labs(
    title = "Number of NA Values for Each Column in Your Data Set",
    y = "Count of NA Values",
    x = "Columns in the Data Set"
    )
    
    d <- b %>%
    ggplot(aes(reorder(variable, percentage_of_total_dataset), percentage_of_total_dataset)) +
    geom_col() +
    coord_flip() +
    theme_bw() +
    labs(
    title = "Percentage of NA Values in Each Column of Your Data Set",
    y = "Percentage of NA Values in the Data Set",
    x = "Columns in the Data Set"
    ) +
    scale_y_continuous(labels = function(x) paste0(x, "%"))
    
    return(list(a, b, c, d))
}
