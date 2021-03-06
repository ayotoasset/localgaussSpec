% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/TS_acr.R
\name{TS_acr}
\alias{TS_acr}
\title{Autocovariances and autocorrelations the old-fashioned way.}
\usage{
TS_acr(.TS_info, lag_max = quote(ceiling(3 * sqrt(length(TS)))))
}
\arguments{
\item{.TS_info}{A list containing the three components \code{TS},
\code{main_dir} and \code{save_dir}.}

\item{lag_max}{The number of lags to include in the analysis.  The
default value \code{ceiling(3*sqrt(length(TS)))} will probably
in most cases include more lags than actually required.  It
might thus be worthwhile to run some test and see if a smaller
value can be used instead.}
}
\value{
A file will be created containing an array with the
    (ordinary) autocorrelations of \code{TS}.  If \code{save_dir}
    is \code{NULL}, then the array will be returned to the workflow
    directly, otherwise it will be saved to disk.
}
\description{
This function use the "old-fashioned" way to compute the
autocorrelations for a given time series, i.e. the
summation-approach.  This is much slower than the fast Fourier
transform approach used by \code{acf}, but it seems more natural to
use this when computing the ordinary spectral density in the old
fashioned way (using window-functions instead of periodograms).
}
\keyword{internal}
