#' @keywords internal
"_PACKAGE"

## The dashboard is built almost entirely out of shiny verbs -- `NS`,
## `moduleServer`, `reactive`, `observe` and friends appear unqualified
## throughout `R/mod_*.R`. Importing the whole namespace is what makes those
## calls resolve from inside the package.
#' @import shiny
#'
## `filters` in R/mod_filter_filters.R is built at load time.
#' @importFrom tibble tribble
#'
## The maps in sysdata.rda are sf objects, and both the dplyr join in
## map_server_add_values_to_map() and plotly::plot_ly() need sf's methods
## registered to handle them.
#' @importFrom sf st_geometry
NULL

## Column names used in dplyr's non-standard evaluation. Declaring them keeps
## "no visible binding for global variable" out of R CMD check.
utils::globalVariables(c(
  "absolute_count", "age", "agency_name", "display_name", "filter",
  "filtered_count", "gender", "incident_date_1", "incident_municipality",
  "incident_municipality_county", "join_table", "juvenile", "key",
  "officer_age", "officer_gender", "officer_race", "percapita", "population",
  "race", "region_count", "relative"
))
