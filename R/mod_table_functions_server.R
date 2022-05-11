table_server_get_region_table <- function(filtered_table, geography,
                                          region) {
  # Filter the table by the selected region (or
  # return NULL if there is no region)                                                                                  region) {
  if (is.null(region)) {
    return(NULL)
  } else if (geography=="state") {
    table <- filtered_table %>%
      dplyr::filter(incident_municipality_county == region)
  } else {
    table <- filtered_table %>%
      dplyr::filter(incident_municipality == region)
  }

  # Sort by date
  table <- table %>% dplyr::arrange(incident_date_1)

  # Put the most interesting columns first
  if ("juvenile" %in% names(table)) {
    # Use 'juvenile' as an indication that the subject fields are present
    table %>% dplyr::relocate(incident_date_1, age, juvenile, race, gender)
  } else {
    # Otherwise, use the 'incident' fields
    table %>% dplyr::relocate(incident_date_1,
                              agency_name,
                              officer_age,
                              officer_race,
                              officer_gender)

  }
}


table_server_get_header_text <- function(table_name, region) {
  # e.g. "Colt's Neck Township incidents" or "Morris County subjects"
  template <- "{region} {table_name}s"
  glue::glue(template)

}
