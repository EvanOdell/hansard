
#' Peers' registered interests
#'
#' Registered financial interests of members of the House of Lords.
#' If `peer_id=NULL` the actual details of registered interests
#' are stored in a nested data frame.
#'
#' @param peer_id The ID of a member of the House of lords. If `NULL`,
#' returns a tibble with all listed financial interests for all members.
#' Defaults to `NULL`.
#' @inheritParams all_answered_questions
#' @return A tibble with details on the interests of peers in
#' the House of Lords.
#' @export
#' @examples
#' \dontrun{
#' x <- lords_interests(4170)
#'
#' y <- lords_interests()
#' }
lords_interests <- function(peer_id = NULL, extra_args = NULL, tidy = TRUE,
                            tidy_style = "snake", verbose = TRUE) {
  if (is.null(peer_id)) {
    json_query <- ".json?"
  } else {
    json_query <- paste0(".json?member=", peer_id)
  }

  query <- paste0(url_util, "lordsregisteredinterests", json_query, extra_args)

  df <- loop_query(query, verbose) # in utils-loop.R

  if (nrow(df) == 0) {
    message("The request did not return any data.
                Please check your parameters.")
  } else {
    if (tidy) {
      if (is.null(peer_id)) {
        df <- lords_interests_tidy2(df, tidy_style) ## in utils-lords.R
      } else {
        df <- lords_interests_tidy(df, tidy_style) ## in utils-lords.R
      }
    }
    df
  }
}


#' @export
#' @rdname lords_interests
hansard_lords_interests <- lords_interests
