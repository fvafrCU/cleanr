test_options <- function() {
    # Begin Exclude Linting
    assign("a", 3, envir = .GlobalEnv)
    RUnit::checkTrue(is_not_false(a, envir = .GlobalEnv))
    RUnit::checkTrue(is_not_false(a, null_is_false = FALSE, envir = .GlobalEnv))
    rm("a", envir = .GlobalEnv)
    RUnit::checkTrue(! is_not_false(a, envir = .GlobalEnv))
    RUnit::checkTrue(! is_not_false(a, null_is_false = FALSE,
                                    envir = .GlobalEnv))
    assign("a", NULL, envir = .GlobalEnv)
    RUnit::checkTrue(! is_not_false(a, envir = .GlobalEnv))
    RUnit::checkTrue(is_not_false(a, null_is_false = FALSE, envir = .GlobalEnv))
    # End Exclude Linting
}
