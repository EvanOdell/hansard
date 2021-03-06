
#' Commons oral question times
#'
#' Imports data on House of Commons oral question times. Query with parameters
#' for the parliamentary session or the question ID. If `tidy=TRUE`,
#' datetime variables are converted to `POSIXct` class.
#'
#'
#' @param session Accepts a session in format `yyyy/yy`
#' (e.g. `"2016/17"`) and returns a tibble of all oral question times from
#' that session. Defaults to `NULL`.
#'
#' @param question_id Accepts a question time ID, and returns a tibble of
#' that question time.
#' @inheritParams all_answered_questions
#' @return A tibble with information on oral question times in the House of
#' Commons.
#' @seealso [all_answered_questions()]
#' @seealso [commons_answered_questions()]
#' @seealso [commons_oral_questions()]
#' @seealso [commons_written_questions()]
#' @seealso [lords_written_questions()]
#' @seealso [mp_questions()]
#' @export
#' @examples
#' \dontrun{
#' x <- commons_oral_question_times(session = "2016/17", question_id = "685697")
#' }
#'
commons_oral_question_times <- function(session = NULL, question_id = NULL,
                                        extra_args = NULL, tidy = TRUE,
                                        tidy_style = "snake",
                                        verbose = TRUE) {
  if (!is.null(session)) {
    session_query <- utils::URLencode(paste0("session=", session))
  } else {
    session_query <- ""
  }

  if (!is.null(question_id)) {
    question_query <- paste0("/", question_id)
  } else {
    question_query <- ""
  }

  query <- paste0(
    url_util, "commonsoralquestiontimes", question_query,
    ".json?", session_query, extra_args
  )

  if (is.null(question_id)) {
    df <- loop_query(query, verbose) # in utils-loop.R
  } else {
    veb(verbose)

    mydata <- jsonlite::fromJSON(query, flatten = TRUE)

    df <- tibble::tibble(
      `_about` = mydata$result$primaryTopic$`_about`,
      AnswerBody = list(mydata$result$primaryTopic$AnswerBody),
      session = mydata$result$primaryTopic$session,
      title = mydata$result$primaryTopic$title,
      AnswerDateTime._value =
        mydata$result$primaryTopic$AnswerDateTime$`_value`,
      AnswerDateTime._datatype =
        mydata$result$primaryTopic$AnswerDateTime$`_datatype`,
      Location._about = mydata$result$primaryTopic$Location$`_about`,
      Location.prefLabel._value =
        mydata$result$primaryTopic$Location$prefLabel$`_value`,
      QuestionType._value =
        mydata$result$primaryTopic$QuestionType$`_value`,
      date._value = mydata$result$primaryTopic$date$`_value`,
      date._datatype = mydata$result$primaryTopic$date$`_datatype`,
      modified._value = mydata$result$primaryTopic$modified$`_value`,
      modified._datatype = mydata$result$primaryTopic$modified$`_datatype`,
      sessionNumber._value =
        mydata$result$primaryTopic$sessionNumber$`_value`
    )
  }

  if (nrow(df) == 0) {
    message("The request did not return any data.
                Please check your parameters.")
  } else {
    if (tidy) {
      df <- coqt_tidy(df, tidy_style) ## in utils-commons.R
    }

    df
  }
}

#' @rdname commons_oral_question_times
#' @export

hansard_commons_oral_question_times <- commons_oral_question_times
