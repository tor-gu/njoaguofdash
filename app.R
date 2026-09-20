# Entry point for Shiny hosting: Posit Connect Cloud, shinyapps.io, Shiny
# Server and the Dockerfile in this repo.
#
# This file is .Rbuildignore'd, so it is not part of the installed package.
#
# To run from an R session that already has the package installed:
#
#     njoaguofdash::njoaguofdashApp()

pkgload::load_all(export_all = FALSE, helpers = FALSE, attach_testthat = FALSE)

njoaguofdash::njoaguofdashApp()
