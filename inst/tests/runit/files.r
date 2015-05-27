test_files <- function() {
    checkTrue(check_file(system.file('source', 'R', 'checks.r',
                                     package = 'coldr'))
    )
    checkTrue(check_file(system.file('source', 'R', 'wrappers.r',
                                     package = 'coldr'), max_arguments = 6)
    )
    checkException(check_file(system.file('source', 'R', 'wrappers.r',
                                     package = 'coldr'))
    )
}
