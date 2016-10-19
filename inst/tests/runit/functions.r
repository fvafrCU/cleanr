test_internals <- function() {
    assign("f", function() print(3))
    result <- cleanr:::get_function_body(f)
    expectation <- "print(3)"
    print(result)
    RUnit::checkIdentical(result, expectation)
}
test_functions_in_file <- function() {
    RUnit::checkTrue(check_functions_in_file(system.file("source", "R", "checks.R",
                                                         package = "cleanr")))
    RUnit::checkException(check_functions_in_file(system.file("source", "R", "checks.R",
                                                         package = "cleanr"),
                                                  max_line_width = 10))
}
