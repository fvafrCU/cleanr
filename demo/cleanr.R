#!/usr/bin/Rscript --vanilla
library("cleanr")
file_name <- system.file("source", "R", "utils.R", package = "cleanr")

message("If a file passes all checks, cleanr returns invisibly TRUE")
print(suppressWarnings(check_file(file_name)))

message("Show current options:")
get_cleanr_options(flatten_list = TRUE)

message("Change an option to procude conditions:")
set_cleanr_options(max_file_width = get_cleanr_options("max_file_width") - 1)

message("Catch cleanr conditions:")
print(tryCatch(suppressWarnings(check_file(file_name)),
               cleanr = function(e) return(e)))

