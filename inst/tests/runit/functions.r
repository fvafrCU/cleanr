test_internals <- function() {
    RUnit::checkTrue(cleanr:::get_function_body(function() return(NULL)))
}
