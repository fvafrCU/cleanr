#!/bin/sh
if [ README.Rmd -nt README.md ]; then
  printf "README.md is out of date please\n\tmake README.md\n"
  exit 1
fi 
