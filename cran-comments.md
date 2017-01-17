Dear CRAN Team,
this is a new version of package cleanr.
I have done some spell checking and fixed a buggy vignette title.
Best, 
Dominik 

# Package  cleanr 1.1.3 

## Test  environments  
- R Under development (unstable) (2017-01-13 r71966)
  Platform: x86_64-pc-linux-gnu (64-bit)
  Running under: Debian GNU/Linux 8 (jessie) 
- R version 3.3.2 (2016-10-31)
  Platform: x86_64-pc-linux-gnu (64-bit)
  Running under: Ubuntu precise (12.04.5 LTS) 
- win-builder (devel) 

## R CMD check results
0 errors | 0 warnings | 1 note 
checking CRAN incoming feasibility ... NOTE
Maintainer: ‘Andreas Dominik Cullmann <adc-r@arcor.de>’

Possibly mis-spelled words in DESCRIPTION:
  Kernighan (9:11)
  Ritchie (9:31)
  pylint (16:51)

Package has help file(s) containing install/render-stage \Sexpr{} expressions but no prebuilt PDF manual.

### On Notes:
- Kernighan, Ritchie and pylint seem to be unknown to aspell.
- I use an Sexpr in a roxygen comment, it renders fine.

