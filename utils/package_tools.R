if (interactive()) setwd(dirname(getwd()))
options(warn = 1) # make warnings appear immediately

output_directory <- "package_tools"
unlink(output_directory, recursive = TRUE)
dir.create(output_directory)


#% lintr
lints <- lintr::lint_package(path = ".")
lint_file <- file.path(output_directory, "lint_package.out")
if (length(lints) > 0) {
    warning("found lints, see ", lint_file)
    writeLines(unlist(lapply(lints, paste, collapse = " ")), con = lint_file)
} else {
    message("Congratulations: no lints found.")
}

#% formatR
files <- list.files(c("R", "utils", "tests"), ".*\\.R", full.names = TRUE,
                    recursive  = TRUE)
for (source_file in files) {
    message("\nworking on ", source_file)
    code_file <- file.path(output_directory, basename(source_file))
    tidy_file <- paste0(code_file, ".tidy")
    tidy_lints_file <- paste0(tidy_file, ".lints")
    code_lints_file <- paste0(code_file, ".lints")
    file.copy(source_file, code_file)
    formatR::tidy_source(code_file, arrow = TRUE, width.cutoff = 70,
                         file = tidy_file)
    tidy_lints <- lintr::lint(tidy_file, linters = lintr::default_linters,
                              cache = FALSE)
    if (length(tidy_lints) > 0)
        writeLines(unlist(lapply(tidy_lints, paste, collapse = " ")),
                   con = paste0(tidy_file, ".lints"))
    code_lints <- lintr::lint(code_file, linters = lintr::default_linters,
                              cache = FALSE)
    if (length(code_lints) > 0)
        writeLines(unlist(lapply(code_lints, paste, collapse = " ")),
                   con = paste0(code_file, ".lints"))
    if (length(code_lints) == 0) {
        message("no lints found.")
    } else {
        warning(length(code_lints), " lints found! See ", code_lints_file, ".")
    }
    if (length(code_lints) > length(tidy_lints))
        message(tidy_file, " has only ", length(tidy_lints), " lints. See ",
                tidy_lints_file, ".")
}

#% coldr
if (basename(getwd()) == "coldr") coldr::load_internal_functions("coldr")
coldr::set_coldr_options(max_arguments = 6)
coldr::check_directory("R/", recursive = TRUE)
