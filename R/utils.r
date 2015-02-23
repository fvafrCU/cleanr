#' load a package's internals
#'
#' load objects not exported from a package's namespace.
#'
#' The files to be checked get sourced, which means they have to contain R code
#' producing no errors. If we want to check the source code of a package, we
#' need to load the package \emph{and} be able to run all its internals in our
#' environment.
#'
#' @author Dominik Cullmann, <dominik.cullmann@@forst.bwl.de>
#' @section Version: $Id: 01015ff091d53e47fc1caa95805585b6e3911ba5 $
#' @param package [character(1)]\cr The name of the package as a string.
#' @param ... Arguments passed to \code{\link{ls}}, all.names = TRUE could be a
#' good idea.
#' @seealso \code{\link[codetools:checkUsageEnv]{checkUsageEnv in codetools}}.
#' @return invisible(TRUE)
#' @keywords internal
#' @examples 
#' load_internal_functions('coldr')
load_internal_functions <- function(package, ...) {
    qassert(package, 'S1')
    library(package, character.only = TRUE)
    exported_names <- ls(paste("package", package, sep = ':'), ...)
    is_exported_name_function <- vapply(exported_names, 
                                   function(x) 
                                       is.function(eval(parse(text = x))), 
                                       TRUE)
    exported_functions <- exported_names[is_exported_name_function]
    package_namespace <- asNamespace(package)
    package_names <- ls(envir = package_namespace)
    is_package_name_function <- 
        vapply(package_names, 
               function(x) { 
                   name_in_package  <-  paste('package_namespace$', x, sep = '')
                   is.function(eval(parse(text = name_in_package)))
               }, 
               TRUE)
    package_functions <- package_names[is_package_name_function]
    internal_functions <- setdiff(package_functions, exported_functions)
    for (name in internal_functions) {
        assign(name, get(name, envir = package_namespace, inherits = FALSE),
               envir = .GlobalEnv )
    }
    return(invisible(TRUE))
}

#' set options for \pkg{coldr}
#'
#' a convenience function for \code{link{options}}.
#'
#' @details the package loads a couple of options as defaults for its functions.
#' The defaults are stored in a list element of \code{\link{options}}.
#' @author Dominik Cullmann, <dominik.cullmann@@forst.bwl.de>
#' @section Version: $Id: 01015ff091d53e47fc1caa95805585b6e3911ba5 $
#' @param overwrite [boolean(1)]\cr Overwrite options already set? Is set to
#' FALSE on package loading to ensure your previously set \pkg{coldr} options
#' won't get overridden. Just ignore that argument.
#' @param reset [boolean(1)]\cr Reset all \pkg{coldr} options to the package's
#' defaults?
#' @param ... see \code{\link{options}}.
#' @return invisible(TRUE)
#' @examples 
#' # R.C. Martin's Clean Code recommends monadic argument lists.
#' set_coldr_options(max_arguments = 1) 
#' # R.C. Martin's Clean Code recommends functions less than 20 lines long.
#' set_coldr_options(max_lines = 30, max_lines_of_code = 20)
#' # same as above:
#' set_coldr_options(list(max_lines = 30, max_lines_of_code = 20))
#' get_coldr_options(flatten_list = TRUE)
#' # we delete all options and set some anew
#' options('coldr' = NULL)
#' options('coldr' = list(max_lines = 30, max_lines_of_code = 20))
#' # fill the missing options with the package's defaults:
#' set_coldr_options(overwrite = FALSE)
#' get_coldr_options(flatten_list = TRUE)
#' # reset to the package's defaults:
#' set_coldr_options(reset = TRUE)
#' get_coldr_options(flatten_list = TRUE)
set_coldr_options <- function(..., reset = FALSE, overwrite = TRUE) {
    qassert(reset, 'B1')
    qassert(overwrite, 'B1')
    defaults <- list(max_width = 80, max_length = 300,
                     max_lines = 65, max_lines_of_code = 50,
                     max_arguments = 5, max_nesting_depth = 3,
                     max_line_width = 80)
    option_list <- list(...)
    if (is.null(getOption('coldr')) || reset)
        options('coldr' = defaults)
    else {
        set_options <- getOption('coldr')
        if (overwrite) {
            options('coldr' = modifyList(set_options, option_list))
        } else {
            if (length(option_list) == 0)
                option_list <- defaults
            is_option_unset <- !(names(option_list) %in% names(set_options))
            if(any(is_option_unset))
                options('coldr' = append(set_options,
                                              option_list[is_option_unset]))
        }
    }
    max_lines <- get_coldr_options('max_lines', flatten_list = TRUE)
    max_lines_of_code <- get_coldr_options('max_lines_of_code', 
                                           flatten_list = TRUE)
    if (max_lines < max_lines_of_code) {
        set_coldr_options(max_lines = max_lines_of_code)
        warning(paste('maximum number of lines was less than maximum number of',
                      'lines of code, resetting the former to the latter.'))
    }
    return(invisible(TRUE))
}

#' get options for \pkg{coldr}
#'
#' a convenience function for \code{link{getOptions}}.
#'
#' @author Dominik Cullmann, <dominik.cullmann@@forst.bwl.de>
#' @section Version: $Id: 01015ff091d53e47fc1caa95805585b6e3911ba5 $
#' @param ... see \code{\link{getOption}}/
#' @param remove_names [boolean(1)]\cr Remove the names?
#' @param flatten_list [boolean(1)]\cr Return a vetcor?
#' @return a (possibly named) list or a vector.
#' @examples 
#' get_coldr_options('max_lines')
#' get_coldr_options('max_lines', remove_names = TRUE)
#' get_coldr_options('max_lines', flatten_list = TRUE)
#' get_coldr_options('max_lines', flatten_list = TRUE, remove_names = TRUE)
#' get_coldr_options(flatten_list = TRUE, remove_names = TRUE)
#' get_coldr_options(c('max_lines', 'max_lines_of_code'))
get_coldr_options <- function(..., remove_names = FALSE, flatten_list = TRUE) {
    qassert(remove_names, 'B1')
    qassert(flatten_list, 'B1')
    if (missing(...)) {
        option_list <- getOption('coldr')
    } else {
        option_names <- as.vector(...)
        options_set <- getOption('coldr')
        option_list  <- options_set[names(options_set) %in% option_names]
    }
    if (flatten_list) option_list <-  unlist(option_list)
    if (remove_names) names(option_list)  <- NULL
    return(option_list)
}

#' get the body of a function
#'
#' \code{\link{body}} reformats the code (see \emph{Examples} and
#' \emph{Details}). 
#'
#' If we want to check a function as it is coded in a file, we need to get the
#' orginial thing as coded in the file, no optimized version.
#' In \code{\link{sys.source}} and \code{\link{source}}, keep.source = FALSE
#' seems to use \code{\link{body}}.
#' So we have to do it all over after sourcing with keep.source = TRUE (in
#' \code{\link{check_functions_in_file}}).
#'
#' @author Dominik Cullmann, <dominik.cullmann@@forst.bwl.de>
#' @section Version: $Id: 01015ff091d53e47fc1caa95805585b6e3911ba5 $
#' @param object The function from which to extract the body. \cr Should have
#' been sourced with keep.source = TRUE.
#' @return [character(n)]\cr the function body's lines.
#' @keywords internal
#' @examples 
#' source(system.file('source', 'R', 'utils.r', package = 'coldr'))
#' require(checkmate)
#' get_function_body(set_coldr_options)[3:6]
#' capture.output(body(set_coldr_options))[4:6]
get_function_body <- function(object) {
    qassert(object, 'f')
    lines_in_function <- capture.output(object)
    if(! any(grepl('{', lines_in_function, fixed = TRUE))){
        # treat oneliners
        is_split_onliner <- length(lines_in_function) > 1
        opening_line_num <- 1  + as.numeric(is_split_onliner)
        closing_line_num  <- length(lines_in_function)
    } else {
        opening_line_num <- min(grep('{', lines_in_function, fixed = TRUE ))
        closing_line_num <- max(grep('}', lines_in_function, fixed = TRUE ))
    }
    opening_brace_ends_line <-
        grepl('\\{\\s*$', lines_in_function[opening_line_num])
    if (opening_brace_ends_line)
        opening_line_num <- opening_line_num + 1
    closing_brace_starts_line <-
        grepl('^\\s*\\}', lines_in_function[closing_line_num])
    if (closing_brace_starts_line)
        closing_line_num <- closing_line_num - 1
    return(lines_in_function[opening_line_num:closing_line_num])
}

#' throw a condition
#'
#' throws a condition of class c('coldr', 'error', 'condition').
#'
#' We use this condition as an error dedictated to \pkg{coldr}.
#'
#' @author Dominik Cullmann, <dominik.cullmann@@forst.bwl.de>
#' @section Version: $Id: 01015ff091d53e47fc1caa95805585b6e3911ba5 $
#' @keywords internal
#' @param message_string The message to be thrown.
#' @param system_call The call to be thrown.
#' @param ... Arguments to be passed to \code{\link{structure}}.
#' @return FALSE. But it doesn't return anything, it stops with a
#' condition of class c('coldr', 'error', 'condition').
#' @examples
#' tryCatch(coldr:::throw('Hello error!'), coldr = function(e) return(e))
throw <- function(message_string, system_call = sys.call(-1), ...) {
    qassert(message_string, 's*')
    condition <- structure(
                           class = c('coldr', 'error',  'condition'),
                           list(message = message_string, call = system_call),
                           ...
                           )
    stop(condition)
    return(FALSE)
}
