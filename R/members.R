

#' Members of both houses
#'
#' Imports basic details on current and former Members of Parliament including
#' the Lords and the Commons. For more details on a given member see
#' \link[mnis]{mnis_full_biog} from the \link[mnis]{mnis} package.
#'
#'
#' @param ID The ID of a member of the House of Commons or the House of Lords
#' to return data on. If `NULL`, returns a tibble of all members of both
#' houses. Defaults to `NULL`.
#' @inheritParams all_answered_questions
#' @return A tibble with data on members of the House of Commons
#' (`commons_members()`), the House of Lords, (`lords_members()`),
#' or both (`members()`).
#'
#' @export
#' @section Member details functions:
#' \describe{
#' \item{`members`}{Basic details on a given member from either house}
#' \item{`commons_members`}{MPs in the House of Commons}
#' \item{`lords_members`}{Peers in the House of Lords}
#' }
#' @seealso [members_search()]
#' @examples
#' \dontrun{
#' a <- members()
#'
#' x <- members(172)
#'
#' y <- commons_members()
#'
#' z <- lords_members()
#' }
#'
members <- function(ID = NULL, extra_args = NULL, tidy = TRUE,
                    tidy_style = "snake", verbose = TRUE) {
  if (is.null(ID)) {
    id_query <- ".json?"
  } else {
    id_query <- paste0("/", ID, ".json?")
  }

  query <- paste0(url_util, "members", id_query, extra_args)

  if (is.null(ID)) {
    df <- loop_query(query, verbose) # in utils-loop.R
  } else {
    veb(verbose)

    q_members <- jsonlite::fromJSON(query, flatten = TRUE)

    df <- tibble::as_tibble(as.data.frame(q_members$result$primaryTopic))

    names(df)[names(df) == "X_about"] <- "about"
    names(df)[names(df) == "X_value"] <- "additionalName"
    names(df)[names(df) == "X_value.1"] <- "familyName"
    names(df)[names(df) == "X_value.2"] <- "fullName"
    names(df)[names(df) == "X_value.3"] <- "gender"
    names(df)[names(df) == "X_value.4"] <- "givenName"
    names(df)[names(df) == "X_value.5"] <- "label"
    names(df)[names(df) == "X_value.6"] <- "party"
  }

  if (nrow(df) == 0) {
    message("The request did not return any data.
                Please check your parameters.")
  } else {
    if (tidy) {
      df <- hansard_tidy(df, tidy_style)

      df$about <- gsub(
        "http://data.parliament.uk/members/", "",
        df$about
      )
    }

    df <- tibble::as_tibble(df)

    df
  }
}

#' @export
#' @rdname members
hansard_members <- members


#' @export
#' @rdname members
commons_members <- function(extra_args = NULL, tidy = TRUE,
                            tidy_style = "snake", verbose = TRUE) {
  query <- paste0(
    url_util, "commonsmembers.json?",
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


#' @export
#' @rdname members
hansard_commons_members <- commons_members


#' @export
#' @rdname members
lords_members <- function(extra_args = NULL, tidy = TRUE,
                          tidy_style = "snake", verbose = TRUE) {
  query <- paste0(url_util, "lordsmembers.json?")

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

#' @export
#' @rdname members
hansard_lords_members <- lords_members
