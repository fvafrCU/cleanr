.onLoad <- function(libname, pkgname) {
    if (is.character(libname) && is.character(pkgname)) {
       # soothe codetools::checkUsagePackage
    }
    set_cleanr_options(overwrite = FALSE)
    return(invisible(NULL))
}
