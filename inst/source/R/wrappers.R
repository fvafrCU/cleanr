#' @include checks.R
NULL

#' Check a Function's Layout
#'
#' Run all \code{\link{function_checks}} on a function.
#'
#' The functions catches the messages of "cleanr"-conditions
#' \code{\link{throw}}n by \code{\link{function_checks}} and, if it caught any,
#' \code{\link{throw}}s them.
#'
#' @author Andreas Dominik Cullmann, <adc-r@@arcor.de>
#' @param object The function to be checked.
#' @param function_name The name to be used for reporting. If NULL, it is
#' substituted from the object given. Argument is mainly there to pass name for
#' functions retrieved via \code{\link{get}} in the wrapper function
#' \code{\link{check_functions_in_file}}.
#' @param max_lines_of_code See \code{\link{check_num_lines_of_code}}.
#' @param max_lines See \code{\link{check_num_lines}}.
#' @param max_num_arguments See \code{\link{check_num_arguments}}.
#' @param max_nesting_depth See \code{\link{check_nesting_depth}}.
#' @param max_line_width See \code{\link{check_line_width}}.
#' @param check_return See \code{\link{check_return}}.
#' @return invisible(TRUE), but see \emph{Details}.
#' @export
#' @examples
#' print(check_function_layout(check_num_lines))
check_function_layout <- function(object, function_name = NULL,
                                  max_lines_of_code =
                                  get_cleanr_options("max_lines_of_code"),
                                  max_lines = get_cleanr_options("max_lines"),
                                  max_num_arguments =
                                  get_cleanr_options("max_num_arguments"),
                                  max_nesting_depth =
                                  get_cleanr_options("max_nesting_depth"),
                                  max_line_width =
                                  get_cleanr_options("max_line_width"),
                                  check_return =
                                  get_cleanr_options("check_return")
                                  ) {
    findings <- NULL
    finding <- tryCatch(check_num_arguments(object,
                                   max_num_arguments = max_num_arguments),
                          cleanr = function(e) return(e[["message"]]))
    findings <- c(findings, finding)
    finding <- tryCatch(check_nesting_depth(object,
                                   max_nesting_depth = max_nesting_depth),
                          cleanr = function(e) return(e[["message"]]))
    findings <- c(findings, finding)
    finding <- tryCatch(check_line_width(object,
                                   max_line_width = max_line_width),
                          cleanr = function(e) return(e[["message"]]))
    findings <- c(findings, finding)
    finding <- tryCatch(check_num_lines(object,
                                   max_lines = max_lines),
                          cleanr = function(e) return(e[["message"]]))
    findings <- c(findings, finding)
    finding <- tryCatch(check_num_lines_of_code(object,
                                       max_lines_of_code = max_lines_of_code),
                          cleanr = function(e) return(e[["message"]]))

    findings <- c(findings, finding)
    finding <- tryCatch(check_return(object, check_return = check_return),
                          cleanr = function(e) return(e[["message"]]))
    findings <- c(findings, finding)
    findings <- tidy_findings(findings)
    if (! is.null(findings)) {
        if (is.null(function_name)) {
            function_name <- deparse(substitute(object))
        }
        throw(paste(function_name, names(findings),
                    findings, sep = " ", collapse = "\n"))
    }
    return(invisible(TRUE))
}

#' Check a File's Layout
#'
#' Run all \code{\link{file_checks}} on a file.
#'
#' The function catches the messages of "cleanr"-conditions \code{\link{throw}}n
#' by \code{\link{file_checks}} and, if it caught any, \code{\link{throw}}s
#' them.
#'
#' @author Andreas Dominik Cullmann, <adc-r@@arcor.de>
#' @param path Path to the file to be checked.
#' @param max_file_length See \code{\link{check_file_length}}.
#' @param max_file_width See \code{\link{check_file_width}}.
#' @return invisible(TRUE), but see \emph{Details}.
#' @export
#' @examples
#' print(check_file_layout(system.file("source", "R", "checks.R",
#'                                     package = "cleanr")))
check_file_layout <- function(path,
                              max_file_length =
                                  get_cleanr_options("max_file_length"),
                              max_file_width =
                                  get_cleanr_options("max_file_width")) {
    findings <- NULL
    finding <- tryCatch(check_file_width(path,
                                   max_file_width = max_file_width),
                          cleanr = function(e) return(e[["message"]]))
    findings <- c(findings, finding)
    finding <- tryCatch(check_file_length(path,
                                   max_file_length = max_file_length),
                          cleanr = function(e) return(e[["message"]]))
    findings <- c(findings, finding)
    findings <- tidy_findings(findings)
    if (! is.null(findings)) {
        throw(paste0(findings, collapse = "\n"))
    }
    return(invisible(TRUE))
}

#' Check All Functions Defined in a File
#'
#' Run \code{\link{check_function_layout}} on all functions defined in a file.
#'
#' The functions catches the messages of "cleanr"-conditions
#' \code{\link{throw}}n by \code{\link{check_function_layout}} and,
#' if it caught any, \code{\link{throw}}s them.
#'
#' @author Andreas Dominik Cullmann, <adc-r@@arcor.de>
#' @param path Path to the file to be checked.
#' @param ... Argments to be passed to \code{\link{check_function_layout}}.
#' @return invisible(TRUE), but see \emph{Details}.
#' @export
#' @examples
#' print(check_functions_in_file(system.file("source", "R", "utils.R",
#'                                     package = "cleanr")))
check_functions_in_file <- function(path, ...) {
    checkmate::assertFile(path, access = "r")
    findings <- NULL
    source_kept <- new.env(parent = globalenv())
    sys.source(path, envir = source_kept, keep.source = TRUE)
    for (name in ls(envir = source_kept, all.names = TRUE)) {
        assign(name, get(name, envir = source_kept))
        if (is.function(get(name))) {
            finding <-
                tryCatch(check_function_layout(get(name,
                                                   envir = source_kept),
                                               function_name = name, ...),
                         cleanr = function(e) return(e[["message"]]))
            findings <- c(findings, finding)
        }
    }
    findings <- tidy_findings(findings)
    if (! is.null(findings)) {
        throw(paste(path, names(findings),
                    findings, sep = " ", collapse = "\n"))
    }
    return(invisible(TRUE))
}

#' Check a File
#'
#' Run \code{\link{check_functions_in_file}} and
#' \code{\link{check_file_layout}} on a file.
#'
#' The function catches the messages of "cleanr"-conditions \code{\link{throw}}n
#' by \code{\link{check_functions_in_file}} and \code{\link{check_file_layout}}
#' and, if it
#' caught any, \code{\link{throw}}s them.
#'
#' @author Andreas Dominik Cullmann, <adc-r@@arcor.de>
#' @param path Path to the file to be checked.
#' @param ... Arguments to be passed to \code{\link{check_functions_in_file}} or
#' \code{\link{check_file_layout}}.
#' @return invisible(TRUE), but see \emph{Details}.
#' @export
#' @examples
#' print(check_file(system.file("source", "R", "utils.R",
#'                                      package = "cleanr")))
check_file <- function(path, ...) {
    checkmate::assertFile(path, access = "r")
    findings <- NULL
    # I know of two ways to pass arguments through a wrapper to different
    # functions: ellipsis and explicit arguments. I've used ellipsis here, to
    # avoid using ellipsis eating unused arguments down the line, I filter the
    # ellpsis. This is quite a massacre.
    # TODO: refactor with named list as argument containers for functions, i.e.
    # arguments (path, check_file_layout_args = list(...), ...).
    dots <- list(...)
    check_file_layout_defaults <- formals(check_file_layout)
    check_functions_defaults <- append(formals(check_functions_in_file),
                                            formals(check_function_layout))
    known_defaults <- append(check_file_layout_defaults,
                             check_functions_defaults)
    if (! all(names(dots) %in% names(known_defaults))) {
        stop(paste("got unkown argument(s): ",
                   paste(names(dots)[! names(dots) %in% names(known_defaults)],
                         collapse = ", ")))
    }
    arguments <- append(list(path = path), dots)

    use <- utils::modifyList(check_file_layout_defaults, arguments,
                             keep.null = TRUE)
    arguments_to_use <- use[names(use) %in% names(check_file_layout_defaults)]
    # use only non-empty arguments
    arguments_to_use <- arguments_to_use[arguments_to_use != ""]
    finding <- tryCatch(do.call("check_file_layout", arguments_to_use),
                        cleanr = function(e) return(e[["message"]]))
    findings <- c(findings, finding)
    use <- utils::modifyList(check_functions_defaults, arguments,
                             keep.null = TRUE)
    arguments_to_use <- use[names(use) %in%
                            names(check_functions_defaults)]
    # use only non-empty arguments
    arguments_to_use <- arguments_to_use[arguments_to_use != ""]
    # TODO: I remove function_name to keep it from being passed via the ellipsis
    arguments_to_use <- arguments_to_use[names(arguments_to_use) !=
                                         "function_name"]
    finding <- tryCatch(do.call("check_functions_in_file", arguments_to_use),
                        cleanr = function(e) return(e[["message"]]))
    findings <- c(findings, finding)
    findings <- tidy_findings(findings)
    if (! is.null(findings)) {
        throw(paste(names(findings),
                    findings, sep = " ", collapse = "\n"))
    }
    return(invisible(TRUE))
}

#' Check a Directory
#'
#' Run \code{\link{check_file}} on files in a directory.
#'
#' The function catches the messages of "cleanr"-conditions
#' \code{\link{throw}}n by \code{\link{check_file}} and, if it caught any,
#' \code{\link{throw}}s them.
#'
#' @author Andreas Dominik Cullmann, <adc-r@@arcor.de>
#' @param path Path to the directory to be checked.
#' @param pattern A pattern to search files with, see \code{\link{list.files}}.
#' @param recursive Search the directory recursively?
#' Passed to \code{\link{list.files}}.
#' @param ... Arguments to be passed to \code{\link{check_file}}.
#' @return invisible(TRUE), but see \emph{Details}.
#' @export
#' @examples
#' # load internal functions first.
#' load_internal_functions("cleanr")
#' print(check_directory(system.file("source", "R", package = "cleanr"),
#'                       max_num_arguments = 8, max_file_width = 90,
#'                       check_return = FALSE))
check_directory <- function(path, pattern = "\\.[rR]$", recursive = FALSE,
                            ...) {
    checkmate::assertDirectory(path, access = "r")
    paths <- normalizePath(sort(list.files(path, pattern, recursive = recursive,
                                           full.names = TRUE)))
    findings <- NULL
    for (source_file in paths) {
        finding <- tryCatch(check_file(source_file, ...),
                            cleanr = function(e) return(e[["message"]]))
        findings <- c(findings, finding)
    }
    findings <- tidy_findings(findings)
    if (! is.null(findings)) {
        throw(paste(path, names(findings),
                    findings, sep = " ", collapse = "\n"))
    }
    return(invisible(TRUE))
}
