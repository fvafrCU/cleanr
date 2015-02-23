\name{load_internal_functions}
\alias{load_internal_functions}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
%%  ~~function to do ... ~~
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
load_internal_functions(package, ...)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{package}{
%%     ~~Describe \code{package} here~~
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
function (package, ...) 
{
    library(package, character.only = TRUE)
    exported_names <- ls(paste("package", package, sep = ":"), 
        ...)
    is_exported_name_function <- vapply(exported_names, function(x) is.function(eval(parse(text = x))), 
        TRUE)
    exported_functions <- exported_names[is_exported_name_function]
    package_namespace <- asNamespace(package)
    package_names <- ls(envir = package_namespace)
    is_package_name_function <- vapply(package_names, function(x) {
        name_in_package <- paste("package_namespace$", x, sep = "")
        is.function(eval(parse(text = name_in_package)))
    }, TRUE)
    package_functions <- package_names[is_package_name_function]
    internal_functions <- setdiff(package_functions, exported_functions)
    for (name in internal_functions) {
        assign(name, get(name, envir = package_namespace, inherits = FALSE), 
            envir = .GlobalEnv)
    }
    return(invisible(TRUE))
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
