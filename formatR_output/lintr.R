if (interactive()) setwd(dirname(getwd()))
options(warn = 1) # make warnings appear immediately

output_directory <- "lintr_output"
unlink(output_directory, recursive = TRUE)
dir.create(output_directory)


#% lintr
lints <- lintr::lint_package(path = ".")
lint_file <- file.path(output_directory, "lint_package.out")
if (length(lints) > 0) {
    warning("found lints, see ", lint_file)
    writeLines(unlist(lapply(lints, paste, collapse = " ")), con = lint_file)
} else {
    m <- "Congratulations: no lints found."
    message(m)
    writeLines(m, con = lint_file)
}
