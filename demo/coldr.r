#!/usr/bin/Rscript --vanilla
library("coldr")
file_name <- system.file("source", "R", "utils.r", package = "coldr")

message("If a file passes all checks, coldr returns invisibly TRUE")
print(suppressWarnings(check_file(file_name)))

message("Show current options:")
get_coldr_options(flatten_list = TRUE)

message("Change an option to procude conditions:")
set_coldr_options(max_width = get_coldr_options("max_width") - 1)

message("Catch coldr conditions:")
print(tryCatch(suppressWarnings(check_file(file_name)),
               coldr = function(e) return(e)))

