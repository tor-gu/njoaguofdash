library(shiny)
library(njoaguof)

#' NJ OAG Use Of Force Dashboard app
#'
#' @return Shiny app
#' @export
#'
#' @examples
#' \dontrun{
#' njoaguofdashApp()
#' }
njoaguofdashApp <- function() {

  ui <- function(request) {
    navbarPage("NJOAGUOF Data Explorer", collapsible = FALSE, inverse = TRUE,
      tabPanel("Maps",
        fluidPage(
          shinyjs::useShinyjs(),
          #titlePanel("NJOAGUOF Dashboard"),
          sidebarLayout(
            sidebarPanel(filterUI("filter"),
                         mapInputUI("map"),
                         bookmarkButton()),
            mainPanel(mapOutputUI("map"),
                      tableUI("table"))
          ))),
        tabPanel("About",
                 #includeMarkdown("about.md"))
                 includeMarkdown(rmarkdown::render("about.Rmd",
                                 rmarkdown::md_document())))
                 #includeHTML("about.html"))
    )
  }

  server <- function(input, output, session) {
    current_filter <- filterServer("filter")
    clicked_region <- mapServer("map", current_filter)
    tableServer("table", current_filter, clicked_region)

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

  shinyApp(ui, server, enableBookmarking = "url")
}

