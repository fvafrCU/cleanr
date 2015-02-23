\name{set_coldr_options}
\alias{set_coldr_options}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
%%  ~~function to do ... ~~
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
set_coldr_options(..., reset = FALSE, overwrite = TRUE)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{\dots}{
%%     ~~Describe \code{\dots} here~~
}
  \item{reset}{
%%     ~~Describe \code{reset} here~~
}
  \item{overwrite}{
%%     ~~Describe \code{overwrite} here~~
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
function (..., reset = FALSE, overwrite = TRUE) 
{
    defaults <- list(max_width = 80, max_length = 300, max_lines = 65, 
        max_lines_of_code = 50, max_arguments = 5, max_nesting_depth = 3, 
        max_line_width = 80)
    option_list <- list(...)
    if (is.null(getOption("coldr")) || reset) 
        options(coldr = defaults)
    else {
        set_options <- getOption("coldr")
        if (overwrite) {
            options(coldr = modifyList(set_options, option_list))
        }
        else {
            if (length(option_list) == 0) 
                option_list <- defaults
            is_option_unset <- !(names(option_list) \%in\% names(set_options))
            if (any(is_option_unset)) 
                options(coldr = append(set_options, option_list[is_option_unset]))
        }
    }
    max_lines <- get_coldr_options("max_lines", flatten_list = TRUE)
    max_lines_of_code <- get_coldr_options("max_lines_of_code", 
        flatten_list = TRUE)
    if (max_lines < max_lines_of_code) {
        set_coldr_options(max_lines = max_lines_of_code)
        warning(paste("maximum number of lines was less than maximum number of", 
            "lines of code, resetting the former to the latter."))
    }
    return(invisible(TRUE))
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
