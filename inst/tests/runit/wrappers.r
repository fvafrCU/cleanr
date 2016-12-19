test_files <- function() {
    RUnit::checkTrue(check_file(system.file("source", "R", "checks.R",
                                     package = "cleanr"))
    )
    RUnit::checkTrue(check_file(system.file("source", "R", "wrappers.R",
                                     package = "cleanr"), max_num_arguments = 8)
    )
    RUnit::checkException(check_file(system.file("source", "R",
                                                     "wrappers.R",
                                                     package = "cleanr"))
    )
    RUnit::checkException(check_file(system.file("source", "R",
                                                     "wrappers.R",
                                                     package = "cleanr"),
                                     max_file_length = 10)
    )
    RUnit::checkException(check_file(system.file("source", "R",
                                                     "wrappers.R",
                                                     package = "cleanr"),
                                     max_file_width = 10)
    )
    RUnit::checkException(check_file(system.file("source", "R",
                                                     "wrappers.R",
                                                     package = "cleanr"),
                                     max_line_width = 10)
    )
    RUnit::checkException(check_file(system.file("source", "R",
                                                     "wrappers.R",
                                                     package = "cleanr"),
                                     silly_thing = 10)
    )
}

test_directories <- function() {
    RUnit::checkException(check_directory(system.file("source", "R",
                                                     package = "cleanr"),
                     max_file_length = 0)
    )
    RUnit::checkTrue(check_directory(system.file("source", "R",
                                                     package = "cleanr"),
                    max_num_arguments = 8, max_file_width = 100,
                    check_return = FALSE)
    )
}

test_functions_in_file <- function() {
    file <- system.file("source", "R", "checks.R", package = "cleanr")
    RUnit::checkTrue(check_functions_in_file(file))
    RUnit::checkException(check_functions_in_file(file, max_line_width = 10))
}
test_function_layout <- function() {
    RUnit::checkTrue(check_function_layout(check_line_width))
    RUnit::checkException(check_function_layout(check_line_width,
                                                max_line_width = 10))
}
