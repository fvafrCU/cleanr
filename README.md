[![Build Status](https://travis-ci.org/fvafrCU/cleanr.svg?branch=master)](https://travis-ci.org/fvafrCU/cleanr)
[![Coverage Status](https://codecov.io/github/fvafrCU/cleanr/coverage.svg?branch=master)](https://codecov.io/github/fvafrCU/cleanr?branch=master)

# cleanr
Check your R code for some of the most common layout flaws.


# Installation

```R
if (! require("devtools")) install.packages("devtools")
devtools::install_github("fvafrCU/cleanr")
```

# Introduction
Please see
```R
help("cleanr-package", package = "cleanr")
```
and 
```R
vignette("cleanr_Introduction", package = "cleanr")
```

# cleanr is a fork 
of [coldr](https://github.com/fvafrcu/coldr.git),
which was a set of shell scripts I used to check the file layout (number of 
lines, width of lines and the like) of code files and somehow turned out to be 
an R package.


