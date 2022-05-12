map_server_get_map <- function(geography, county) {
  if (geography=="state")
    county_map
  else
    municipality_map[[county]]
}

map_server_get_table_summary <- function(geography, county, table) {
  if (geography == "state") {
    table %>%
      dplyr::group_by(incident_municipality_county) %>%
      dplyr::summarize(filtered_count = dplyr::n()) %>%
      dplyr::right_join(county_pop,
                        by = c("incident_municipality_county" = "county")) %>%
      dplyr::mutate(filtered_count = tidyr::replace_na(filtered_count, 0)) %>%
      dplyr::rename(region = incident_municipality_county)
  } else {
    table %>%
      dplyr::group_by(incident_municipality) %>%
      dplyr::summarize(filtered_count = dplyr::n()) %>%
      dplyr::right_join(municipality_pop[[county]],
                        by = c("incident_municipality" = "municipality")) %>%
      dplyr::mutate(filtered_count = tidyr::replace_na(filtered_count, 0)) %>%
      dplyr::rename(region = incident_municipality)
  }
}

map_server_get_region_values <- function(table_name,
                                         filtered_summary,
                                         unfiltered_summary) {
  if (table_name == "incident")
    label <- "incidents"
  else
    label <- "subjects"
  hover_template <- stringr::str_flatten(c(
    "{region}",                       # Mercer County
    "{absolute_count} {label}",       # 23 incidents
    "{relative}% of all {label}",     # 4.53% of all incidents
    "{percapita} per 100K pop/year"), # 0.324 per 100K pop/year
    collapse="\n"
  )
  hover_template_zero_denom <- stringr::str_flatten(c(
    "{region}",                     # Mercer County
    "No data"),                     # No data
    collapse="\n"
  )
  filtered_summary %>%
    dplyr::left_join(unfiltered_summary, by = "region") %>%
    dplyr::rename(absolute_count = filtered_count) %>%
    dplyr::mutate(
      relative = signif(100 * absolute_count / region_count, digits = 3)) %>%
    dplyr::mutate(
      percapita = signif(
        100000 * absolute_count / population / data_range_in_years,
        digits = 3)) %>%
    dplyr::mutate(
      absolute_count = dplyr::if_else(region_count == 0, NA_integer_, absolute_count)) %>%
    dplyr::mutate(
      relative = dplyr::if_else(region_count == 0, NA_real_, relative)) %>%
    dplyr::mutate(
      percapita = dplyr::if_else(region_count == 0, NA_real_, percapita)) %>%
    dplyr::mutate(hover_text =
                    dplyr::if_else(
                      is.na(region_count) | region_count == 0,
                      glue::glue(hover_template_zero_denom),
                      glue::glue(hover_template)
                    ))
}

map_server_add_values_to_map <- function(map, values) {
  map %>%
    tigris::geo_join(values,
                     by_sp = "NAMELSAD",
                     by_df = "region",
                     how = "inner")
}

map_server_get_title_text <- function(geography, county, table_name, scale) {
  region <- dplyr::if_else(geography == "state",
                           "New Jersey",
                           county)
  scale_text <- dplyr::case_when(
    scale == "absolute" ~ "",
    scale == "relative" ~ "Relative to unfiltered count",
    scale == "percapita" ~ "Yearly, per 100K population",
  )
  template <- stringr::str_flatten(c(
    "{region}  -- use of force ({table_name}s)",
    "<sub>{scale_text}</sub>"
  ),
  collapse = "<br>")
  glue::glue(template)
}

map_server_get_caption_text <- function(filter_name,
                                        filter_display_name,
                                        filter_value) {
  if (filter_name == "all") {
    ""
  } else {
    glue::glue("Filtered by {filter_display_name} = {filter_value}")
  }
}

map_server_hide_colorbar_maybe <- function(p, condition) {
  # this is for use in the pipe in the next function --
  # we want to remove the color bar conditionally
  if (condition)
    p %>% plotly::hide_colorbar()
  else
    p
}

map_server_make_plot <- function(map_with_values, value_column, title_text,
                                 caption_text) {
  if (value_column == "absolute_count") {
    plot <- map_with_values %>%
      plotly::plot_ly(
        type = "scatter",
        mode = "lines",
        split =  ~ NAMELSAD,
        color =  ~ absolute_count,
        stroke =  ~ I("black"),
        text =  ~ hover_text,
        hoveron = "fills",
        hoverinfo = "text",
        key =  ~ NAMELSAD,
        showlegend = FALSE
      )
    val_range <- range(map_with_values$absolute_count, na.rm=TRUE)
  } else if ( value_column == "relative") {
    plot <- map_with_values %>%
      plotly::plot_ly(
        type = "scatter",
        mode = "lines",
        split =  ~ NAMELSAD,
        color =  ~ relative,
        stroke =  ~ I("black"),
        text =  ~ hover_text,
        hoveron = "fills",
        hoverinfo = "text",
        key =  ~ NAMELSAD,
        showlegend = FALSE
      )
    val_range <- range(map_with_values$relative, na.rm=TRUE)
  } else if (value_column == "percapita") {
    plot <- map_with_values %>%
      plotly::plot_ly(
        type = "scatter",
        mode = "lines",
        split =  ~ NAMELSAD,
        color =  ~ percapita,
        stroke =  ~ I("black"),
        text =  ~ hover_text,
        hoveron = "fills",
        hoverinfo = "text",
        key =  ~ NAMELSAD,
        showlegend = FALSE
      )
    val_range <- range(map_with_values$percapita, na.rm=TRUE)
  } else { return (NULL) }

  # Don't have color bars with negative values
  zero_range <- val_range[[1]] == val_range[[2]]

  plot %>%
    plotly::config(displayModeBar = FALSE) %>%
    plotly::layout(title = list(text = title_text),
                   xaxis = list(title = caption_text)) %>%
    plotly::colorbar(title = "") %>%
    map_server_hide_colorbar_maybe(zero_range) %>%
    plotly::event_register("plotly_click")
}

