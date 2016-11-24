test_options <- function() {
    set_cleanr_options(max_file_width = 100)
    RUnit::checkIdentical(get_cleanr_options("max_file_width"),
                          c("max_file_width" = 100))
    RUnit::checkIdentical(get_cleanr_options("max_file_width",
                                             flatten_list = FALSE),
                          list("max_file_width" = 100))
    RUnit::checkIdentical(get_cleanr_options("max_file_width",
                                             remove_names = TRUE), c(100))
    RUnit::checkIdentical(get_cleanr_options("max_file_width",
                                             remove_names = TRUE,
                                             flatten_list = FALSE), list(100))
    options("cleanr" = list(max_lines = 30, max_lines_of_code = 20))
    set_cleanr_options()
    RUnit::checkIdentical(get_cleanr_options(),
                          c(max_lines = 30, max_lines_of_code = 20))
    set_cleanr_options(max_lines = 100, max_line_width = 20, overwrite = FALSE)
    RUnit::checkIdentical(get_cleanr_options(),
                          c(max_lines = 30, max_lines_of_code = 20,
                            max_line_width = 20))
    set_cleanr_options(max_lines = 40, max_line_width = 80, overwrite = TRUE)
    RUnit::checkIdentical(get_cleanr_options(),
                          c(max_lines = 40, max_lines_of_code = 20,
                            max_line_width = 80))
    options("cleanr" = list(max_lines = 30, max_lines_of_code = 20))
    set_cleanr_options(max_lines_of_code = 40, overwrite = TRUE)
    RUnit::checkIdentical(get_cleanr_options(),
                          c(max_lines = 40, max_lines_of_code = 40))
    set_cleanr_options(reset = TRUE)
}
