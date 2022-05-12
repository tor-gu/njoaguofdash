mapOutputUI <- function(id) {
  ns <- NS(id)
  tagList(
    plotly::plotlyOutput(ns("plot")),
  )
}

mapInputUI <- function(id) {
  ns <- NS(id)
  tagList(
    # Scale selection
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

    # The scale option changes when there is a filter
    observe({
      choices <- map_ui_make_scale_choice_list(filter_result$filter_name())
      updateRadioButtons(
        session,
        "scale",
        choices = choices,
        selected = map_ui_get_scale_new_selected_value(
          isolate(input$scale), choices)
      )
    })

    # Simplify the click event to a string (or NULL)
    observeEvent(plotly::event_data("plotly_click"), {
      tryCatch({
        event <- plotly::event_data("plotly_click") %>% head(1)
        clicked_region(dplyr::pull(event, key))
      }, error = function(e) {
        clicked_region(NULL)
      })
    })

    # Reset the click event when the underlying map changes
    observeEvent({c(filter_result$geography(), filter_result$county())}, {
      clicked_region(NULL)
    })

    # The current clicked region (or NULL)
    clicked_region <- reactiveVal(NULL)

    # The underlying map
    map <- reactive({
      map_server_get_map(filter_result$geography(), filter_result$county())
    })

    # Summary data to apply to the map
    table_summary <- reactive({
      map_server_get_table_summary(
        filter_result$geography(),
        filter_result$county(),
        filter_result$filtered_table()
      )
    })

    # Calculate all values for each region
    region_values <- reactive({
      map_server_get_region_values(
        filter_result$table_name(),
        table_summary(),
        filter_result$unfiltered_summary()
      )
    })

    # Apply the values to the map
    map_with_values <- reactive({
      map_server_add_values_to_map(map(), region_values())
    })

    # The map title
    title_text <- reactive({
      map_server_get_title_text(
        filter_result$geography(),
        filter_result$county(),
        filter_result$table_name(),
        input$scale
      )
    })

    # The map "caption" (we will use the x-axis)
    caption_text <- reactive({
      map_server_get_caption_text(filter_result$filter_name(),
                                  filter_result$filter_display_name(),
                                  filter_result$filter_value())
    })

    # Plot with absolute counts
    absolute_plot <- reactive({
      map_server_make_plot(map_with_values(), "absolute_count",
                           title_text(), caption_text())
    })


    # Plot with per-capital values
    percapita_plot <- reactive({
      map_server_make_plot(map_with_values(), "percapita",
                           title_text(), caption_text())

    })

    # Plot with relative values
    relative_plot <- reactive({
      map_server_make_plot(map_with_values(), "relative",
                           title_text(), caption_text())
    })

    # The current plot
    current_plot <- function() {
      req(input$scale)
      if (input$scale == "absolute") {
        absolute_plot()
      } else if (input$scale == "relative") {
        relative_plot()
      } else {
        percapita_plot()
      }
    }

    suppressPlotlyMessage <- function(p) {
      suppressWarnings(plotly::plotly_build(p))
    }

    output$plot <- plotly::renderPlotly({
      current_plot()
    })


    # This is the return value -- the clicked region (or NULL)
    reactive({
      clicked_region()
    })

  })
}
