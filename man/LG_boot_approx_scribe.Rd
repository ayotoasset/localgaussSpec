% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/LG_boot_approx_scribe.R
\name{LG_boot_approx_scribe}
\alias{LG_boot_approx_scribe}
\title{Local Gaussian Approximations for bootstrap replicates,
scribe-function.}
\usage{
LG_boot_approx_scribe(main_dir, data_dir, lag_max = NULL,
  LG_points = NULL, content_details = NULL, LG_type = NULL,
  .bws_mixture = NULL, bw_points = NULL, .bws_fixed = NULL,
  .bws_fixed_only = NULL, nb = NULL, boot_type = NULL,
  block_length = NULL, boot_seed = NULL, threshold = 500)
}
\arguments{
\item{main_dir}{The path to the main directory, that contains the
file-hierarchy created when using the local Gassian approach
for the investigation of time series.}

\item{data_dir}{A specification of the directory to be used when
loading and saving data.}

\item{lag_max}{The number of lags to include in the analysis.}

\item{LG_points}{An array that specifies the point at which it is
desired to compute the local Gaussian estimates.  The default
value \code{NULL} will imply that the values used in the
computations upon the original data are recycled.  Values can
alternatively be computed by the help of the function
\code{LG_select_points}, but these must then be a subset of the
original values.}

\item{content_details}{A value from \code{c("rho_only",
"rho_log.fun", "rho_all")}, which decides the amount of details
stored from the local Gaussian approximations.}

\item{LG_type}{One of \code{c("par_five", "par_one")}, i.e. should the
Local Gaussian Autocorrelations be based on the approach using
five parameters or the simplified approach using only one
parameter.  The default choice is \code{"par_five"}.}

\item{.bws_mixture}{An argument that specifies how the global
bandwidths and those obtained by the nearest-neighbour strategy
should be combined.  The three available options are
\code{c("mixture", "local", "global")}, which have the
following effects.  The alternatives \code{local} and
\code{global} will respectively only select the nearest
neighbour or global.  These alternatives seems however to not
work well when used on some parts of the lagged pairs of
interest, i.e. the nearest neighbour values might be to "small"
in the center of the distribution, whereas the global
bandwidths seems to fail in the periphery of the distribution.
The alternative \code{mixture} attempt to resolve this by (for
each grid point) selecting the largest of the two alternative
bandwidths.  Note that the value of \code{.bws_mixture} decides
how much information that is computed, i.e. the alternative
\code{local} will turn off the computation of global
bandwidths.  However, the computations of the nearest neighbour
bandwidths will also be computed when the alternative
\code{global} is used, since it does not take long to compute
and it is that function that creates the array we need as a
mould for the result.  If the user does not make a selection,
then all three alternatives will be computed.}

\item{bw_points}{A vector, default \code{c(25, 35)}, that specifies
the percentage of the observations that we want inside the
"bandwidth-square".  If \code{.bws_mixture} is selected to be
\code{global}, then this argument will be ignored. and no
nearest neighbours will be computed.}

\item{.bws_fixed}{A vector of non-negative real values, that can be
used to specify fixed values for the bandwidths (which might be
of interest to do in a preliminary analysis).  The default
value \code{NULL} will prevent the computation of Local
Gaussian Estimates based on fixed bandwidths.}

\item{.bws_fixed_only}{A logic value, default \code{FALSE}, that
can be used to drop the rather time-consuming data-driven
estimation of bandwidths in favour of the simplified approach
where fixed bandwidths are used instead.  Note that
\code{.bws_fixed} must be specified when \code{.bws_fixed_only}
are set to \code{TRUE}.}

\item{nb}{An integer that specifies how many bootstrap-replicates
we want to use in our analysis.  Default value 5 (at least in
the development phase).}

\item{boot_type}{This one can be used to select what kind of
bootstrap-algorithm to be used.  Default value \code{"block"},
but it has not been implemented any other algorithms
yet... (Reminder: It would be be nice to include the
'network-duality' approach in this context -- but then I fear I
might need to implement that routine from scratch.)}

\item{block_length}{The length of the blocks to be used when
\code{boot_type="block"} is used.  Default value 20 in the
development phase, but I suppose in general it should be some
formula based on the time series under investigation.}

\item{boot_seed}{Use this to enable reproducible results.  The
default value \code{NULL} will trigger a random seed to be
selected for this value (that then will be recorded in case a
reproduction of the result is desired later on).}

\item{threshold}{An integer, default value 500 (measured in MB),
that tells the program when a computation should be divided
into smaller chunks.  This reduces the chance of memory-related
problems, but as the present incarnation of \code{LG_splitter}
are rather stupid such problems might still occur for long
time-series where a huge number of lags are included.}
}
\value{
This function will return a two component list to the
    work-flow.  The first component is the logic value
    \code{done_before} that reveals whether or not the result
    already existed (in the specified file-structure), whereas the
    second component \code{data_dir} gives the location of the
    saved data.
}
\description{
This function takes care of the bookkeeping when we want to
investigate a time series by means of local Gaussian Approximations
used on bootstrapped replicates of the time series.
}
\details{
This function records its arguments and compares them to a
    previously stored information-object for the time series under
    investigation, in order to avoid redoing previously performed
    computations.  For new computations, relevant data will be
    extracted from \code{data_dir}, which then will be analysed in
    order to see if memory issues requires that the computation
    should be performed in smaller chunks.  The function then calls
    \code{LG_boot_approx} that does the computations, and the
    result is then added to the file-structure.  Finally the
    information-object will be updated and a two component value is
    returned to the work-flow.

Note that no default values are given for any of the
    arguments, and that solution is made in order to dissuade users
    from calling this (often quite time consuming) function
    directly from the work-space.  The intention is that the
    bootstrap-wrapper should call this function, and then with
    arguments inherited (restrictions are allowed) from those used
    in a previous analysis of a time series.  This is done since
    the main motivation for working with bootstrapped replicates of
    our original time series is to obtain bootstrap-based
    confidence intervals for the Local Gaussian Spectral Densities.
}
