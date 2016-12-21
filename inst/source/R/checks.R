#' @include internals.R
NULL

#' @include utils.R
NULL

#' Function Checks
#'
#' A set of tiny functions to check that functions adhere to a layout style.
#' A function should have a clear layout, it should
#' \itemize{
#'   \item not have too many arguments,
#'   \item not have too many levels of nesting,
#'   \item neither have too many lines nor
#'   \item have too many lines of code,
#'   \item not have lines too wide and
#'   \item explicitly \code{\link{return}} an object.
#' }
#'
#' In case of a fail all \code{\link{function_checks}} \code{\link{throw}} a
#' condition of class c("cleanr", "error", "condition").
#'
#' @section Warning: \code{\link{check_return}} just \code{\link{grep}}s for a
#' for a line starting with a \code{\link{return}} statemtent (ah, see the code
#' for the real thing).
#' This doesn't ensure that \emph{all} \code{\link{return}} paths from the
#' function are explicit and it may miss a \code{\link{return}} path after a
#' semicolon.
#' It just checks if you use \code{\link{return}} at all.
#'
#' @author Andreas Dominik Cullmann, <adc-r@@arcor.de>
#' @param object The function to be checked.
#' Should have been sourced with keep.source = TRUE (see
#' \code{\link{get_function_body}}).
#' @return invisible(TRUE), but see \emph{Details}.
#' @name function_checks
#' @examples
#' print(check_num_arguments(check_num_arguments))
#' print(check_nesting_depth(check_nesting_depth))
#' print(check_num_lines(check_num_lines))
#' print(check_num_lines_of_code(check_num_lines_of_code))
#' print(check_return(check_return))
#' # R reformats functions on import (see
#' # help(get_function_body, package = "cleanr")), so we need 90 characters:
#' print(check_line_width(check_line_width, max_line_width = 90))
NULL


#' @rdname function_checks
#' @param max_num_arguments The maximum number of arguments accepted. 
#' Set (preferably via \code{\link{set_cleanr_options}}) to \code{NULL} or
#' \code{FALSE} to disable the check.
#' @export
check_num_arguments <- function(object,
                                max_num_arguments = gco("max_num_arguments")) {
    if (is_not_false(max_num_arguments, where = environment())) {
        checkmate::checkFunction(object)
        checkmate::qassert(max_num_arguments, "N1")
        num_arguments <- length(formals(object))
        if (num_arguments > max_num_arguments)
            throw(paste("found", num_arguments,
                        "arguments, max_num_arguments was", max_num_arguments))
    }
    return(invisible(TRUE))
}

#' @rdname function_checks
#' @param max_nesting_depth The maximum nesting depth accepted.
#' Set (preferably via \code{\link{set_cleanr_options}}) to \code{NULL} or
#' \code{FALSE} to disable the check.
#' @export
check_nesting_depth <- function(object,
                                max_nesting_depth = gco("max_nesting_depth")) {
    if (is_not_false(max_nesting_depth, where = environment())) {
        checkmate::checkFunction(object)
        checkmate::qassert(max_nesting_depth, "N1")
        function_body <- get_function_body(object)
        # break if no braces in function
        if (! any (grepl("}", function_body, fixed = TRUE)))
            return(invisible(TRUE))
        braces <- paste(gsub("\\", "",
                             gsub("[^\\{\\}]", "", function_body),
                             fixed = TRUE),
                        collapse = "")
        # the first (opening) brace is from the function definition,
        # so we skip it via substring
        consectutive_openings <- strsplit(substring(braces, 2), "}",
                                          fixed = TRUE)[[1]]
        nesting_depths <- nchar(consectutive_openings)
        nesting_depth <- max(nesting_depths)
        if (nesting_depth > max_nesting_depth)
            throw(paste0("found nesting depth ", nesting_depth,
                         ", max_nesting_depth was ", max_nesting_depth))
    }
    return(invisible(TRUE))
}

#' @rdname function_checks
#' @param max_lines The maximum number of lines accepted.
#' Set (preferably via \code{\link{set_cleanr_options}}) to \code{NULL} or
#' \code{FALSE} to disable the check.

#' @export
check_num_lines <- function(object, max_lines = gco("max_lines")) {
    if (is_not_false(max_lines, where = environment())) {
        checkmate::checkFunction(object)
        checkmate::qassert(max_lines, "N1")
        function_body <- get_function_body(object)
        num_lines  <- length(function_body)
        if (num_lines > max_lines)
            throw(paste("found", num_lines, "lines, max_lines was", max_lines))
    }
    return(invisible(TRUE))
}

#' @rdname function_checks
#' @param max_lines_of_code The maximum number of lines of code accepted.
#' Set (preferably via \code{\link{set_cleanr_options}}) to \code{NULL} or
#' \code{FALSE} to disable the check.
#' @export
check_num_lines_of_code <- function(object,
                                    max_lines_of_code =
                                        gco("max_lines_of_code")) {
    if (is_not_false(max_lines_of_code, where = environment())) {
        checkmate::checkFunction(object)
        checkmate::qassert(max_lines_of_code, "N1")
        function_body <- get_function_body(object)
        line_is_comment_pattern <- "^\\s*#"
        lines_of_code <- grep(line_is_comment_pattern, function_body,
                              value = TRUE, invert = TRUE)
        num_lines_of_code <-  length(lines_of_code)
        if (num_lines_of_code > max_lines_of_code)
            throw(paste("found", num_lines_of_code,
                        "lines of code, max_lines_of_code was",
                        max_lines_of_code))
    }
    return(invisible(TRUE))
}

#' @rdname function_checks
#' @param max_line_width The maximum line width accepted.
#' Set (preferably via \code{\link{set_cleanr_options}}) to \code{NULL} or
#' \code{FALSE} to disable the check.
#' @export
check_line_width <- function(object,
                             max_line_width = gco("max_line_width")) {
    if (is_not_false(max_line_width, where = environment())) {
        checkmate::checkFunction(object)
        checkmate::qassert(max_line_width, "N1")
        function_body <- get_function_body(object)
        line_widths <-  nchar(function_body)
        if (any(line_widths > max_line_width)) {
            long_lines_index <- line_widths > max_line_width
            long_lines <- seq(along = function_body)[long_lines_index]
            throw(paste("line ", long_lines, ": found width ",
                        line_widths[long_lines_index], " max_line_width was ",
                        max_line_width,
                        sep = "", collapse = "\n")
            )
        }
    }
    return(invisible(TRUE))
}

#' @rdname function_checks
#' @param check_return 
#' Set (preferably via \code{\link{set_cleanr_options}}) to \code{NULL} or
#' \code{FALSE} to disable the check.
#' @export
check_return <- function(object,
                         check_return = gco("check_return")) {
    if (is_not_false(check_return, where = environment())) {
        checkmate::checkFunction(object)
        message_string <- paste("Just checking for a line starting with a ",
                                "return statement.\n",
                                "This is no check for all return paths ",
                                "being explicit.")
        warning(message_string)
        checkmate::checkFunction(object)
        function_body <- body(object)  # body gives us the statements line
        # by line, some_command;   return(somewhat) will be matched
        # by: ^\\s*return\\(
        if (! any(grepl("^\\s*return\\(", function_body)))
            throw("found no return() statement at all.")
    }
    return(invisible(TRUE))
}

#' File Checks
#'
#' A set of tiny functions to check that files adhere to a layout style.
#' A file should have a clear layout, it should
#' \itemize{
#'   \item mot have too many lines and
#'   \item not have lines too wide.
#' }
#'
#' In case of a fail all \code{\link{file_checks}} \code{\link{throw}} a
#' condition of class c("cleanr", "error", "condition").
#'
#'
#' @author Andreas Dominik Cullmann, <adc-r@@arcor.de>
#' @param path Path to the file to be checked.
#' @return invisible(TRUE), but see \emph{Details}.
#' @name file_checks
#' @examples
#' print(check_file_width(system.file("source", "R", "checks.R",
#'                                     package = "cleanr")))
#' print(check_file_length(system.file("source", "R", "checks.R",
#'                                     package = "cleanr"),
#'                                     max_file_length = 300))
NULL

#' @rdname file_checks
#' @param max_file_width The maximum line width accepted.
#' Set (preferably via \code{\link{set_cleanr_options}}) to \code{NULL} or
#' \code{FALSE} to disable the check.
#' @export
check_file_width <- function(path,
                             max_file_width = gco("max_file_width")) {
    if (is_not_false(max_file_width, where = environment())) {
        checkmate::qassert(path, "S1")
        checkmate::qassert(max_file_width, "N1")
        file_content <- readLines(path)
        line_widths <-  nchar(file_content)
        if (any(line_widths > max_file_width)) {
            long_lines_index <- line_widths > max_file_width
            throw(paste0(path, ": line ",
                         seq(along = file_content)[long_lines_index],
                         " counts ", line_widths[long_lines_index],
                         " characters.",
                         collapse = "\n")
            )
        }
    }
    return(invisible(TRUE))
}

#' @rdname file_checks
#' @param max_file_length The maximum number of lines accepted.
#' Set (preferably via \code{\link{set_cleanr_options}}) to \code{NULL} or
#' \code{FALSE} to disable the check.
#' @export
check_file_length <- function(path,
                              max_file_length = gco("max_file_length")) {
    if (is_not_false(max_file_length, where = environment())) {
        checkmate::qassert(path, "S1")
        checkmate::qassert(max_file_length, "N1")
        file_content <- readLines(path)
        num_lines <- length(file_content)
        if (num_lines > max_file_length) {
            throw(paste0(path, ": ", num_lines, " lines in file.",
                         collapse = "\n"))
        }
    }
    return(invisible(TRUE))
}
