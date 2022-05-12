tableUI <- function(id) {
  ns <- NS(id)
  tagList(
    h4(textOutput(ns("header"))),
    DT::DTOutput(ns("table"))
  )
}

tableServer <- function(id, filter_result, clicked_region) {
  moduleServer(id, function(input, output, session) {
    # Hide everything when there is no region selected
    observe({
      shinyjs::toggleElement(
        "header",
        condition = {!is.null(clicked_region())},
        anim = FALSE
      )
      shinyjs::toggleElement(
        "table",
        condition = {!is.null(clicked_region())},
        anim = FALSE
      )
    })

    # Load the table of subject or incidents
    region_table <- reactive({
      table_server_get_region_table(
        filter_result$filtered_table(),
        filter_result$geography(),
        clicked_region()
      )
    })

    # Wrap the table in a DT
    region_DT <- reactive({
      DT::datatable(
        region_table(),
        class="compact",
        extensions=c("Responsive", "ColReorder"),
        options=list(colReorder=TRUE)
      )
    })

    # Table header
    header_text <- reactive({
      table_server_get_header_text(filter_result$table_name(), clicked_region())
    })

    # Render the outputs
    output$header <- renderText(header_text())
    output$table <- DT::renderDT(region_DT())
  })

}
