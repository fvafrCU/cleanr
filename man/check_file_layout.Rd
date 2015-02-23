\name{check_file_layout}
\alias{check_file_layout}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
%%  ~~function to do ... ~~
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
check_file_layout(path, max_length = get_coldr_options("max_length"), max_width = get_coldr_options("max_width"))
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{path}{
%%     ~~Describe \code{path} here~~
}
  \item{max_length}{
%%     ~~Describe \code{max_length} here~~
}
  \item{max_width}{
%%     ~~Describe \code{max_width} here~~
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
function (path, max_length = get_coldr_options("max_length"), 
    max_width = get_coldr_options("max_width")) 
{
    file_content <- readLines(path)
    line_widths <- nchar(file_content)
    num_lines <- length(file_content)
    if (num_lines > max_length) {
        throw(paste(path, ": ", num_lines, " lines in file.", 
            sep = ""))
    }
    if (any(line_widths > max_width)) {
        long_lines_index <- line_widths > max_width
        throw(paste(path, ": line ", seq(along = file_content)[long_lines_index], 
            " counts ", line_widths[long_lines_index], " characters.", 
            sep = ""))
    }
    return(invisible(TRUE))
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
