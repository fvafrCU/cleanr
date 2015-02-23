\name{check_function_layout}
\alias{check_function_layout}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
%%  ~~function to do ... ~~
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
check_function_layout(object, max_lines_of_code = get_coldr_options("max_lines_of_code"), max_lines = get_coldr_options("max_lines"), max_arguments = get_coldr_options("max_arguments"), max_nesting_depth = get_coldr_options("max_nesting_depth"), max_line_width = get_coldr_options("max_line_width"))
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{object}{
%%     ~~Describe \code{object} here~~
}
  \item{max_lines_of_code}{
%%     ~~Describe \code{max_lines_of_code} here~~
}
  \item{max_lines}{
%%     ~~Describe \code{max_lines} here~~
}
  \item{max_arguments}{
%%     ~~Describe \code{max_arguments} here~~
}
  \item{max_nesting_depth}{
%%     ~~Describe \code{max_nesting_depth} here~~
}
  \item{max_line_width}{
%%     ~~Describe \code{max_line_width} here~~
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
function (object, max_lines_of_code = get_coldr_options("max_lines_of_code"), 
    max_lines = get_coldr_options("max_lines"), max_arguments = get_coldr_options("max_arguments"), 
    max_nesting_depth = get_coldr_options("max_nesting_depth"), 
    max_line_width = get_coldr_options("max_line_width")) 
{
    findings <- NULL
    finding <- tryCatch(check_num_arguments(object, maximum = max_arguments), 
        coldr = function(e) return(e$message))
    findings <- c(findings, finding)
    finding <- tryCatch(check_nesting_depth(object, maximum = max_nesting_depth), 
        coldr = function(e) return(e$message))
    findings <- c(findings, finding)
    finding <- tryCatch(check_line_width(object, maximum = max_line_width), 
        coldr = function(e) return(e$message))
    findings <- c(findings, finding)
    finding <- tryCatch(check_num_lines(object, maximum = max_lines), 
        coldr = function(e) return(e$message))
    findings <- c(findings, finding)
    finding <- tryCatch(check_num_lines_of_code(object, maximum = max_lines_of_code), 
        coldr = function(e) return(e$message))
    findings <- c(findings, finding)
    finding <- tryCatch(check_return(object), coldr = function(e) return(e$message))
    findings <- c(findings, finding)
    findings <- tidy_findings(findings)
    if (!is.null(findings)) {
        function_name <- sub("source_kept$", "", deparse(substitute(object)), 
            fixed = TRUE)
        throw(paste(function_name, names(findings), findings, 
            sep = " ", collapse = "\n"))
    }
    return(invisible(TRUE))
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
