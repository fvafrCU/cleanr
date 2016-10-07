#!/usr/bin/Rscript --vanilla
library("cleanr")
file_name <- system.file("source", "R", "utils.r", package = "cleanr")

message("If a file passes all checks, cleanr returns invisibly TRUE")
print(suppressWarnings(check_file(file_name)))

message("Show current options:")
get_coldr_options(flatten_list = TRUE)

message("Change an option to procude conditions:")
set_coldr_options(max_width = get_coldr_options("max_width") - 1)

message("Catch cleanr conditions:")
print(tryCatch(suppressWarnings(check_file(file_name)),
               cleanr = function(e) return(e)))

