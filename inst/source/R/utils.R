#' Test if an Object is not False
#'
#' Sometimes you need to know whether or not an object exists and is not set to
#' FALSE (and possibly not NULL).
#' 
#' Pass an environment if you call the function elsewhere than from
#' \code{\link{.GlobalEnv}}.
#'
#' @author Andreas Dominik Cullmann, <adc-r@@arcor.de>
#' @param object The object to be tested.
#' @param null_is_false [boolean(1)]\cr Should NULL be treated as FALSE?
#' @param ... Parameters passed to \code{\link{exists}}. See Details and
#' Examples.
#' @return TRUE if the object is set to something different than FALSE, FALSE
#' otherwhise.
#' @export
#' @examples
#' a  <- 1
#' is_not_false(a)
#' f <- function() {
#'     a <- NULL
#'     should_be_true <- ! is_not_false(a, null_is_false = TRUE, 
#'                                       where = environment())
#'     return(should_be_true)
#' }
#' print(f())
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
#' @author Andreas Dominik Cullmann, <adc-r@@arcor.de>
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
