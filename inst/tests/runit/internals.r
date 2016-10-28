test_get_function_body <- function() {
    assign("f", function() print(3))
    result <- cleanr:::get_function_body(f)
    expectation <- "print(3)"
    print(result)
    RUnit::checkIdentical(result, expectation)
}
