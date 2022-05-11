filterUI <- function(id) {
  ns <- NS(id)
  tagList(
    radioButtons(ns("geography"), "Geography",
                choices=c("State"="state", "County"="county"),
                selected="state", inline=TRUE),
    selectInput(ns("county"), "County", counties),
    radioButtons(ns("table"), "Incidents or Subjects",
                c("Incidents"="incident","Subjects"="subject")) %>%
      shinyhelper::helper(type="inline",
                          title="Incidents or Subjects",
                          content=filter_ui_table_help()),
    selectInput(ns("incident_filter"), "Filter",
                choices = filter_ui_make_filter_choice_list("incident")) %>%
      shinyhelper::helper(type = "inline",
                          title = "Filter",
                          content = filter_ui_filter_help()),
    selectInput(ns("subject_filter"), "Filter",
                choices = filter_ui_make_filter_choice_list("subject")) %>%
      shinyhelper::helper(type = "inline",
                          title = "Filter",
                          content = filter_ui_filter_help()),
    selectInput(ns("filter_value"), "Filter Value",
                choices=list("all"), selected="all"),
  )
}

filterServer <- function(id) {
  moduleServer(id, function(input, output, session) {
    observe({
      shinyjs::toggleElement(
        "county",
        condition = {
          input$geography == "county"
        },
        anim = TRUE,
        animType = "fade"
      )
    })

    observe({
      shinyjs::toggleElement("incident_filter",
                             condition = {
                               input$table == "incident"
                             })
      shinyjs::toggleElement("subject_filter",
                             condition = {
                               input$table == "subject"
                             })
      shinyjs::toggleElement("filter_value",
                             condition = {
                               (input$table == "incident" &&
                                  input$incident_filter != "all") ||
                                 (input$table == "subject" &&
                                    input$subject_filter != "all")

                             })
    })

    observe({
      if (filter_name() != "all") {
        freezeReactiveValue(input, "filter_value")
        updateSelectInput(session, "filter_value", choices =
                            filter_ui_make_filter_value_choice_list(
                              joined_table(), input$table, filter_name()))
      }
    })

    filter_name <- reactive({
      if (input$table == "incident") input$incident_filter
      else input$subject_filter
    })


    tables <- reactive({
      filter_server_get_tables(input$table, input$geography, input$county)
    })

    summary_table <- reactive({
      filter_server_get_summary_table(tables(), input$table, input$geography)
    })

    joined_table <- reactive({
      filter_server_get_joined_table(tables(), input$table, filter_name())
    })

    filtered_table <- reactive({
      req(input$filter_value)
      filter_server_get_filtered_table(joined_table(), input$table,
                                       filter_name(), input$filter_value)
    })

    # This is the module return value -- list of reactives.
    list(
      table_name = reactive(input$table),
      filter_name = filter_name,
      filter_value = reactive(input$filter_value),
      geography = reactive(input$geography),
      county = reactive(input$county),
      unfiltered_summary = summary_table,
      filtered_table = filtered_table
    )
  })
}
