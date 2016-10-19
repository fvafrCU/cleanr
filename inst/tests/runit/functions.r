test_internals <- function() {
    assign("f", function() print(3))
    result <- cleanr:::get_function_body(f)
    expectation <- "print(2)"
    print(result)
    RUnit::checkIdentical(result, expectation)
}
