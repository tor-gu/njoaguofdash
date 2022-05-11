mapOutputUI <- function(id) {
  ns <- NS(id)
  tagList(
    plotly::plotlyOutput(ns("plot")),
  )
}
mapInputUI <- function(id) {
  ns <- NS(id)
  tagList(
    radioButtons(ns("scale"), "Scale",
                 choices=c("Absolute"="absolute",
                           "Per Capita"="percapita",
                           "Relative"="relative"),
                 selected="absolute", inline=FALSE) %>%
      shinyhelper::helper(type = "inline",
                          title = "Scale",
                          content = map_ui_scale_help())
  )
}

mapServer <- function(id, filter_result) {
  moduleServer(id, function(input, output, session) {
    observe({
      updateRadioButtons(
        session,
        "scale",
        choices = map_ui_make_scale_choice_list(filter_result$filter_name()),
        selected = input$scale
      )
    })

    map <- reactive({
      map_server_get_map(filter_result$geography(), filter_result$county())
    })

    table_summary <- reactive({
      map_server_get_table_summary(
        filter_result$geography(),
        filter_result$county(),
        filter_result$filtered_table()
      )
    })


    region_values <- reactive({
      map_server_get_region_values(
        filter_result$table_name(),
        table_summary(),
        filter_result$unfiltered_summary()
      )
    })

    map_with_values <- reactive({
      map_server_add_values_to_map(map(), region_values())
    })

    suppressPlotlyMessage <- function(p) {
      suppressWarnings(plotly::plotly_build(p))
    }

    title_text <- reactive({
      map_server_get_title_text(
        filter_result$geography(),
        filter_result$county(),
        filter_result$table_name(),
        input$scale
      )
    })

    caption_text <- reactive({
      map_server_get_caption_text(filter_result$filter_name(),
                                  filter_result$filter_value())
    })

    absolute_plot <- reactive({
      map_server_make_plot(map_with_values(), "absolute_count",
                           title_text(), caption_text())
    })

    relative_plot <- reactive({
      map_server_make_plot(map_with_values(), "relative",
                           title_text(), caption_text())
    })

    percapita_plot <- reactive({
      map_server_make_plot(map_with_values(), "percapita",
                           title_text(), caption_text())

    })

    output$plot <- plotly::renderPlotly({
      if (input$scale == "absolute") {
        absolute_plot()
      } else if (input$scale == "relative") {
        relative_plot()
      } else {
        percapita_plot()
      }
    })


    reactive({
      event <- plotly::event_data("plotly_click") %>% head(1)
      if (is.null(event)) NULL else dplyr::pull(event, key)
    })

  })
}
