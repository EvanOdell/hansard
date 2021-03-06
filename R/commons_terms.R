

#' Parliamentary Thesaurus
#'
#' Imports the parliamentary thesaurus. The API is rate limited to 5500
#' requests at a time, so some use of parameters is required.
#'
#' @param search A string to search the parliamentary thesaurus for.
#'
#' @param class The class of definition to be returned Accepts one of
#' `'ID'`, `'ORG'`, `'SIT'`, `'NAME'`, `'LEG'`,
#' `'CTP'`, `'PBT'` and `'TPG'`.  Defaults to `NULL`.
#' @inheritParams all_answered_questions
#' @return A tibble with results from the parliamentary thesaurus.
#' @export
#' @examples
#' \dontrun{
#' x <- commons_terms(search = "estate")
#'
#' x <- commons_terms(search = "estate", class = "ORG")
#' }
#'
commons_terms <- function(search = NULL, class = NULL, extra_args = NULL,
                          tidy = TRUE, tidy_style = "snake",
                          verbose = TRUE) {
  warning("Search functions are not consistently working on the API")

  if (!is.null(search)) {
    search_query <- paste0("&_search=", utils::URLencode(search))
  } else {
    search_query <- NULL
  }

  if (!is.null(class)) {
    class_list <- list(
      "ID", "ORG", "SIT", "NAME", "LEG",
      "CTP", "PBT", "TPG"
    )

    if (!(class %in% class_list)) {
      stop("Please check your class parameter.
                 It must be one of \"ID\", \"ORG\", \"SIT\", \"NAME\",
                 \"LEG\", \"CTP\", \"PBT\" or\"TPG\"", call. = FALSE)
    } else {
      class_query <- paste0("&class=", class)
    }
  } else {
    class_query <- NULL
  }

  if (verbose) {
    message("Connecting to API")
  }

  query <- paste0(
    url_util, "terms.json?&_view=description", search_query, class_query,
    extra_args
  )

  df <- loop_query(query, verbose) # in utils-loop.R

  if (nrow(df) == 0) {
    message("The request did not return any data.
                Please check your parameters.")
  } else {
    if (tidy) {
      df <- hansard_tidy(df, tidy_style)
    }

    df
  }
}


#' @rdname commons_terms
#' @export
hansard_commons_terms <- commons_terms
