#!/usr/bin/Rscript --vanilla
travis_copy <- c("
R version 3.3.2 (2016-10-31)
Platform: x86_64-pc-linux-gnu (64-bit)
Running under: Ubuntu precise (12.04.5 LTS)
")

provide_cran_comments <- function(comments_file = "cran-comments.md",
                                  check_log = "dev_check.Rout",
                                  travis_raw_log = travis_copy) {
    pkg <- devtools::as.package(".")
    cat("\n# Package ", pkg$package, pkg$version, file = comments_file, "\n", append = FALSE)
    travis <- unlist(strsplit(travis_raw_log, "\n"))
    session <- sessionInfo()
    here <- c("",
              session$R.version$version.string,
              paste0("Platform: ", session$platform),
              paste0("Running under: ", session$running))

    cat("\n## Test  environments ", "\n", file = comments_file, append = TRUE)
    cat("-", paste(here[here != ""], collapse = "\n  "), "\n", file = comments_file, append = TRUE)
    cat("-", paste(travis[travis != ""], collapse = "\n  "), "\n", file = comments_file, append = TRUE)
    cat("- win-builder (devel)", "\n", file = comments_file, append = TRUE)
    cat("\n## R CMD check results\n", file = comments_file, append = TRUE)
    check <- readLines(check_log)
    cat(grep("^[0-9]* errors \\|", check, value = TRUE), "\n", file = comments_file, append = TRUE)
    return(invisible(NULL))
}
