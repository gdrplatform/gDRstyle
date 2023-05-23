#' dummy_fun1
#'
#' @return
#' @export
#'
dummy_fun5 <- function(df) {
  checkmate::assert_data_frame(df)
  NROW(df)
}

#' dummy_fun2
#'
#' Dummy documented function
#'
#' @export
#'
#' @author Jane Doe
dummy_fun2 <- function() {
  plyr::rbind.fill(mtcars[c("mpg", "wt")], mtcars[c("wt", "cyl")])
}
