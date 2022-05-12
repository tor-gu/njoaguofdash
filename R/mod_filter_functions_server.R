filter_server_get_tables <- function(table_name, geography,
                                     county) {
  incident_table <- njoaguof::incident
  if (geography == "county") {
    incident_table <- incident_table %>%
      dplyr::filter(incident_municipality_county == county)
  }

  subject_table <- NULL
  if ( table_name == "subject" ) {
    subject_table <- incident_table %>%
      dplyr::left_join(njoaguof::subject, by="form_id")
  }

  list(incident_table = incident_table,
       subject_table = subject_table)
}

filter_server_get_summary_table <- function(tables, table_name, geography) {
  if (table_name == "incident") {
    table <- tables$incident_table
  } else {
    table <- tables$subject_table
  }

  if (geography == "state") {
    table %>%
      dplyr::group_by(incident_municipality_county) %>%
      dplyr::summarize(region_count = dplyr::n()) %>%
      dplyr::rename(region=incident_municipality_county)
  } else {
    table %>%
      dplyr::group_by(incident_municipality) %>%
      dplyr::summarize(region_count = dplyr::n()) %>%
      dplyr::rename(region=incident_municipality)
  }
}

filter_server_get_joined_table <- function(tables, table_name, filter_name) {
  this_filter <- filters %>%
    dplyr::filter(table==table_name, filter==filter_name)

  if (table_name == "subject" && is.na(this_filter$join_table)) {
    base_table <- tables$subject_table
  } else {
    base_table <- tables$incident_table
  }

  if (!is.na(this_filter$join_table)) {
    join_table <- rlang::eval_tidy(rlang::sym(this_filter$join_table))
    base_table %>% dplyr::left_join(join_table, by="form_id")
  } else {
    base_table
  }
}

filter_server_get_filtered_table <- function(table, table_name, filter_name,
                                             filter_value) {
  this_filter <- filters %>%
    dplyr::filter(table == table_name, filter == filter_name)

  if (!is.na(this_filter$filter_column)) {
    table %>%
      dplyr::filter(!!rlang::sym(this_filter$filter_column) == filter_value)
  } else {
    table
  }
}

filter_server_get_filter_display_name <- function(table_name, filter_name) {
  this_filter <- filters %>%
    dplyr::filter(table==table_name, filter==filter_name) %>%
    dplyr::pull(display_name)
}
