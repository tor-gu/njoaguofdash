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

app_build_about_md <- function(md_dir) {
  # Use a temp dir by default
  if (is.null(md_dir)) md_dir <- tempdir()

  # Copy the system about.Rmd to the md dir
  if ( file.copy(system.file("about.Rmd", package="njoaguofdash"),
                 md_dir,
                 overwrite = TRUE) ) {
    # Render the doc and return the path to about.md
    rmarkdown::render(
      file.path(md_dir, "about.Rmd"),
      rmarkdown::md_document(),
      output_dir = md_dir)
  } else {
      # Log a message and return an empty string.
      # (when passed to includeMarkdown, will get get a blank page)
      message(glue::glue(
        "Cannot copy about.Rmd to {md_dir}; 'About' page will not be available"))
      ""
  }
}
