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
    torgutil::tbl_as_named_list(filter, display_name)
  multi_value <- filters %>%
    dplyr::filter(table==table_name, !is.na(join_table)) %>%
    torgutil::tbl_as_named_list(filter, display_name)
  all <- filters %>%
    dplyr::filter(table==table_name, filter=="all") %>%
    dplyr::pull(display_name)
  choices <- list("all", single_value, multi_value)
  names(choices) <- c(all, "Single Valued", "Multi Valued")
  choices
}
