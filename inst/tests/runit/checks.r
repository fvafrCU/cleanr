test_num_arguments <- function() {
    RUnit::checkTrue(cleanr::check_num_arguments(apply))
    RUnit::checkException(cleanr::check_num_arguments(apply,
                                                      max_num_arguments = 1))
}

test_check_return <- function() {
    RUnit::checkTrue(cleanr::check_return(cleanr::check_return))
}

test_file_width <- function() {
    file <- system.file("source", "R", "checks.R", package = "cleanr")
    RUnit::checkTrue(check_file_width(file))
    RUnit::checkException(check_file_width(file, max_file_width = 10))
}
