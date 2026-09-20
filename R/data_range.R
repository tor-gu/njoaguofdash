#' Number of years spanned by the installed njoaguof data
#'
#' The per-capita map scale is a yearly rate, so it needs to know how many
#' years of data it is averaging over. This derives that figure from
#' [njoaguof::incident] at the moment it is called.
#'
#' @return The span of `njoaguof::incident$incident_date_1`, in years.
#' @export
#'
#' @examples
#' njoaguof_data_range_in_years()
njoaguof_data_range_in_years <- function() {
  date_range <- range(njoaguof::incident$incident_date_1, na.rm = TRUE)
  as.numeric(date_range[[2]] - date_range[[1]]) / 365.25
}
