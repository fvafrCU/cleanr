#!/usr/bin/Rscript --vanilla
cleanr::load_internal_functions(package = "cleanr")

path <- getwd()
if (! interactive()) path <- file.path(path, "tests")

# Unit testing
package_suite <- RUnit::defineTestSuite("cleanr_R_code",
                                 dirs = file.path(path, "runit"),
                                 testFileRegexp = "^.*\\.r",
                                 testFuncRegexp = "^test_+")

test_result <- RUnit::runTestSuite(package_suite)
RUnit::printTextProtocol(test_result, showDetails = TRUE)
html_file <- file.path(path, paste(package_suite[["name"]], "html", sep = "."))
RUnit::printHTMLProtocol(test_result, fileName = html_file)
if (interactive()) utils::browseURL(paste0("file:", html_file))

# Coverage inspection
track <- RUnit::tracker()
track[["init"]]()
tryCatch(RUnit::inspect(check_file(system.file("source", "R", "checks.r",
                                        package = "cleanr")),
                 track = track),
         error = function(e) return(e)
         )
tryCatch(RUnit::inspect(check_file(system.file("source", "R", "wrappers.r",
                                        package = "cleanr")),
                 track = track),
         error = function(e) return(e)
         )
tryCatch(RUnit::inspect(check_directory(system.file("source", "R",
                                             package = "cleanr")),
                 track = track),
         error = function(e) return(e)
         )
res_track <- track[["getTrackInfo"]]()
RUnit::printHTML.trackInfo(res_track, baseDir = path)

html_file <- file.path(path, "results", "index.html")
if (interactive()) browseURL(paste0("file:", html_file))

if (FALSE) {
    check_function_coverage <- function(function_track_info){
        lines_of_code_missed <- function_track_info[["run"]] == 0
        opening_braces_only <- grepl("\\s*\\{\\s*",
                                     function_track_info[["src"]])
        closing_braces_only <- grepl("\\s*\\}\\s*",
                                     function_track_info[["src"]])
        braces_only  <- opening_braces_only | closing_braces_only
        statements_missed <- lines_of_code_missed & ! braces_only
        if (any(statements_missed)) stop(paste("missed line ",
                                               which(statements_missed),
                                               sep = ""))

        return(invisible(TRUE))
    }
    ## TODO: for function_in_functions {if function not in names(res_track)
    ## throw()}
    for (track_info in res_track) {
        check_function_coverage(track_info)
    }
}
