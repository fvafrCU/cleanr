# inspired by https://raw.githubusercontent.com/yihui/knitr/master/Makefile
PKGNAME := $(shell sed -n "s/Package: *\([^ ]*\)/\1/p" DESCRIPTION)
PKGVERS := $(shell sed -n "s/Version: *\([^ ]*\)/\1/p" DESCRIPTION)
PKGSRC  := $(shell basename `pwd`)

temp_file := $(shell tempfile)
package_tools_file := utils/package_tools.R

R := R-devel
Rscript := Rscript-devel

# devtools
dev_all: dev_test dev_check

dev: dev_test_change dev_check

dev_test:
	rm ${temp_file} || TRUE; \
	${Rscript} --vanilla -e 'devtools::test()' >  ${temp_file} 2>&1; \
	sed -n -e '/^DONE.*/q;p' < ${temp_file} > dev_test.Rout 

dev_test_change:
	rm ${temp_file} || TRUE; \
	${Rscript} --vanilla ${test_changes_file} >  ${temp_file} 2>&1; \
	sed -n -e '/^DONE.*/q;p' < ${temp_file} > dev_test_change.Rout 

dev_check:
	rm ${temp_file} || TRUE; \
	${Rscript} --vanilla -e 'devtools::check()' > ${temp_file} 2>&1; \
	grep -v ".*'/" ${temp_file} | grep -v ".*/tmp/R.*" > dev_check.Rout 

dev_vignettes:
	${Rscript} --vanilla -e 'devtools::build_vignettes()'

# R CMD 
all: craninstall clean

craninstall: crancheck
	${R} --vanilla CMD INSTALL  ${PKGNAME}_${PKGVERS}.tar.gz

crancheck: build 
	export _R_CHECK_FORCE_SUGGESTS_=TRUE && \
        ${R} --vanilla CMD check --as-cran ${PKGNAME}_${PKGVERS}.tar.gz 

install: check 
	${R} --vanilla CMD INSTALL  ${PKGNAME}_${PKGVERS}.tar.gz && \
        printf '===== have you run\n\tmake demo && ' && \
        printf 'make package_tools && make runit && make cleanr\n?!\n' 

install_bare: build_bare 
	${R} --vanilla CMD INSTALL  ${PKGNAME}_${PKGVERS}.tar.gz 

check_bare: build_bare 
	export _R_CHECK_FORCE_SUGGESTS_=TRUE && \
        ${R} --vanilla CMD check --no-examples ${PKGNAME}_${PKGVERS}.tar.gz && \
        printf '===== run\n\tmake install\n!!\n'

check: build 
	export _R_CHECK_FORCE_SUGGESTS_=TRUE && \
        ${R} --vanilla CMD check ${PKGNAME}_${PKGVERS}.tar.gz && \
        printf '===== run\n\tmake install\n!!\n'

build_bare: 
	${R} --vanilla CMD build ../${PKGSRC}

build: roxy 
	${R} --vanilla CMD build ../${PKGSRC}

direct_check:  
	${R} --vanilla CMD check ../${PKGSRC} ## check without build -- not recommended


# utils

.PHONY: coverage
coverage:
	${Rscript} --vanilla -e 'co <- covr::package_coverage(path = ".", function_exclusions = "\\.onLoad"); covr::zero_coverage(co); print(co)'

.PHONY: roxy
roxy:
	${R} --vanilla -e 'roxygen2::roxygenize(".")'

.PHONY: utils
utils: runit cleanr package_tools


.PHONY: runit
runit:
	cd ./tests/ && ${Rscript} --vanilla ./runit.R

.PHONY: cleanr
cleanr:
	${Rscript} --vanilla -e 'cleanr::load_internal_functions("cleanr"); cleanr::check_directory("R/", max_arguments = 6)'

.PHONY: package_tools
package_tools:
	rm inst/doc/*.R || true
	${Rscript} --vanilla ${package_tools_file} > package_tools.Rout 2>&1 

.PHONY: clean
clean:
	rm -rf ${PKGNAME}.Rcheck

.PHONY: remove
remove:
	 ${R} --vanilla CMD REMOVE  ${PKGNAME}

# specifics
.PHONY: demo
demo:
	# R CMD BATCH  demo/${rpackage}.r ## Rscript doesn't load
	# methods, but we fixed that.
	demo/${PKGNAME}.R


.PHONY: dependencies
dependencies:
	${Rscript} --vanilla -e 'deps <-c("covr", "knitr", "devtools", "rmarkdown", "RUnit", "checkmate", "roxygen2", "lintr"); for (dep in deps) {if (! require(dep, character.only = TRUE)) install.packages(dep, repos = "https://cran.uni-muenster.de/")}'

