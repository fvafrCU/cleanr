.onLoad <- function(libname, pkgname) {
    if(is.character(libname) && is.character(pkgname)) {
       # soothe codetools::checkUsagePackage
    }
    set_coldr_options(overwrite = FALSE)
    return(invisible(NULL))
}
