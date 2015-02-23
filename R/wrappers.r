check_function_layout <- function(object,
                                  max_lines_of_code =
                                  get_coldr_options('max_lines_of_code'),
                                  max_lines = get_coldr_options('max_lines'),
                                  max_arguments =
                                  get_coldr_options('max_arguments'),
                                  max_nesting_depth =
                                  get_coldr_options('max_nesting_depth'),
                                  max_line_width =
                                  get_coldr_options('max_line_width')) {
    findings <- NULL
    finding <- tryCatch(check_num_arguments(object,
                                   maximum = max_arguments),
                          coldr = function(e) return(e$message))
    findings <- c(findings, finding)
    finding <- tryCatch(check_nesting_depth(object,
                                   maximum = max_nesting_depth),
                          coldr = function(e) return(e$message))
    findings <- c(findings, finding)
    finding <- tryCatch(check_line_width(object,
                                   maximum = max_line_width),
                          coldr = function(e) return(e$message))
    findings <- c(findings, finding)
    finding <- tryCatch(check_num_lines(object,
                                   maximum = max_lines),
                          coldr = function(e) return(e$message))
    findings <- c(findings, finding)
    finding <- tryCatch(check_num_lines_of_code(object,
                                       maximum = max_lines_of_code),
                          coldr = function(e) return(e$message))

    findings <- c(findings, finding)
    finding <- tryCatch(check_return(object),
                          coldr = function(e) return(e$message))
    findings <- c(findings, finding)
    findings <- tidy_findings(findings)
    if (! is.null(findings)) {
        function_name <- sub('source_kept$', '', deparse(substitute(object)),
                             fixed = TRUE)
        throw(paste(function_name, names(findings),
                    findings, sep = ' ', collapse = '\n'))
    }
    return(invisible(TRUE))
}

check_functions_in_file <- function(path, ...) {
    assertFile(path, access = 'r')
    findings <- NULL
    source_kept <- new.env(parent = globalenv())
    sys.source(path, envir = source_kept, keep.source = TRUE)
    for (name in ls(envir = source_kept, all.names = TRUE)) {
        eval(parse(text = paste(name, ' <- source_kept$', name, sep = '')))
        if (eval(parse(text = paste('is.function(', name, ')')))) {
            command <- paste('tryCatch(check_function_layout(',
                             'source_kept$', name, ',...),',
                             'coldr = function(e) return(e$message))')
            finding <- eval(parse(text = command))
            findings <- c(findings, finding)
        }
    }
    findings <- tidy_findings(findings)
    if (! is.null(findings)) {
        throw(paste(path, names(findings),
                    findings, sep = ' ', collapse = '\n'))
    }
    return(invisible(TRUE))
}

check_file <- function(path, ...) {
    assertFile(path, access = 'r')
    findings <- NULL
    # I know of two ways to pass arguments through a wrapper to different
    # functions: ellipsis and explicit arguments. I've used ellipsis here, to
    # avoid using ellipsis eating unused arguments down the line, I filter the
    # ellpsis. This is quite a massacre.
    # TODO: refactor with named list as argument containers for functions, i.e.
    # checkfile <- function(path, check_file_layout_args = list(...), ...).
    dots <- list(...)
    check_file_layout_defaults <- formals(check_file_layout)
    check_functions_in_file_defaults <- append(formals(check_functions_in_file),
                                            formals(check_function_layout))
    known_defaults <- append(check_file_layout_defaults,
                             check_functions_in_file_defaults)
    if (! all(names(dots) %in% names(known_defaults))) {
        stop(paste("got unkown argument(s): ",
                   paste(names(dots)[! names(dots) %in% names(known_defaults)],
                         collapse = ', ')))
    }
    arguments <- append(list(path = path), dots)

    use <- modifyList(check_file_layout_defaults, arguments)
    arguments_to_use <- use[names(use) %in% names(check_file_layout_defaults)]
    # use only non-empty arguments
    arguments_to_use <- arguments_to_use[arguments_to_use != '']
    finding <- tryCatch(do.call("check_file_layout", arguments_to_use),
                        coldr = function(e) return(e$message))
    findings <- c(findings, finding)
    use <- modifyList(check_functions_in_file_defaults, arguments)
    arguments_to_use <- use[names(use) %in%
                            names(check_functions_in_file_defaults)]
    # use only non-empty arguments
    arguments_to_use <- arguments_to_use[arguments_to_use != '']
    finding <- tryCatch(do.call("check_functions_in_file", arguments_to_use),
                        coldr = function(e) return(e$message))
    findings <- c(findings, finding)
    findings <- tidy_findings(findings)
    if (! is.null(findings)) {
        throw(paste(names(findings),
                    findings, sep = ' ', collapse = '\n'))
    }
    return(invisible(TRUE))
}

check_directory <- function(path, pattern = '\\.[rR]$', recursive = FALSE,
                            ...) {
    assertDirectory(path, access = 'r')
    paths <- normalizePath(sort(list.files(path, pattern, recursive = recursive,
                                           full.names = TRUE)))
    findings <- NULL
    for (source_file in paths) {
        finding <- tryCatch(check_file(source_file, ...),
                            coldr = function(e) return(e$message))
        findings <- c(findings, finding)
    }
    findings <- tidy_findings(findings)
    if (! is.null(findings)) {
        throw(paste(path, names(findings),
                    findings, sep = ' ', collapse = '\n'))
    }
    return(invisible(TRUE))
}

tidy_findings <- function(findings) {
    if (is.logical(findings)) {
        ## findings may be all TRUE, so we set them NULL
        conditions <- NULL
    } else {
        ## findings are of class character with TRUE converted to 'TRUE', so we
        ## remove these
        conditions <- findings[!findings == 'TRUE']
    }
    return(conditions)
}
