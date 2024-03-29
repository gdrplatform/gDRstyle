% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/linter_custom.R
\name{roxygen_tag_linter}
\alias{roxygen_tag_linter}
\title{roxygen_tag_linter}
\usage{
roxygen_tag_linter(tag = "@author")
}
\arguments{
\item{tag}{character (default \code{@author})}
}
\value{
linter class function
}
\description{
Check that function has documented specific tag in Roxygen
skeleton (default \code{@author}).
}
\examples{
linters_config <- lintr::linters_with_defaults(
  line_length_linter = lintr::line_length_linter(120),
  roxygen_tag_linter = roxygen_tag_linter()
)

}
\author{
Kamil Foltynski \href{mailto:kamil.foltynski@contractors.roche.com}{kamil.foltynski@contractors.roche.com}
}
\keyword{linter}
