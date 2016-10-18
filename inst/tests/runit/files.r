test_files <- function() {
    RUnit::checkTrue(check_file(system.file("source", "R", "checks.R",
                                     package = "cleanr"))
    )
    RUnit::checkTrue(check_file(system.file("source", "R", "wrappers.R",
                                     package = "cleanr"), max_arguments = 6)
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
