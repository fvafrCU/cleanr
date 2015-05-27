.setUp <- function() {
    ## called before each test case, see also .tearDown()
    print(".setUp")
}
library('coldr')

load_internal_functions(package = 'coldr')

library('RUnit')
# Unit testing
package_suite <- defineTestSuite('coldr_R_code',
                                 dirs = file.path(getwd(), 'runit'),
                                 testFileRegexp = '^.*\\.r',
                                 testFuncRegexp = '^test_+')

test_result <- runTestSuite(package_suite)
printTextProtocol(test_result, showDetails = TRUE)
html_file <- paste(package_suite$name, 'html', sep = '.')
printHTMLProtocol(test_result, fileName = html_file)
html <- file.path(getwd(), html_file)
if (interactive()) browseURL(paste0('file:', html))

# Coverage inspection
track <- tracker()
track$init()
tryCatch(inspect(check_file(system.file('source', 'R', 'checks.r',
                                        package = 'coldr')),
                 track = track),
         error = function(e) return(e)
         )
tryCatch(inspect(check_file(system.file('source', 'R', 'wrappers.r',
                                        package = 'coldr')),
                 track = track),
         error = function(e) return(e)
         )
tryCatch(inspect(check_directory(system.file('source', 'R',
                                             package = 'coldr')),
                 track = track),
         error = function(e) return(e)
         )
res_track <- track$getTrackInfo()
printHTML.trackInfo(res_track)

html_file <- file.path('results', 'index.html')
html <- file.path(getwd(), html_file)
if (interactive()) browseURL(paste0('file:', html))

if(FALSE){
    check_function_coverage <- function(function_track_info){
        lines_of_code_missed <- function_track_info$run == 0
        opening_braces_only <- grepl('\\s*\\{\\s*', function_track_info$src)
        closing_braces_only <- grepl('\\s*\\}\\s*', function_track_info$src)
        braces_only  <- opening_braces_only | closing_braces_only
        statements_missed <- lines_of_code_missed & ! braces_only
        if (any(statements_missed)) stop(paste('missed line ',
                                               which(statements_missed), 
                                               sep = ''))

        return(invisible(TRUE))
    }
    ## TODO: for function_in_functions {if function not in names(res_track)
    ## throw()}
    for (track_info in res_track) {
        check_function_coverage(track_info)
    }
}
