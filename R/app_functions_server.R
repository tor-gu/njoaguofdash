app_exclude_bookmarks <- function() {
  # For the bookmark button, we want to exclude everything
  # from plotly and DT.

  dt_names <- c("table_cells_selected",
                "table_search",
                "table_rows_current", "table_rows_selected", "table_rows_all",
                "table_columns_selected",
                "table_state",
                "table_cell_clicked")
  plotly_names <- c("plotly_hover", "plotly_click", "plotly_selected",
                    "plotly_relayout", "plotly_afterplot")

  setBookmarkExclude(
    c(
      sprintf("table-%s", dt_names),
      ".clientValue-default-plotlyCrosstalkOpts",
      sprintf(".clientValue-%s-pop_hist", plotly_names),
      sprintf("%s-A", plotly_names)
    )
  )
}
