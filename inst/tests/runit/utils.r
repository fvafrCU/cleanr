test_options <- function() {
    assign("a", 3, envir = .GlobalEnv)
    # trick lintr: the alternative would be to disable the object_usage_linter 
    # (see https://github.com/jimhester/lintr/issues/27)
    a <- 2 
    RUnit::checkTrue(is_not_false(a, envir = .GlobalEnv))
    RUnit::checkTrue(is_not_false(a, null_is_false = FALSE, envir = .GlobalEnv))
    rm("a", envir = .GlobalEnv)
    RUnit::checkTrue(! is_not_false(a, envir = .GlobalEnv))
    RUnit::checkTrue(! is_not_false(a, null_is_false = FALSE,
                                    envir = .GlobalEnv))
    assign("a", NULL, envir = .GlobalEnv)
    RUnit::checkTrue(! is_not_false(a, envir = .GlobalEnv))
    RUnit::checkTrue(is_not_false(a, null_is_false = FALSE, envir = .GlobalEnv))
}
