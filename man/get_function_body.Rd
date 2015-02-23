\name{get_function_body}
\alias{get_function_body}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
%%  ~~function to do ... ~~
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
get_function_body(object)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{object}{
%%     ~~Describe \code{object} here~~
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
function (object) 
{
    lines_in_function <- capture.output(object)
    if (!any(grepl("{", lines_in_function, fixed = TRUE))) {
        is_split_onliner <- length(lines_in_function) > 1
        opening_line_num <- 1 + as.numeric(is_split_onliner)
        closing_line_num <- length(lines_in_function)
    }
    else {
        opening_line_num <- min(grep("{", lines_in_function, 
            fixed = TRUE))
        closing_line_num <- max(grep("}", lines_in_function, 
            fixed = TRUE))
    }
    opening_brace_ends_line <- grepl("\\{\\s*$", lines_in_function[opening_line_num])
    if (opening_brace_ends_line) 
        opening_line_num <- opening_line_num + 1
    closing_brace_starts_line <- grepl("^\\s*\\}", lines_in_function[closing_line_num])
    if (closing_brace_starts_line) 
        closing_line_num <- closing_line_num - 1
    return(lines_in_function[opening_line_num:closing_line_num])
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
