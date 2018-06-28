#' Helper function used in get_all_missing()
#'
#' @description Helper function used in get_all_missing()
#'
#' @param df the data frame
#' @param thename the name of your data frame
#' @param the_count_keys counting keys
#' @param keys the joining keys
#'
#' @importFrom magrittr %>%
#' @importFrom dplyr filter_at vars one_of any_vars select setdiff mutate_all
#' @importFrom tibble data_frame
#' @importFrom stringr str_split
#' @export

##################
# stenhaug code
##################

get_missings <- function(df, thename, the_count_keys, keys){
  zero_to_one <- function(x){x[x == 0] <- 1; as.integer(x)}

  q <- str_split(thename, "_")[[1]]
  q <- q[length(q)]

  join_missing <- the_count_keys %>%
    filter_at(vars(one_of(q)), any_vars(. == 0)) %>%
    select(setdiff(names(.), c(keys, q))) %>%
    mutate_all(zero_to_one) %>%
    apply(1, prod) %>%
    sum()

  if(length(join_missing) == 0){join_missing <- 0}

  tmp <- the_count_keys %>%
    leftJoin(df) %>%
    select(setdiff(names(.), c(keys, q)))  %>%
    filter_at(vars(one_of(thename)), any_vars(. > 0))

  missing <- tmp[[ncol(tmp)]]

  expansion <- tmp[ , -ncol(tmp)] %>%
    mutate_all(zero_to_one) %>%
    apply(1, prod)

  coded_missing <- sum(missing * expansion)

  if(length(coded_missing) == 0){coded_missing <- 0}

  data_frame(variable = thename,
             coded_missing = as.integer(coded_missing),
             join_missing = as.integer(join_missing))
}
