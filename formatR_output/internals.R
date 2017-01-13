#' get the body of a function
#'
#' \code{\link{body}} reformats the code (see \emph{Examples} and
#' \emph{Details}).
#'
#' If we want to check a function as it is coded in a file, we need to get the
#' original thing as coded in the file, no optimized version.
#' In \code{\link{sys.source}} and \code{\link{source}}, keep.source = FALSE
#' seems to use \code{\link{body}}.
#' So we have to do it all over after sourcing with keep.source = TRUE (in
#' \code{\link{check_functions_in_file}}).
#'
#' @author Andreas Dominik Cullmann, <adc-r@@arcor.de>
#' @param object The function from which to extract the body. \cr Should have
#' been sourced with keep.source = TRUE.
#' @return [character(n)]\cr the function body's lines.
#' @keywords internal
#' @examples
#' source(system.file("source", "R", "utils.R", package = "cleanr"))
#' require(checkmate)
#' cleanr:::get_function_body(set_cleanr_options)[3:6]
#' utils::capture.output(body(set_cleanr_options))[4:6]
get_function_body <- function(object) {
    checkmate::checkFunction(object)
    checkmate::checkFunction(object)
    captured_function <- utils::capture.output(object)
    # if the function is not defined in the global environment, the environment
    # will be added to capture.output()
    lines_in_function <- captured_function[! grepl("<environment:\\.*",
                                                   captured_function)]
    # remove the byte code
    lines_in_function <- lines_in_function[! grepl("<bytecode:\\.*",
                                                   lines_in_function)]
    if (! any(grepl("{", lines_in_function, fixed = TRUE))){
        # treat oneliners
        is_split_onliner <- length(lines_in_function) > 1
        opening_line_num <- 1  + as.numeric(is_split_onliner)
        closing_line_num  <- length(lines_in_function)
    } else {
        opening_line_num <- min(grep("{", lines_in_function, fixed = TRUE ))
        closing_line_num <- max(grep("}", lines_in_function, fixed = TRUE ))
    }
    opening_brace_ends_line <-
        grepl("\\{\\s*$", lines_in_function[opening_line_num])
    if (opening_brace_ends_line)
        opening_line_num <- opening_line_num + 1
    closing_brace_starts_line <-
        grepl("^\\s*\\}", lines_in_function[closing_line_num])
    if (closing_brace_starts_line)
        closing_line_num <- closing_line_num - 1
    return(lines_in_function[opening_line_num:closing_line_num])
}

#' throw a condition
#'
#' throws a condition of class c("cleanr", "error", "condition").
#'
#' We use this condition as an error dedicated to \pkg{cleanr}.
#'
#' @author Andreas Dominik Cullmann, <adc-r@@arcor.de>
#' @keywords internal
#' @param message_string The message to be thrown.
#' @param system_call The call to be thrown.
#' @param ... Arguments to be passed to \code{\link{structure}}.
#' @return FALSE. But it does not return anything, it stops with a
#' condition of class c("cleanr", "error", "condition").
#' @keywords internal
#' @examples
#' tryCatch(cleanr:::throw("Hello error!"), cleanr = function(e) return(e))
throw <- function(message_string, system_call = sys.call(-1), ...) {
    checkmate::qassert(message_string, "s*")
    condition <- structure(
                           class = c("cleanr", "error",  "condition"),
                           list(message = message_string, call = system_call),
                           ...
                           )
    stop(condition)
}

#' tidy findings
#'
#' remove TRUE converted to class character from findings.
#'
#' \code{\link{check_directory}}, \code{\link{check_file}},
#' \code{\link{check_functions_in_file}} and
#' \code{\link{check_function_layout}} all collect tryCatch to collect either
#' TRUE for a check passed or a character holding a conditions message. This
#' function deletes the TRUES.
#'
#' @author Andreas Dominik Cullmann, <adc-r@@arcor.de>
#' @param findings a character vector with possibly some elements reading "TRUE"
#' or a vector of TRUES.
#' @return a character vector without any element reading "TRUE" or NULL.
#' @keywords internal
#' @examples
#' findings <- c("some signal caught", rep("TRUE", 3))
#' cleanr:::tidy_findings(findings)
tidy_findings <- function(findings) {
    if (is.logical(findings)) {
        ## findings may be all TRUE, so we set them NULL
        conditions <- NULL
    } else {
        ## findings are of class character with TRUE converted to "TRUE", so we
        ## remove these
        conditions <- findings[! findings == "TRUE"]
    }
    return(conditions)
}
