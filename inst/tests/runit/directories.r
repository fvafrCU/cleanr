test_directories <- function() {
    RUnit::checkException(check_directory(system.file("source", "R",
                                                     package = "cleanr"),
                     max_file_length = 0)
    )
    RUnit::checkTrue(check_directory(system.file("source", "R",
                                                     package = "cleanr"),
                    max_arguments = 6, max_file_width = 100)
    )
}
