---
output: github_document
---
[![Build Status](https://travis-ci.org/fvafrCU/cleanr.svg?branch=master)](https://travis-ci.org/fvafrCU/cleanr)
[![Coverage Status](https://codecov.io/github/fvafrCU/cleanr/coverage.svg?branch=master)](https://codecov.io/github/fvafrCU/cleanr?branch=master)
[![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/cleanr)](https://cran.r-project.org/package=cleanr)
# cleanr
Check your R code for some of the most common layout flaws.

<!-- README.md is generated from README.Rmd. Please edit that file -->


## Introduction
Please read the [vignette](http://htmlpreview.github.io/?https://github.com/fvafrCU/cleanr/blob/master/inst/doc/cleanr_Introduction.html)
or, after installation, the help page:


```r
options(pager = "/bin/cat")
help("cleanr-package", package = "cleanr")
```

## Installation
You can install cleanr from github with:

```r
if (! require("devtools")) install.packages("devtools")
devtools::install_github("fvafrCU/cleanr")
```

## cleanr is a fork 
of [coldr](https://github.com/fvafrcu/coldr.git),
which was a set of shell scripts I used to check the file layout (number of 
lines, width of lines and the like) of code files and somehow turned out to be 
an R package.


