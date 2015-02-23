check_num_arguments <- function(object,
                                maximum = get_coldr_options('max_arguments')) {
    qassert(object, 'f')
    qassert(maximum, 'N1')
    num_arguments <- length(formals(object))
    if (num_arguments > maximum)
        throw(paste('found', num_arguments, 'arguments, maximum was', maximum))
    return(invisible(TRUE))
}

check_nesting_depth <- function(object,
                                maximum = get_coldr_options('max_nesting_depth')
                                ) {
    qassert(object, 'f')
    qassert(maximum, 'N1')
    function_body <- get_function_body(object)
    # break if no braces in function
    if (! any (grepl('}', function_body, fixed = TRUE))) return(invisible(TRUE))
    braces <- paste(gsub('\\', '',
                         gsub("[^\\{\\}]", "", function_body),
                         fixed = TRUE),
                    collapse = '')
    # the first (opening) brace is from the function definition,
    # so we skip it via substring
    consectutive_openings <- strsplit(substring(braces, 2), '}',
                                      fixed = TRUE)[[1]]
    nesting_depths <- nchar(consectutive_openings)
    nesting_depth <- max(nesting_depths)
    if (nesting_depth > maximum)
        throw(paste('found nesting depth ', nesting_depth, ', maximum was ',
                    maximum, sep = ''))
    return(invisible(TRUE))
}

check_num_lines <- function(object,
                            maximum = get_coldr_options('max_lines')) {
    qassert(object, 'f')
    qassert(maximum, 'N1')
    function_body <- get_function_body(object)
    num_lines  <- length(function_body)
    if (num_lines > maximum)
        throw(paste('found', num_lines, 'lines, maximum was', maximum))
    return(invisible(TRUE))
}

check_num_lines_of_code <- function(object,
                                    maximum =
                                    get_coldr_options('max_lines_of_code')) {
    qassert(object, 'f')
    qassert(maximum, 'N1')
    function_body <- get_function_body(object)
    line_is_comment_pattern <- '^\\s*#'
    lines_of_code <- grep(line_is_comment_pattern, function_body,
                          value = TRUE, invert = TRUE)
    num_lines_of_code <-  length(lines_of_code)
    if (num_lines_of_code > maximum)
        throw(paste('found', num_lines_of_code, 'lines of code, maximum was',
                    maximum))
    return(invisible(TRUE))
}

check_line_width <- function(object,
                            maximum = get_coldr_options('max_line_width')) {
    qassert(object, 'f')
    qassert(maximum, 'N1')
    function_body <- get_function_body(object)
    line_widths <-  nchar(function_body)
    if (any(line_widths > maximum)) {
        long_lines_index <- line_widths > maximum
        long_lines <- seq(along = function_body)[long_lines_index]
        throw(paste('line ', long_lines, ': found width ',
                    line_widths[long_lines_index], ' maximum was ', maximum,
                    sep = '', collapse = '\n')
        )
    }
    return(invisible(TRUE))
}

check_return <- function(object) {
    message_string <- paste('Just checking for a line starting with a return', 
                          'statement.\n  This is no check for all return paths',
                          'being explicit.')
    warning(message_string)
    qassert(object, 'f')
    function_body <- body(object)  # body gives us the statements line by line,
    # some_command;   return(somewhat) will be matched by '^\\s*return\\('
    if (! any(grepl('^\\s*return\\(', function_body)))
        throw('found no return() statement at all.')
    return(invisible(TRUE))
}

check_file_layout <- function(path,
                              max_length = get_coldr_options('max_length'),
                              max_width = get_coldr_options('max_width')) {
    qassert(path, 'S1')
    qassert(max_length, 'N1')
    qassert(max_width, 'N1')
    file_content <- readLines(path)
    line_widths <-  nchar(file_content)
    num_lines <- length(file_content)
    if (num_lines > max_length) {
        throw(paste(path, ": ",
                         num_lines, " lines in file.",
                         sep = '' )
        )
    }
    if (any(line_widths > max_width)) {
        long_lines_index <- line_widths > max_width
        throw(paste(path, ": line ",
                         seq(along = file_content)[long_lines_index],
                         ' counts ', line_widths[long_lines_index],
                         ' characters.',
                         sep = '')
        )
    }
    return(invisible(TRUE))
}
