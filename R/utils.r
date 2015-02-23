load_internal_functions <- function(package, ...) {
    qassert(package, 'S1')
    library(package, character.only = TRUE)
    exported_names <- ls(paste("package", package, sep = ':'), ...)
    is_exported_name_function <- vapply(exported_names, 
                                   function(x) 
                                       is.function(eval(parse(text = x))), 
                                       TRUE)
    exported_functions <- exported_names[is_exported_name_function]
    package_namespace <- asNamespace(package)
    package_names <- ls(envir = package_namespace)
    is_package_name_function <- 
        vapply(package_names, 
               function(x) { 
                   name_in_package  <-  paste('package_namespace$', x, sep = '')
                   is.function(eval(parse(text = name_in_package)))
               }, 
               TRUE)
    package_functions <- package_names[is_package_name_function]
    internal_functions <- setdiff(package_functions, exported_functions)
    for (name in internal_functions) {
        assign(name, get(name, envir = package_namespace, inherits = FALSE),
               envir = .GlobalEnv )
    }
    return(invisible(TRUE))
}

set_coldr_options <- function(..., reset = FALSE, overwrite = TRUE) {
    qassert(reset, 'B1')
    qassert(overwrite, 'B1')
    defaults <- list(max_width = 80, max_length = 300,
                     max_lines = 65, max_lines_of_code = 50,
                     max_arguments = 5, max_nesting_depth = 3,
                     max_line_width = 80)
    option_list <- list(...)
    if (is.null(getOption('coldr')) || reset)
        options('coldr' = defaults)
    else {
        set_options <- getOption('coldr')
        if (overwrite) {
            options('coldr' = modifyList(set_options, option_list))
        } else {
            if (length(option_list) == 0)
                option_list <- defaults
            is_option_unset <- !(names(option_list) %in% names(set_options))
            if(any(is_option_unset))
                options('coldr' = append(set_options,
                                              option_list[is_option_unset]))
        }
    }
    max_lines <- get_coldr_options('max_lines', flatten_list = TRUE)
    max_lines_of_code <- get_coldr_options('max_lines_of_code', 
                                           flatten_list = TRUE)
    if (max_lines < max_lines_of_code) {
        set_coldr_options(max_lines = max_lines_of_code)
        warning(paste('maximum number of lines was less than maximum number of',
                      'lines of code, resetting the former to the latter.'))
    }
    return(invisible(TRUE))
}

get_coldr_options <- function(..., remove_names = FALSE, flatten_list = TRUE) {
    qassert(remove_names, 'B1')
    qassert(flatten_list, 'B1')
    if (missing(...)) {
        option_list <- getOption('coldr')
    } else {
        option_names <- as.vector(...)
        options_set <- getOption('coldr')
        option_list  <- options_set[names(options_set) %in% option_names]
    }
    if (flatten_list) option_list <-  unlist(option_list)
    if (remove_names) names(option_list)  <- NULL
    return(option_list)
}

get_function_body <- function(object) {
    qassert(object, 'f')
    lines_in_function <- capture.output(object)
    if(! any(grepl('{', lines_in_function, fixed = TRUE))){
        # treat oneliners
        is_split_onliner <- length(lines_in_function) > 1
        opening_line_num <- 1  + as.numeric(is_split_onliner)
        closing_line_num  <- length(lines_in_function)
    } else {
        opening_line_num <- min(grep('{', lines_in_function, fixed = TRUE ))
        closing_line_num <- max(grep('}', lines_in_function, fixed = TRUE ))
    }
    opening_brace_ends_line <-
        grepl('\\{\\s*$', lines_in_function[opening_line_num])
    if (opening_brace_ends_line)
        opening_line_num <- opening_line_num + 1
    closing_brace_starts_line <-
        grepl('^\\s*\\}', lines_in_function[closing_line_num])
    if (closing_brace_starts_line)
        closing_line_num <- closing_line_num - 1
    return(lines_in_function[opening_line_num:closing_line_num])
}

throw <- function(message_string, system_call = sys.call(-1), ...) {
    qassert(message_string, 's*')
    condition <- structure(
                           class = c('coldr', 'error',  'condition'),
                           list(message = message_string, call = system_call),
                           ...
                           )
    stop(condition)
    return(FALSE)
}
