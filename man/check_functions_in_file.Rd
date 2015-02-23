\name{check_functions_in_file}
\alias{check_functions_in_file}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
%%  ~~function to do ... ~~
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
check_functions_in_file(path, ...)
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
    source_kept <- new.env(parent = globalenv())
    sys.source(path, envir = source_kept, keep.source = TRUE)
    for (name in ls(envir = source_kept, all.names = TRUE)) {
        eval(parse(text = paste(name, " <- source_kept$", name, 
            sep = "")))
        if (eval(parse(text = paste("is.function(", name, ")")))) {
            command <- paste("tryCatch(check_function_layout(", 
                "source_kept$", name, ",...),", "coldr = function(e) return(e$message))")
            finding <- eval(parse(text = command))
            findings <- c(findings, finding)
        }
    }
    findings <- tidy_findings(findings)
    if (!is.null(findings)) {
        throw(paste(path, names(findings), findings, sep = " ", 
            collapse = "\n"))
    }
    return(invisible(TRUE))
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
