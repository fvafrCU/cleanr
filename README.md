---
output:
  md_document:
    variant: markdown_github
---
[![Build Status](https://travis-ci.org/fvafrCU/cleanr.svg?branch=master)](https://travis-ci.org/fvafrCU/cleanr)
[![Coverage Status](https://codecov.io/github/fvafrCU/cleanr/coverage.svg?branch=master)](https://codecov.io/github/fvafrCU/cleanr?branch=master)
[![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/cleanr)](https://cran.r-project.org/package=cleanr)

# cleanr
Check your R code for some of the most common layout flaws.

<!-- README.md is generated from README.Rmd. Please edit that file -->


## Introduction
Please read the vignette. Either [the version on github](http://htmlpreview.github.io/?https://github.com/fvafrCU/cleanr/blob/master/inst/doc/cleanr_Introduction.html)
or [the one released on cran](https://cran.r-project.org/web/packages/cleanr/vignettes/cleanr_Introduction.html).

Or, after installation, the help page:

<blockquote>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"><html xmlns="http://www.w3.org/1999/xhtml"><head><title>R: Helps You to Code Cleaner</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link rel="stylesheet" type="text/css" href="R.css" />
</head><body>

<table width="100%" summary="page for cleanr-package"><tr><td>cleanr-package</td><td style="text-align: right;">R Documentation</td></tr></table>

<h2>Helps You to Code Cleaner</h2>

<h3>Description</h3>

<p>Check your R code for some of the most common layout flaws.
</p>


<h3>Details</h3>

<p>Many tried to teach us how to write code less dreadful, be it implicitly as
B. W. Kernighan and D. M. Ritchie in <cite>The C Programming Language</cite> did,
be it explicitly as
R.C. Martin in <cite>Clean Code: A Handbook of Agile Software Craftsmanship</cite>
did.
</p>
<p>So we should check our code for files too long or wide, functions with too
many lines, too wide lines, too many arguments or too many levels of nesting.
</p>


<h3>Note</h3>

<p>This is not a static code analyzer like pylint or the like. If you're
looking for a static code analyzer, check out lintr
(<a href="https://cran.r-project.org/package=lintr">https://cran.r-project.org/package=lintr</a> or
<a href="https://github.com/jimhester/lintr">https://github.com/jimhester/lintr</a>).
</p>


<h3>Author(s)</h3>

<p>Andreas Dominik Cullmann, &lt;adc-r@arcor.de&gt;
</p>


<h3>See Also</h3>

<p>Packages
<span class="pkg">codetools</span>
(<a href="https://cran.r-project.org/package=codetools">https://cran.r-project.org/package=codetools</a>),
<span class="pkg">formatR</span>
(<a href="https://cran.r-project.org/package=formatR">https://cran.r-project.org/package=formatR</a>).
and
<span class="pkg">lintr</span>
(<a href="https://cran.r-project.org/package=lintr">https://cran.r-project.org/package=lintr</a>).
</p>


</body></html>
</blockquote>

## Installation
You can install cleanr from github with:

```r
if (! require("devtools")) install.packages("devtools")
devtools::install_github("fvafrCU/cleanr", quiet = TRUE)
```

## cleanr is a fork 
of [coldr](https://github.com/fvafrcu/coldr.git),
which was a set of shell scripts I used to check the file layout (number of 
lines, width of lines and the like) of code files and somehow turned out to be 
an R package.


