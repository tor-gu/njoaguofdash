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
    shinyhelper::observe_helpers(help_dir = "helpfiles")
    app_exclude_bookmarks()

    current_filter <- filterServer("filter")
    clicked_region <- mapServer("map", current_filter)
    tableServer("table", current_filter, clicked_region)


  }

  shinyApp(ui, server, enableBookmarking = "url")
}

