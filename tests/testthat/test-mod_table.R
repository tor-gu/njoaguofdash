library(shiny)

# The table must produce no value until a region is clicked. An empty DT still
# counts as an output value, and one rendered in the session's first flush
# displaces the plotly map's value from that same message, leaving the map
# stuck behind its loading spinner.

make_filter_result <- function() {
  list(
    table_name     = reactive("incident"),
    geography      = reactive("state"),
    filtered_table = reactive(njoaguof::incident)
  )
}

test_that("the table produces no value until a region is clicked", {
  clicked_region <- reactiveVal(NULL)
  testServer(
    tableServer,
    args = list(filter_result = make_filter_result(),
                clicked_region = clicked_region),
    {
      session$flushReact()
      expect_error(region_table(), class = "shiny.silent.error")
      expect_error(header_text(), class = "shiny.silent.error")
    }
  )
})

test_that("the table fills in once a region is clicked", {
  clicked_region <- reactiveVal(NULL)
  testServer(
    tableServer,
    args = list(filter_result = make_filter_result(),
                clicked_region = clicked_region),
    {
      clicked_region("Essex County")
      session$flushReact()

      table <- region_table()
      expect_gt(nrow(table), 0)
      expect_equal(names(table)[1:2], c("incident_date_1", "agency_name"))
      expect_setequal(unique(table$incident_municipality_county), "Essex County")
      expect_equal(as.character(header_text()), "Essex County incidents")
    }
  )
})
