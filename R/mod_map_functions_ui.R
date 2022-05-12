map_ui_make_scale_choice_list <- function(filter_name) {
  # The relative scale is not available when there is no filter
  if (filter_name == "all") {
    c("Absolute"="absolute", "Per Capita"="percapita")
  } else {
    c("Absolute"="absolute", "Per Capita"="percapita", "Relative"="relative")
  }
}

map_ui_get_scale_new_selected_value <- function(current_selection, choices) {
  # Keep the current selection unless that is not not possible.
  # (This happens when when we switch from filtered to unfiltered)
  if (current_selection %in% choices) current_selection
  else choices[[1]]
}

map_ui_scale_help <- function() {
  "This controls the color scale of the map.<br/>
  <ul>
    <li><em>Absolute</em>: Raw count of incidents or subjects </li>
    <li><em>Per Capita</em>: Number of incidents per 100,000 residents, per
      year</li>
    <li><em>Relative</em>: When a filter is applied, the proportion of the
      region's incidents or subjects matching the filter.</li>
  </ul>"
}
