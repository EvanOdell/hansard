

#' Early day motion data
#'
#' Return data on the content, signatories, and sponsors of early day
#' motions (EDMS).
#'
#' Early Day Motion IDs reset for each parliamentary session, so not including
#' a query for `session` but including an `edm_id` will return
#' multiple early day motions with the same ID code from different
#' parliamentary sessions.
#'
#'
#' @param edm_id Accepts the ID number of an early day motion, and returns
#' data on that motion. If `NULL`, returns all available Early Day
#' Motions. Note that there, are as of 2017-06-15, 43,330 early day motions
#' on listed in the API, so requesting all early day motions without other
#' parameters is slow and very demanding on the API itself.
#' Defaults to `NULL`.
#'
#' @param session Accepts a parliamentary session, in `'yyyy/yy'` format.
#' Defaults to `NULL`.
#'
#' @param start_date Only includes early day motions tabled on or after
#' this date. Accepts character values in `'YYYY-MM-DD'` format, and
#' objects of class `Date`, `POSIXt`, `POSIXct`,
#' `POSIXlt` or anything else that can be coerced to a date with
#' `as.Date()`. Defaults to `'1900-01-01'`.
#'
#' @param end_date Only includes early day motions tabled on or before
#' this date. Accepts character values in `'YYYY-MM-DD'` format,
#' and objects of class `Date`, `POSIXt`, `POSIXct`,
#' `POSIXlt` or anything else that can be coerced to a date with
#' `as.Date()`. Defaults to the current system date.
#'
#' @param signatures The minimum number of signatures required for inclusion
#' in the tibble. Defaults to 1.
#' @inheritParams all_answered_questions
#' @return A tibble with details on the content, signatories and sponsors of
#' all or a specified early day motions.
#'
#' @seealso [mp_edms()]
#' @export
#' @examples
#' \dontrun{
#'
#' # Returns all EDMs with a given ID
#' x <- early_day_motions(edm_id = 1073)
#'
#' # Return a specific early day motion by ID
#' x <- early_day_motions(edm_id = 1073, session = "2017/19")
#' }
#'
early_day_motions <- function(edm_id = NULL, session = NULL,
                              start_date = "1900-01-01",
                              end_date = Sys.Date(), signatures = 1,
                              extra_args = NULL, tidy = TRUE,
                              tidy_style = "snake", verbose = TRUE) {
  if (!is.null(edm_id)) {
    edm_query <- paste0("&edmNumber=", edm_id)
  } else {
    edm_query <- ""
  }

  if (!is.null(session)) {
    session_query <- paste0("&session.=", session)
  } else {
    session_query <- ""
  }

  dates <- paste0(
    "&_properties=dateTabled&max-dateTabled=", as.Date(end_date),
    "&min-dateTabled=", as.Date(start_date)
  )

  sig_min <- paste0("&min-numberOfSignatures=", signatures)

  query <- paste0(
    url_util, "edms.json?", edm_query, dates, session_query, sig_min,
    extra_args
  )

  df <- edm_loop_query(query, verbose) # in utils-loop.R

  if (nrow(df) == 0) {
    message("The request did not return any data.
                Please check your parameters.")
  } else {
    if (tidy) {
      df <- edm_tidy(df, tidy_style)
    }

    df
  }
}



#' Early Day Motion Text
#'
#' A quick and dirty function for a specific use case, use with caution.
#'
#' @param id The ID of an individual Early Day Motion, or a vector of IDs,
#' as found in the `about` column of returns from [early_day_motions()]
#' @inheritParams early_day_motions
#'
#' @return A tibble of containing the EDM text and its ID.
#' @export
#'
#' @examples
#' \dontrun{
#' y <- edm_text(c("811291", "811292", "811293"))
#' }
edm_text <- function(id, tidy = TRUE,
                     tidy_style = "snake", verbose = TRUE) {
  if (length(id) <= 1) {
    xt <- jsonlite::fromJSON(paste0(url_util, "edms/", id[[i]], ".json"))

    df <- dplyr::as_tibble(xt$result$primaryTopic[c("_about", "motionText")])
  } else {
    req_list <- list()

    for (i in seq_along(id)) {
      if (verbose) {
        message("Retrieving page ", i, " of ", length(id))
      }

      xt <- jsonlite::fromJSON(paste0(url_util, "edms/", id[[i]], ".json"))
      req_list[[i]] <- xt$result$primaryTopic

      req_list[[i]] <- req_list[[i]][c("_about", "motionText")]
    }

    df <- dplyr::bind_rows(req_list)
  }

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


#' @rdname early_day_motions
#' @export
hansard_early_day_motions <- early_day_motions
