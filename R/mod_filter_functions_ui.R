tbl_as_named_list <- function(tbl, value_col, name_col) {
  # Given a table and two columns, build a named list.
  # Copied from torgutil
  result <- tbl %>% dplyr::pull({{value_col}}) %>% as.list()
  names(result) <- tbl %>% dplyr::pull({{name_col}}) %>% as.list()
  result
}


filter_ui_make_filter_value_choice_list <-
  function(table, table_name, filter_name) {
    this_filter <- filters %>%
      dplyr::filter(table == table_name, filter == filter_name)
    if (is.na(this_filter$filter_column)) {
      character(0)
    } else {
      col <- table[[this_filter$filter_column]]
      if (is.factor(col)) {
        levels(col)
      } else if (is.logical(col)) {
        c("True" = TRUE, "False" = FALSE)
      } else {
        unique(col) %>% sort()
      }
    }
  }

filter_ui_make_filter_choice_list <- function(table_name) {
  single_value <- filters %>%
    dplyr::filter(table==table_name, is.na(join_table), filter != "all") %>%
    tbl_as_named_list(filter, display_name)
  multi_value <- filters %>%
    dplyr::filter(table==table_name, !is.na(join_table)) %>%
    tbl_as_named_list(filter, display_name)
  all <- filters %>%
    dplyr::filter(table==table_name, filter=="all") %>%
    dplyr::pull(display_name)
  choices <- list("all", single_value, multi_value)
  names(choices) <- c(all, "Single Valued", "Multi Valued")
  choices
}

filter_ui_filter_help <- function() {
  "<ul>
    <li>
      <em>Single value</em> fields have only one value per incident or
      subject -- for example, each subject has a single age.</li>
    <li>
      <em>Multi-value</em> fields may have multiple values per incident or
      subject -- for example, an officer may sustain multiple injuries in a
      single incident.
    </li>
  </ul>"
}

filter_ui_table_help <- function() {
  "<em>Incidents</em> are use of force reports filed by law enforcement
  officers. Incidents may involve multiple <em>subjects</em>."
}
