test_directories <- function() {
    checkTrue(check_directory(system.file('source', 'R', package = 'cleanr'),
                    max_arguments = 6, max_width = 100)
    )
}
