# inspired by https://raw.githubusercontent.com/yihui/knitr/master/Makefile
PKGNAME := $(shell sed -n "s/Package: *\([^ ]*\)/\1/p" DESCRIPTION)
PKGVERS := $(shell sed -n "s/Version: *\([^ ]*\)/\1/p" DESCRIPTION)
PKGSRC  := $(shell basename `pwd`)

temp_file := $(shell tempfile)
lintr_script := utils/lintr.R
formatR_script := utils/formatR.R

R := R-devel
Rscript := Rscript-devel

all: install_bare dev_check dev_test dev_vignettes crancheck utils 

# devtools
dev_all: dev_test dev dev_vignettes


dev: dev_check dev_spell

dev_spell: roxy 
	${Rscript} --vanilla -e 'spell <- devtools::spell_check(ignore = c("github" , "https", "lintr", "pylint", "Kernighan", "jimhester", "Cullmann", "adc", "arcor", "de", "tryCatch")); if (length(spell) > 0) {print(spell); stop("spell check failed")} '

dev_test:
	rm ${temp_file} || TRUE; \
	${Rscript} --vanilla -e 'devtools::test()' >  ${temp_file} 2>&1; \
	sed -n -e '/^DONE.*/q;p' < ${temp_file} | \
	sed -e "s# /.*\(${PKGNAME}\)# \1#" > dev_test.Rout 

dev_check: runit README.md
	rm ${temp_file} || TRUE; \
	${Rscript} --vanilla -e 'devtools::check(cran = TRUE, check_version = TRUE)' > ${temp_file} 2>&1; \
	grep -v ".*'/" ${temp_file} | grep -v ".*‘/" > dev_check.Rout 

dev_vignettes:
	${Rscript} --vanilla -e 'devtools::build_vignettes()'

dev_release:
	${Rscript} --vanilla -e 'devtools::release()'

dev_devel:
	${Rscript} --vanilla -e 'devtools::use_dev_version()'

# R CMD 
craninstall: crancheck
	${R} --vanilla CMD INSTALL  ${PKGNAME}_${PKGVERS}.tar.gz

crancheck: build  runit
	export _R_CHECK_FORCE_SUGGESTS_=TRUE && \
        ${R} --vanilla CMD check --as-cran ${PKGNAME}_${PKGVERS}.tar.gz 

install: check 
	${R} --vanilla CMD INSTALL  ${PKGNAME}_${PKGVERS}.tar.gz && \
        printf '===== have you run\n\tmake demo && ' && \
        printf 'make utils\n?!\n' 

install_bare: build_bare 
	${R} --vanilla CMD INSTALL  ${PKGNAME}_${PKGVERS}.tar.gz 

check_bare: build_bare runit README.md
	export _R_CHECK_FORCE_SUGGESTS_=TRUE && \
		_R_CHECK_CRAN_INCOMING_USE_ASPELL_=TRUE && \
        ${R} --vanilla CMD check --no-examples ${PKGNAME}_${PKGVERS}.tar.gz && \
        printf '===== run\n\tmake install\n!!\n'

check: build runit
	export _R_CHECK_FORCE_SUGGESTS_=TRUE && \
        ${R} --vanilla CMD check ${PKGNAME}_${PKGVERS}.tar.gz && \
        printf '===== run\n\tmake install\n!!\n'

build_bare: 
	${R} --vanilla CMD build ../${PKGSRC}

build: roxy README.md
	${R} --vanilla CMD build ../${PKGSRC}

direct_check:  
	${R} --vanilla CMD check ../${PKGSRC} ## check without build -- not recommended


# utils

.PHONY: roxy
roxy:
	${R} --vanilla -e 'roxygen2::roxygenize(".")'

.PHONY: utils
utils: runit cleanr formatR lintr coverage

.PHONY: coverage
coverage:
	${Rscript} --vanilla -e 'co <- covr::package_coverage(path = ".", function_exclusions = "\\.onLoad"); covr::zero_coverage(co); print(co)'


.PHONY: runit
runit:
	cd ./tests/ && ${Rscript} --vanilla ./runit.R || printf "\nMaybe your installation is stale? \nTry\n\tmake install_bare\n\n"

.PHONY: cleanr
cleanr:
	${Rscript} --vanilla -e 'cleanr::load_internal_functions("cleanr"); cleanr::check_directory("R/", max_num_arguments = 8, check_return = FALSE)'

.PHONY: lintr
lintr:
	rm inst/doc/*.R || true
	${Rscript} --vanilla ${lintr_script} > lintr.Rout 2>&1 

.PHONY: formatR
formatR:
	rm inst/doc/*.R || true
	${Rscript} --vanilla ${formatR_script} > formatR.Rout 2>&1 

.PHONY: clean
clean:
	rm -rf ${PKGNAME}.Rcheck

.PHONY: remove
remove:
	 ${R} --vanilla CMD REMOVE  ${PKGNAME}

# specifics
cran-comments.md: dev_check.Rout
	${Rscript} --vanilla -e 'source("./utils/cran_comments.R"); provide_cran_comments()' > cran_comments.Rout 2>&1 

README.md: README.Rmd
	${Rscript} --vanilla -e 'knitr::knit("README.Rmd")'

.PHONY: demo
demo:
	# R CMD BATCH  demo/${rpackage}.r ## Rscript doesn't load
	# methods, but we fixed that.
	demo/${PKGNAME}.R


.PHONY: dependencies
dependencies:
	${Rscript} --vanilla -e 'deps <-c("covr", "knitr", "devtools", "rmarkdown", "RUnit", "checkmate", "roxygen2", "lintr", "hunspell"); for (dep in deps) {if (! require(dep, character.only = TRUE)) install.packages(dep, repos = "https://cran.uni-muenster.de/")}'

