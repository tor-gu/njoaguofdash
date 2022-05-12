tableUI <- function(id) {
  ns <- NS(id)
  tagList(
    h4(textOutput(ns("header"))),
    DT::DTOutput(ns("table"))
  )
}

tableServer <- function(id, filter_result, clicked_region) {
  moduleServer(id, function(input, output, session) {
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

    region_table <- reactive({
      table_server_get_region_table(
        filter_result$filtered_table(),
        filter_result$geography(),
        clicked_region()
      )
    })

    region_DT <- reactive({
      DT::datatable(
        region_table(),
        class="compact",
        extensions=c("Responsive", "ColReorder"),
        options=list(colReorder=TRUE)
      )
    })

    header_text <- reactive({
      table_server_get_header_text(filter_result$table_name(), clicked_region())
    })

    output$header <- renderText(header_text())
    output$table <- DT::renderDT(region_DT())
  })

}
