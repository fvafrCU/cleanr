#' @include internals.R
NULL

#' Test if an Object is not False
#'
#' Sometimes you need to know whether or not an object exists and is not set to
#' FALSE (and possibly not NULL).
#' 
#' The ellispis was implemented to enable RUnit testing. I do not know of any
#' other use.
#'
#' @author Dominik Cullmann, <dominik.cullmann@@forst.bwl.de>
#' @param object The object to be tested.
#' @param null_is_false [boolean(1)]\cr Should NULL be treated as FALSE?
#' @param ... Parameters passed to \code{\link{exists}}. See Details.
#' @return TRUE if the object is set to something different than FALSE, FALSE
#' otherwhise.
#' @export
#' @examples
#' a  <- 1
#' is_not_false(a)
is_not_false <- function(object, null_is_false = TRUE, ...) {
    checkmate::qassert(null_is_false, "B1")
    condition <- exists(deparse(substitute(object)), ...)
    if (isTRUE(null_is_false)) {
        condition <- condition && ! is.null(object) && object != FALSE
    } else {
        condition <- condition && (is.null(object) || object != FALSE)
    }
    if (condition)
        result <- TRUE
    else
        result <- FALSE
    return(result)
}

#' Load a Package's Internals
#'
#' Load objects not exported from a package's namespace.
#'
#' The files to be checked get sourced, which means they have to contain R code
#' producing no errors. If we want to check the source code of a package, we
#' need to load the package \emph{and} be able to run all its internals in our
#' environment.
#'
#' @author Dominik Cullmann, <dominik.cullmann@@forst.bwl.de>
#' @param package [character(1)]\cr The name of the package as a string.
#' @param ... Arguments passed to \code{\link{ls}}, all.names = TRUE could be a
#' good idea.
#' @seealso \code{\link[codetools:checkUsageEnv]{checkUsageEnv in codetools}}.
#' @return invisible(TRUE)
#' @export
#' @examples
#' load_internal_functions("cleanr")
load_internal_functions <- function(package, ...) {
    checkmate::qassert(package, "S1")
    library(package, character.only = TRUE)
    exported_names <- ls(paste("package", package, sep = ":"), ...)
    is_exported_name_function <- vapply(exported_names,
                                        function(x) is.function(get(x)), TRUE)
    exported_functions <- exported_names[is_exported_name_function]
    package_namespace <- asNamespace(package)
    package_names <- ls(envir = package_namespace)
    is_package_name_function <-
        vapply(package_names,
               function(x) is.function(get(x, envir = package_namespace)),
               TRUE)
    package_functions <- package_names[is_package_name_function]
    internal_functions <- setdiff(package_functions, exported_functions)
    for (name in internal_functions) {
        assign(name, get(name, envir = package_namespace, inherits = FALSE),
               envir = parent.frame())
    }
    return(invisible(TRUE))
}

#' Set Options for \pkg{cleanr}
#'
#' A convenience function for \code{\link{options}}.
#'
#' @details The package loads a couple of options as defaults for its functions.
#' The defaults are stored in a list element of \code{\link{options}}.
#' @author Dominik Cullmann, <dominik.cullmann@@forst.bwl.de>
#' @param overwrite [boolean(1)]\cr Overwrite options already set? Is set to
#' FALSE on package loading to ensure your previously set \pkg{cleanr} options
#' won't get overridden. Just ignore that argument.
#' @param reset [boolean(1)]\cr Reset all \pkg{cleanr} options to the package's
#' defaults?
#' @param ... see \code{\link{options}}. See \code{\link{function_checks}} and
#' \code{\link{function_checks}} for options to be set with \pkg{cleanr}.
#' Use \code{\link{get_cleanr_options}} to get the current values. Current
#' defaults are:
#' \Sexpr[results=verbatim]{cat(paste(names(cleanr::gco()), 
#'                                    cleanr::gco(flatten_list = FALSE),
#'                                    sep = "=", collapse = "\n"))}
#' @return invisible(TRUE)
#' @export
#' @examples
#' # R.C. Martin's Clean Code recommends monadic argument lists.
#' set_cleanr_options(max_arguments = 1)
#' # R.C. Martin's Clean Code recommends functions less than 20 lines long.
#' set_cleanr_options(max_lines = 30, max_lines_of_code = 20)
#' # same as above:
#' set_cleanr_options(list(max_lines = 30, max_lines_of_code = 20))
#' get_cleanr_options(flatten_list = TRUE)
#' # we delete all options and set some anew
#' options("cleanr" = NULL)
#' options("cleanr" = list(max_lines = 30, max_lines_of_code = 20))
#' # fill the missing options with the package's defaults:
#' set_cleanr_options(overwrite = FALSE)
#' get_cleanr_options(flatten_list = TRUE)
#' # reset to the package's defaults:
#' set_cleanr_options(reset = TRUE)
#' get_cleanr_options(flatten_list = TRUE)
set_cleanr_options <- function(..., reset = FALSE, overwrite = TRUE) {
    checkmate::qassert(reset, "B1")
    checkmate::qassert(overwrite, "B1")
    defaults <- list(max_file_width = 80, max_file_length = 300,
                     max_lines = 65, max_lines_of_code = 50,
                     max_arguments = 5, max_nesting_depth = 3,
                     max_line_width = 80, check_return = TRUE)
    option_list <- list(...)
    if (is.null(getOption("cleanr")) || reset)
        options("cleanr" = defaults)
    else {
        set_options <- getOption("cleanr")
        if (overwrite) {
            options("cleanr" = utils::modifyList(set_options, option_list))
        } else {
            if (length(option_list) == 0)
                option_list <- defaults
            is_option_unset <- !(names(option_list) %in% names(set_options))
            if (any(is_option_unset))
                options("cleanr" = append(set_options,
                                              option_list[is_option_unset]))
        }
    }
    max_lines <- get_cleanr_options("max_lines", flatten_list = TRUE,
                                    remove_names = TRUE)
    max_lines_of_code <- get_cleanr_options("max_lines_of_code",
                                           flatten_list = TRUE,
                                           remove_names = TRUE)
    if (max_lines < max_lines_of_code) {
        set_cleanr_options("max_lines" = max_lines_of_code)
        warning(paste("maximum number of lines was less than maximum number of",
                      "lines of code, resetting the former to the latter."))
    }
    return(invisible(TRUE))
}

#' Get options for \pkg{cleanr}
#'
#' A convenience function for \code{\link{getOption}}.
#'
#' @author Dominik Cullmann, <dominik.cullmann@@forst.bwl.de>
#' @param ... see \code{\link{getOption}}/
#' @param remove_names [boolean(1)]\cr Remove the names?
#' @param flatten_list [boolean(1)]\cr Return a vetcor?
#' @return a (possibly named) list or a vector.
#' @export
#' @examples
#' get_cleanr_options("max_lines")
#' get_cleanr_options("max_lines", remove_names = TRUE)
#' get_cleanr_options("max_lines", flatten_list = TRUE)
#' get_cleanr_options("max_lines", flatten_list = TRUE, remove_names = TRUE)
#' get_cleanr_options(flatten_list = TRUE, remove_names = TRUE)
#' get_cleanr_options(c("max_lines", "max_lines_of_code"))
get_cleanr_options <- function(..., remove_names = FALSE, flatten_list = TRUE) {
    checkmate::qassert(remove_names, "B1")
    checkmate::qassert(flatten_list, "B1")
    if (missing(...)) {
        option_list <- getOption("cleanr")
    } else {
        option_names <- as.vector(...)
        options_set <- getOption("cleanr")
        option_list  <- options_set[names(options_set) %in% option_names]
    }
    if (flatten_list) option_list <-  unlist(option_list)
    if (remove_names) names(option_list)  <- NULL
    return(option_list)
}

#' @rdname get_cleanr_options
#' @export
#' @note \code{gco} is just an alias for \code{get_cleanr_options}.
gco <- get_cleanr_options
