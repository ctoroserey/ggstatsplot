#' @title Template for subtitles with statistical details for tests with a
#'   single parameter (e.g., t, chi-squared, etc.)
#' @name subtitle_template
#' @author Indrajeet Patil
#'
#' @param no.parameters An integer that specifies that the number of parameters
#'   for the statistical test. Can be `1` for tests based on *t*-statistic or
#'   chi-squared statistic, `2` for tests based on *F*-statistic.
#' @param stat.title A character describing the test being run, which will be
#'   added as a prefix in the subtitle. The default is `NULL`. An example of a
#'   `stat.title` argument will be something like `"Student's t-test: "`.
#' @param statistic.text A character that specifies the relevant test statistic.
#'   For example, for tests with *t*-statistic, `statistic.text = "t"`. If you
#'   want to use plotmath, you will have to quote the argument (e.g.,
#'   `quote(italic("t"))`).
#' @param statistic The numeric value of a statistic.
#' @param parameter The numeric value of a parameter being modeled (often
#'   degrees of freedom for the test).
#' @param parameter2 Relevant only if the statistic in question has two degrees
#'   of freedom (default: `NULL`).
#' @param p.value The two-sided p-value associated with the observed statistic.
#' @param effsize.text A character that specifies the relevant effect size.
#'   For example, for Cohen's *d* statistic, `effsize.text = "d"`. If you
#'   want to use plotmath, you will have to quote the argument (e.g.,
#'   `quote(italic("d"))`).
#' @param effsize.estimate,effsize.LL,effsize.UL The estimated value of the
#'   effect size, its lower bound, and its upper.
#' @param k Number of decimal places to display (default: `3`).
#' @param k.parameter Number of decimal places to display for the parameter
#'   (default: `0`).
#' @param n An integer specifying the sample size used for the test.
#' @inheritParams ggbetweenstats
#'
#' @examples
#' set.seed(123)
#' 
#' # subtitle for *t*-statistic with Cohen's *d* as effect size
#' ggstatsplot::subtitle_template(
#'   no.parameters = 1L,
#'   statistic.text = quote(italic("t")),
#'   statistic = 5.494,
#'   parameter = 29.234,
#'   p.value = 0.00001,
#'   effsize.text = quote(italic("d")),
#'   effsize.estimate = -1.980,
#'   effsize.LL = -2.873,
#'   effsize.UL = -1.088,
#'   n = 32L,
#'   conf.level = 0.95,
#'   k = 3L,
#'   k.parameter = 3L
#' )
#' @export

# function body
subtitle_template <- function(no.parameters,
                              stat.title = NULL,
                              statistic.text,
                              statistic,
                              parameter,
                              parameter2 = NULL,
                              p.value,
                              effsize.text,
                              effsize.estimate,
                              effsize.LL,
                              effsize.UL,
                              n,
                              conf.level = 0.95,
                              k = 3L,
                              k.parameter = 0L) {
  # ------------------ statistic with 1 degree of freedom --------------------

  if (no.parameters == 1L) {

    # preparing subtitle
    subtitle <-
      base::substitute(
        expr =
          paste(
            stat.title,
            statistic.text,
            "(",
            parameter,
            ") = ",
            statistic,
            ", ",
            italic("p"),
            " = ",
            p.value,
            ", ",
            effsize.text,
            " = ",
            effsize.estimate,
            ", CI"[conf.level],
            " [",
            effsize.LL,
            ", ",
            effsize.UL,
            "]",
            ", ",
            italic("n"),
            " = ",
            n
          ),
        env = base::list(
          stat.title = stat.title,
          statistic.text = statistic.text,
          statistic = specify_decimal_p(x = statistic, k = k),
          parameter = specify_decimal_p(x = parameter, k = k.parameter),
          p.value = specify_decimal_p(
            x = p.value,
            k = k,
            p.value = TRUE
          ),
          effsize.text = effsize.text,
          effsize.estimate = specify_decimal_p(x = effsize.estimate, k = k),
          conf.level = paste(conf.level * 100, "%", sep = ""),
          effsize.LL = specify_decimal_p(x = effsize.LL, k = k),
          effsize.UL = specify_decimal_p(x = effsize.UL, k = k),
          n = n
        )
      )

    # ------------------ statistic with 2 degrees of freedom -----------------
  } else if (no.parameters == 2L) {

    # check if parameter 2 is specified
    if (purrr::is_null(parameter2)) {
      base::stop(base::message(cat(
        crayon::red("Error: "),
        crayon::blue(
          "For tests with statistic that have two parameters, \n",
          "the argument `parameter2` must be specified.\n"
        ),
        sep = ""
      )),
      call. = FALSE
      )
    }

    # preparing subtitle
    subtitle <-
      base::substitute(
        expr =
          paste(
            stat.title,
            statistic.text,
            "(",
            parameter,
            ",",
            parameter2,
            ") = ",
            statistic,
            ", ",
            italic("p"),
            " = ",
            p.value,
            ", ",
            effsize.text,
            " = ",
            effsize.estimate,
            ", CI"[conf.level],
            " [",
            effsize.LL,
            ", ",
            effsize.UL,
            "]",
            ", ",
            italic("n"),
            " = ",
            n
          ),
        env = base::list(
          stat.title = stat.title,
          statistic.text = statistic.text,
          statistic = specify_decimal_p(x = statistic, k = k),
          parameter = specify_decimal_p(x = parameter, k = 0L),
          parameter2 = specify_decimal_p(x = parameter2, k = k.parameter),
          p.value = specify_decimal_p(
            x = p.value,
            k = k,
            p.value = TRUE
          ),
          effsize.text = effsize.text,
          effsize.estimate = specify_decimal_p(x = effsize.estimate, k = k),
          conf.level = paste(conf.level * 100, "%", sep = ""),
          effsize.LL = specify_decimal_p(x = effsize.LL, k = k),
          effsize.UL = specify_decimal_p(x = effsize.UL, k = k),
          n = n
        )
      )
  }

  # return the formatted subtitle
  return(subtitle)
}
