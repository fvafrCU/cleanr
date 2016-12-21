#' Set Options for \pkg{cleanr}
#'
#' A convenience function for \code{\link{options}}.
#'
#' \pkg{cleanr} loads a couple of options as defaults for its 
#' functions.
#' The defaults are stored in a list element of \code{\link{options}}.
#' All checks (see \code{\link{function_checks}} and \code{\link{file_checks}})
#' can be disabled by setting the corresponding option list item to \code{NULL}
#' or \code{FALSE}.
#' @author Andreas Dominik Cullmann, <adc-r@@arcor.de>
#' @param overwrite [boolean(1)]\cr Overwrite options already set? Is set to
#' \code{FALSE} on package loading to ensure your previously set \pkg{cleanr}
#' options won't get overridden. Just ignore that argument.
#' @param reset [boolean(1)]\cr Reset all \pkg{cleanr} options to the package's
#' defaults?
#' @param ... See \code{\link{options}}. See \code{\link{function_checks}} and
#' \code{\link{file_checks}} for options to be set with \pkg{cleanr}.
#' Use \code{\link{get_cleanr_options}} to get the current values.
#' \pkg{cleanr}'s standard defaults are:
#' \Sexpr[results=verbatim]{cat(paste(names(cleanr::gco()), 
#'                                    cleanr::gco(flatten_list = FALSE),
#'                                    sep = "=", collapse = "\n"), "\n")}
#' @return invisible(TRUE)
#' @export
#' @examples
#' # R.C. Martin's Clean Code recommends monadic argument lists.
#' set_cleanr_options(max_num_arguments = 1)
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
                     max_num_arguments = 5, max_nesting_depth = 3,
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
#' @author Andreas Dominik Cullmann, <adc-r@@arcor.de>
#' @param ... See \code{\link{getOption}}.
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
