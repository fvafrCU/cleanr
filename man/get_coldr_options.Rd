\name{get_coldr_options}
\alias{get_coldr_options}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
%%  ~~function to do ... ~~
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
get_coldr_options(..., remove_names = FALSE, flatten_list = TRUE)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{\dots}{
%%     ~~Describe \code{\dots} here~~
}
  \item{remove_names}{
%%     ~~Describe \code{remove_names} here~~
}
  \item{flatten_list}{
%%     ~~Describe \code{flatten_list} here~~
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
function (..., remove_names = FALSE, flatten_list = TRUE) 
{
    if (missing(...)) {
        option_list <- getOption("coldr")
    }
    else {
        option_names <- as.vector(...)
        options_set <- getOption("coldr")
        option_list <- options_set[names(options_set) \%in\% option_names]
    }
    if (flatten_list) 
        option_list <- unlist(option_list)
    if (remove_names) 
        names(option_list) <- NULL
    return(option_list)
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
