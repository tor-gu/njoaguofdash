library(shiny)
library(njoaguof)

#' NJ OAG Use Of Force Dashboard app
#'
#' @param md_dir Path to render the about.md file. If omitted or NULL, will
#' render to a temp dir
#'
#' @return Shiny app
#' @export
#'
#' @examples
#' \dontrun{
#' njoaguofdashApp()
#' }
njoaguofdashApp <- function(md_dir = NULL) {

  # Render once at startup
  about_md <- app_build_about_md(md_dir)

  ui <- function(request) {
    navbarPage("NJOAGUOF Data Explorer", collapsible = FALSE, inverse = TRUE,
      tabPanel("Maps",
        fluidPage(
          shinyjs::useShinyjs(),
          sidebarLayout(
            sidebarPanel(filterUI("filter"),
                         mapInputUI("map"),
                         bookmarkButton()),
            mainPanel(mapOutputUI("map"),
                      tableUI("table"))
          ))),
        tabPanel("About", includeMarkdown(about_md))
    )
  }

  server <- function(input, output, session) {
    shinyhelper::observe_helpers(help_dir = "helpfiles")
    app_exclude_bookmarks()

    current_filter <- filterServer("filter")
    clicked_region <- mapServer("map", current_filter)
    tableServer("table", current_filter, clicked_region)


  }

  shinyApp(ui, server, enableBookmarking = "url")
}

