\name{check_file}
\alias{check_file}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
%%  ~~function to do ... ~~
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
check_file(path, ...)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{path}{
%%     ~~Describe \code{path} here~~
}
  \item{\dots}{
%%     ~~Describe \code{\dots} here~~
}
}
\details{
%%  ~~ If necessary, more details than the description above ~~
}
\value{
%%  ~Describe the value returned
%%  If it is a LIST, use
%%  \item{comp1 }{Description of 'comp1'}
%%  \item{comp2 }{Description of 'comp2'}
%% ...
}
\references{
%% ~put references to the literature/web site here ~
}
\author{
%%  ~~who you are~~
}
\note{
%%  ~~further notes~~
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
%% ~~objects to See Also as \code{\link{help}}, ~~~
}
\examples{
##---- Should be DIRECTLY executable !! ----
##-- ==>  Define data, use random,
##--	or do  help(data=index)  for the standard data sets.

## The function is currently defined as
function (path, ...) 
{
    findings <- NULL
    dots <- list(...)
    check_file_layout_defaults <- formals(check_file_layout)
    check_functions_in_file_defaults <- append(formals(check_functions_in_file), 
        formals(check_function_layout))
    known_defaults <- append(check_file_layout_defaults, check_functions_in_file_defaults)
    if (!all(names(dots) \%in\% names(known_defaults))) {
        stop(paste("got unkown argument(s): ", paste(names(dots)[!names(dots) \%in\% 
            names(known_defaults)], collapse = ", ")))
    }
    arguments <- append(list(path = path), dots)
    use <- modifyList(check_file_layout_defaults, arguments)
    arguments_to_use <- use[names(use) \%in\% names(check_file_layout_defaults)]
    arguments_to_use <- arguments_to_use[arguments_to_use != 
        ""]
    finding <- tryCatch(do.call("check_file_layout", arguments_to_use), 
        coldr = function(e) return(e$message))
    findings <- c(findings, finding)
    use <- modifyList(check_functions_in_file_defaults, arguments)
    arguments_to_use <- use[names(use) \%in\% names(check_functions_in_file_defaults)]
    arguments_to_use <- arguments_to_use[arguments_to_use != 
        ""]
    finding <- tryCatch(do.call("check_functions_in_file", arguments_to_use), 
        coldr = function(e) return(e$message))
    findings <- c(findings, finding)
    findings <- tidy_findings(findings)
    if (!is.null(findings)) {
        throw(paste(names(findings), findings, sep = " ", collapse = "\n"))
    }
    return(invisible(TRUE))
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
