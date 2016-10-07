test_files <- function() {
    checkTrue(check_file(system.file('source', 'R', 'checks.r',
                                     package = 'cleanr'))
    )
    checkTrue(check_file(system.file('source', 'R', 'wrappers.r',
                                     package = 'cleanr'), max_arguments = 6)
    )
    checkException(check_file(system.file('source', 'R', 'wrappers.r',
                                     package = 'cleanr'))
    )
}
