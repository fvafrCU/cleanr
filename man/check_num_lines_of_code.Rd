\name{check_num_lines_of_code}
\alias{check_num_lines_of_code}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
%%  ~~function to do ... ~~
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
check_num_lines_of_code(object, maximum = get_coldr_options("max_lines_of_code"))
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{object}{
%%     ~~Describe \code{object} here~~
}
  \item{maximum}{
%%     ~~Describe \code{maximum} here~~
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
function (object, maximum = get_coldr_options("max_lines_of_code")) 
{
    function_body <- get_function_body(object)
    line_is_comment_pattern <- "^\\s*#"
    lines_of_code <- grep(line_is_comment_pattern, function_body, 
        value = TRUE, invert = TRUE)
    num_lines_of_code <- length(lines_of_code)
    if (num_lines_of_code > maximum) 
        throw(paste("found", num_lines_of_code, "lines of code, maximum was", 
            maximum))
    return(invisible(TRUE))
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
