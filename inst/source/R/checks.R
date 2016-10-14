#' @include utils.R
NULL

#' function checks
#'
#' A set of tiny functions to check that functions adhere to a layout style.
#'
#' A function should have a clear layout, it should
#' \itemize{
#'   \item not have too many arguments,
#'   \item not have nestings too deep,
#'   \item neither have too many lines nor
#'   \item have too many lines of code,
#'   \item not have lines too wide and
#'   \item explicitly \code{\link{return}} an object.
#' }
#' At least this is what I think. Well, some others too.
#'
#' All of the functions test whether their requirement is met (some layout
#' feature such as number of arguments, nesting depth, line width is not greater
#' than the maximum given). In case of a fail all \code{\link{throw}} a
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
#' @author Dominik Cullmann, <dominik.cullmann@@forst.bwl.de>
#' @param object The function to be checked.
#' Should have been sourced with keep.source = TRUE (see
#' \code{\link{get_function_body}}.
#' @param maximum The maximum against which the function is to be tested.
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
#' print(check_line_width(check_line_width, maximum = 90))
NULL


#' @rdname function_checks
#' @export
check_num_arguments <- function(object,
                                maximum = get_cleanr_options("max_arguments")) {
    checkmate::checkFunction(object)
    checkmate::qassert(maximum, "N1")
    num_arguments <- length(formals(object))
    if (num_arguments > maximum)
        throw(paste("found", num_arguments, "arguments, maximum was", maximum))
    return(invisible(TRUE))
}

#' @rdname function_checks
#' @export
check_nesting_depth <- function(object,
                                maximum =
                                    get_cleanr_options("max_nesting_depth")) {
    checkmate::checkFunction(object)
    checkmate::qassert(maximum, "N1")
    function_body <- get_function_body(object)
    # break if no braces in function
    if (! any (grepl("}", function_body, fixed = TRUE))) return(invisible(TRUE))
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
    if (nesting_depth > maximum)
        throw(paste("found nesting depth ", nesting_depth, ", maximum was ",
                    maximum, sep = ""))
    return(invisible(TRUE))
}

#' @rdname function_checks
#' @export
check_num_lines <- function(object,
                            maximum = get_cleanr_options("max_lines")) {
    checkmate::checkFunction(object)
    checkmate::qassert(maximum, "N1")
    function_body <- get_function_body(object)
    num_lines  <- length(function_body)
    if (num_lines > maximum)
        throw(paste("found", num_lines, "lines, maximum was", maximum))
    return(invisible(TRUE))
}

#' @rdname function_checks
#' @export
check_num_lines_of_code <- function(object,
                                    maximum =
                                    get_cleanr_options("max_lines_of_code")) {
    checkmate::checkFunction(object)
    checkmate::qassert(maximum, "N1")
    function_body <- get_function_body(object)
    line_is_comment_pattern <- "^\\s*#"
    lines_of_code <- grep(line_is_comment_pattern, function_body,
                          value = TRUE, invert = TRUE)
    num_lines_of_code <-  length(lines_of_code)
    if (num_lines_of_code > maximum)
        throw(paste("found", num_lines_of_code, "lines of code, maximum was",
                    maximum))
    return(invisible(TRUE))
}

#' @rdname function_checks
#' @export
check_line_width <- function(object,
                            maximum = get_cleanr_options("max_line_width")) {
    checkmate::checkFunction(object)
    checkmate::qassert(maximum, "N1")
    function_body <- get_function_body(object)
    line_widths <-  nchar(function_body)
    if (any(line_widths > maximum)) {
        long_lines_index <- line_widths > maximum
        long_lines <- seq(along = function_body)[long_lines_index]
        throw(paste("line ", long_lines, ": found width ",
                    line_widths[long_lines_index], " maximum was ", maximum,
                    sep = "", collapse = "\n")
        )
    }
    return(invisible(TRUE))
}

#' @rdname function_checks
#' @export
check_return <- function(object) {
    message_string <- paste("Just checking for a line starting with a return",
                          "statement.\n  This is no check for all return paths",
                          "being explicit.")
    warning(message_string)
    checkmate::checkFunction(object)
    function_body <- body(object)  # body gives us the statements line by line,
    # some_command;   return(somewhat) will be matched by "^\\s*return\\("
    if (! any(grepl("^\\s*return\\(", function_body)))
        throw("found no return() statement at all.")
    return(invisible(TRUE))
}

#' file checks
#'
#' A set of tiny functions to check that files adhere to a layout style.
#'
#' A file should have a clear layout, it should
#' \itemize{
#'   \item mot have too many lines and
#'   \item not have lines too wide.
#' }
#' At least this is what I think. Well, some others too.
#'
#' All of the functions test whether their requirement is met. 
#' In case of a fail all \code{\link{throw}} a
#' condition of class c("cleanr", "error", "condition").
#'
#'
#' @author Dominik Cullmann, <dominik.cullmann@@forst.bwl.de>
#' @param path The path to the file to be checked.
#' @param maximum The maximum against which the file is to be tested.
#' @return invisible(TRUE), but see \emph{Details}.
#' @name file_checks
#' @examples
#' print(check_file_width(system.file("source", "R", "checks.R",
#'                                     package = "cleanr")))
#' print(check_file_length(system.file("source", "R", "checks.R",
#'                                     package = "cleanr"), maximum = 300))
NULL

#' @rdname file_checks
#' @export
check_file_width <- function(path,
                            maximum = get_cleanr_options("max_file_width")) {
    checkmate::qassert(path, "S1")
    checkmate::qassert(maximum, "N1")
    file_content <- readLines(path)
    line_widths <-  nchar(file_content)
    if (any(line_widths > maximum)) {
        long_lines_index <- line_widths > maximum
        throw(paste0(path, ": line ",
                         seq(along = file_content)[long_lines_index],
                         " counts ", line_widths[long_lines_index],
                         " characters.",
                         collapse = "\n")
        )
    }
    return(invisible(TRUE))
}

#' @rdname file_checks
#' @export
check_file_length <- function(path,
                            maximum = get_cleanr_options("max_line_width")) {
    checkmate::qassert(path, "S1")
    checkmate::qassert(maximum, "N1")
    file_content <- readLines(path)
    num_lines <- length(file_content)
    if (num_lines > maximum) {
        throw(paste0(path, ": ",
                         num_lines, " lines in file.",
                         collapse = "\n")
        )
    }
    return(invisible(TRUE))
}
