test_num_arguments <- function() {
    RUnit::checkTrue(cleanr::check_num_arguments(apply))
    RUnit::checkException(cleanr::check_num_arguments(apply, maximum = 1))
}
