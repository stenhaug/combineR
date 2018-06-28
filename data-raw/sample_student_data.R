# function to create the data ---------------------------------------------
student_data_sim <- function(n_students = 1000){
  # ---------------- Demographics ----------------
  years <- c(2015, 2016, 2017)

  # need a special function to simulate learning disability in a semi-realistic way
  sim_learning_disability <- function(){
    x <- rep(NA, 3)
    x[1] <- runif(n = 1) < 0.2
    x[2] <- runif(n = 1) < 0.05 + 0.65 * x[1]
    x[3] <- runif(n = 1) < 0.05 + 0.20 * x[1] + 0.45 * x[2]
    x
  }

  # create demographics
  demographics <- babynames %>%
    select(name, sex) %>%
    distinct() %>%
    split(.$sex) %>%
    map(sample_n, size = n_students %/% 2, replace = TRUE) %>% # balance gender
    bind_rows() %>%
    sample_frac() %>% # randomly shuffle dataframe
    mutate(student_id = paste0("S", sample(x = 0:(1000 * n_students), size = n_students))) %>%
    crossing(year = years) %>%
    group_by(student_id) %>%
    mutate(learning_disability = sim_learning_disability()) %>%
    ungroup() %>%
    select(student_id, year, name, sex, learning_disability)

  # ---------------- Math test ----------------
  # function randomly input na values in a vector x with probability p
  random_na <- function(x, p){
    x[runif(length(x)) < p] <- NA
    x
  }

  # create math_test
  math_test <- demographics %>%
    select(student_id, year, learning_disability) %>%
    sample_frac(0.8) %>% # 80% of students took the math test
    mutate(math_score = learning_disability %>% map_dbl(~ rnorm(1, 105 - 15 * ., 15) %>% round()),
           math_score = random_na(math_score, 0.2)) # N(105 - 15 * LD, 15) and 20% of values go missing

  # ---------------- ELL test ----------------
  # Function to have student stop taking test once they score over 100
  first_100 <- function(ell_score){
    rows <- length(ell_score)
    ell_score <- ell_score[!is.na(ell_score)]
    ifelse(suppressWarnings(max(ell_score) >= 100), which(ell_score >= 100)[1], rows)
  }

  # create ell test
  ell_test <- data_frame(student_id = sample(unique(demographics$student_id), round(n_students * 0.4))) %>%
    left_join(demographics, by = "student_id") %>%
    mutate(ell_score = learning_disability %>% map_dbl(~ rnorm(1, 90 - . * 5, 15) %>% round()),
           ell_score = random_na(ell_score, 0.3)) %>% # N(90 - 5 * LD, 15) and 20% of values go missing
    group_by(student_id) %>%
    slice(1:first_100(ell_score)) %>% # stop taking test if get over score of 100
    ungroup()

  # ---------------- Return ----------------
  data_frame(name = c("demographics", "math_test", "ell_test"),
             data = list(demographics, math_test, ell_test)) %>%
    mutate(data = data %>% map(~ arrange(., student_id, year)))
}

# creating data -----------------------------------------------------------
sample_student_data <- student_data_sim(n_students = 10000)

# output data -------------------------------------------------------------
demographics <- sample_student_data$data[[1]]
devtools::use_data(demographics)

math <- sample_student_data$data[[2]]
devtools::use_data(math)

ell <- sample_student_data$data[[3]]
devtools::use_data(ell)


