#! /usr/local/bin/Rscript
# install R dependencies

# We could use renv.lock approach here instead, but will force re-creation of environment from scratch
# Does not provide a good way to ensure that sf/terra/gdalcubes are installed from source while other packages can be binary

install.packages(c("rstac", "spData", "earthdatalogin", "quarto", "pak", "decor"))
remotes::install_github('r-tmap/tmap')
remotes::install_github('boettiger-lab/earthdatalogin')
remotes::install_github('cboettig/duckdbfs')

# vscode and jupyter plugins
#install.packages(c("IRkernel", "languageserver", "httpgd"))
#IRkernel::installspec()

