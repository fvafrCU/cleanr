#' @include checks.r
NULL

#' check a function's layout
#'
#' run all \code{\link{function_checks}} on a function.
#'
#' The functions catches the messages of 'coldr'-conditions \code{\link{throw}}n
#' by \code{\link{function_checks}} and, if it caught any, \code{\link{throw}}s
#' them.
#'
#' @author Dominik Cullmann, <dominik.cullmann@@forst.bwl.de>
#' @section Version: $Id: 01015ff091d53e47fc1caa95805585b6e3911ba5 $
#' @param object The function to be checked.
#' @param max_lines_of_code the maximum number of lines of code accepted.
#' @param max_lines the maximum number of lines accepted.
#' @param max_arguments the maximum number of arguments accepted.
#' @param max_nesting_depth the maximum nesting depth accepted.
#' @param max_line_width the maximum line width accepted.
#' @return invisible(TRUE), but see \emph{Details}.
#' @export 
#' @examples 
#' print(check_function_layout(check_num_lines))
check_function_layout <- function(object,
                                  max_lines_of_code =
                                  get_coldr_options('max_lines_of_code'),
                                  max_lines = get_coldr_options('max_lines'),
                                  max_arguments =
                                  get_coldr_options('max_arguments'),
                                  max_nesting_depth =
                                  get_coldr_options('max_nesting_depth'),
                                  max_line_width =
                                  get_coldr_options('max_line_width')) {
    findings <- NULL
    finding <- tryCatch(check_num_arguments(object,
                                   maximum = max_arguments),
                          coldr = function(e) return(e$message))
    findings <- c(findings, finding)
    finding <- tryCatch(check_nesting_depth(object,
                                   maximum = max_nesting_depth),
                          coldr = function(e) return(e$message))
    findings <- c(findings, finding)
    finding <- tryCatch(check_line_width(object,
                                   maximum = max_line_width),
                          coldr = function(e) return(e$message))
    findings <- c(findings, finding)
    finding <- tryCatch(check_num_lines(object,
                                   maximum = max_lines),
                          coldr = function(e) return(e$message))
    findings <- c(findings, finding)
    finding <- tryCatch(check_num_lines_of_code(object,
                                       maximum = max_lines_of_code),
                          coldr = function(e) return(e$message))

    findings <- c(findings, finding)
    finding <- tryCatch(check_return(object),
                          coldr = function(e) return(e$message))
    findings <- c(findings, finding)
    findings <- tidy_findings(findings)
    if (! is.null(findings)) {
        function_name <- sub('source_kept$', '', deparse(substitute(object)),
                             fixed = TRUE)
        throw(paste(function_name, names(findings),
                    findings, sep = ' ', collapse = '\n'))
    }
    return(invisible(TRUE))
}

#' check all functions defined in a file
#'
#' run all \code{\link{check_function_layout}} on a file.
#'
#' The functions catches the messages of 'coldr'-conditions \code{\link{throw}}n
#' by \code{\link{check_function_layout}} and, if it caught any,
#' \code{\link{throw}}s
#' them.
#'
#' @author Dominik Cullmann, <dominik.cullmann@@forst.bwl.de>
#' @section Version: $Id: 01015ff091d53e47fc1caa95805585b6e3911ba5 $
#' @param path A path to a file, e.g. "checks.r".
#' @param ... Argments to be passed to \code{\link{check_function_layout}}.
#' @return invisible(TRUE), but see \emph{Details}.
#' @export 
#' @examples 
#' print(check_functions_in_file(system.file('source', 'R', 'utils.r', 
#'                                     package = 'coldr')))
check_functions_in_file <- function(path, ...) {
    checkmate::assertFile(path, access = 'r')
    findings <- NULL
    source_kept <- new.env(parent = globalenv())
    sys.source(path, envir = source_kept, keep.source = TRUE)
    for (name in ls(envir = source_kept, all.names = TRUE)) {
        eval(parse(text = paste(name, ' <- source_kept$', name, sep = '')))
        if (eval(parse(text = paste('is.function(', name, ')')))) {
            command <- paste('tryCatch(check_function_layout(',
                             'source_kept$', name, ',...),',
                             'coldr = function(e) return(e$message))')
            finding <- eval(parse(text = command))
            findings <- c(findings, finding)
        }
    }
    findings <- tidy_findings(findings)
    if (! is.null(findings)) {
        throw(paste(path, names(findings),
                    findings, sep = ' ', collapse = '\n'))
    }
    return(invisible(TRUE))
}

#' check a file
#'
#' run all \code{\link{check_functions_in_file}} and
#' \code{\link{check_file_layout}} on a file.
#'
#' The function catches the messages of 'coldr'-conditions \code{\link{throw}}n
#' by \code{\link{check_functions_in_file}} and \code{\link{check_file_layout}}
#' and, if it
#' caught any, \code{\link{throw}}s them.
#'
#' @author Dominik Cullmann, <dominik.cullmann@@forst.bwl.de>
#' @section Version: $Id: 01015ff091d53e47fc1caa95805585b6e3911ba5 $
#' @param path The path to file, e.g. "checks.r".
#' @param ... Arguments to be passed to \code{\link{check_functions_in_file}} or
#' \code{\link{check_file_layout}}.
#' @return invisible(TRUE), but see \emph{Details}.
#' @export 
#' @examples 
#' print(check_file(system.file('source', 'R', 'utils.r', 
#'                                      package = 'coldr')))
check_file <- function(path, ...) {
    checkmate::assertFile(path, access = 'r')
    findings <- NULL
    # I know of two ways to pass arguments through a wrapper to different
    # functions: ellipsis and explicit arguments. I've used ellipsis here, to
    # avoid using ellipsis eating unused arguments down the line, I filter the
    # ellpsis. This is quite a massacre.
    # TODO: refactor with named list as argument containers for functions, i.e.
    # checkfile <- function(path, check_file_layout_args = list(...), ...).
    dots <- list(...)
    check_file_layout_defaults <- formals(check_file_layout)
    check_functions_in_file_defaults <- append(formals(check_functions_in_file),
                                            formals(check_function_layout))
    known_defaults <- append(check_file_layout_defaults,
                             check_functions_in_file_defaults)
    if (! all(names(dots) %in% names(known_defaults))) {
        stop(paste("got unkown argument(s): ",
                   paste(names(dots)[! names(dots) %in% names(known_defaults)],
                         collapse = ', ')))
    }
    arguments <- append(list(path = path), dots)

    use <- utils::modifyList(check_file_layout_defaults, arguments)
    arguments_to_use <- use[names(use) %in% names(check_file_layout_defaults)]
    # use only non-empty arguments
    arguments_to_use <- arguments_to_use[arguments_to_use != '']
    finding <- tryCatch(do.call("check_file_layout", arguments_to_use),
                        coldr = function(e) return(e$message))
    findings <- c(findings, finding)
    use <- utils::modifyList(check_functions_in_file_defaults, arguments)
    arguments_to_use <- use[names(use) %in%
                            names(check_functions_in_file_defaults)]
    # use only non-empty arguments
    arguments_to_use <- arguments_to_use[arguments_to_use != '']
    finding <- tryCatch(do.call("check_functions_in_file", arguments_to_use),
                        coldr = function(e) return(e$message))
    findings <- c(findings, finding)
    findings <- tidy_findings(findings)
    if (! is.null(findings)) {
        throw(paste(names(findings),
                    findings, sep = ' ', collapse = '\n'))
    }
    return(invisible(TRUE))
}

#' check a directory
#'
#' run all \code{\link{check_file}} on the files in a directory.
#'
#' The functions catches the messages of 'coldr'-conditions \code{\link{throw}}n
#' by \code{\link{check_file}} and, if it caught any, \code{\link{throw}}s them.
#'
#' @author Dominik Cullmann, <dominik.cullmann@@forst.bwl.de>
#' @section Version: $Id: 01015ff091d53e47fc1caa95805585b6e3911ba5 $
#' @param path A path to a directory to be checked, e.g. "R/".
#' @param pattern A pattern to search files with, see \code{\link{list.files}}.
#' @param recursive Search the directory recursively?
#' See \code{\link{list.files}}.
#' @param ... Arguments to be passed to \code{\link{check_file}}.
#' @return invisible(TRUE), but see \emph{Details}.
#' @export 
#' @examples 
#' # load internal functions first.
#' load_internal_functions('coldr')
#' print(check_directory(system.file('source', 'R', package = 'coldr'),
#'                       max_arguments = 6, max_width = 90))
check_directory <- function(path, pattern = '\\.[rR]$', recursive = FALSE,
                            ...) {
    checkmate::assertDirectory(path, access = 'r')
    paths <- normalizePath(sort(list.files(path, pattern, recursive = recursive,
                                           full.names = TRUE)))
    findings <- NULL
    for (source_file in paths) {
        finding <- tryCatch(check_file(source_file, ...),
                            coldr = function(e) return(e$message))
        findings <- c(findings, finding)
    }
    findings <- tidy_findings(findings)
    if (! is.null(findings)) {
        throw(paste(path, names(findings),
                    findings, sep = ' ', collapse = '\n'))
    }
    return(invisible(TRUE))
}

