% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/LG_shiny_interface_0_create_log.R
\name{LG_shiny_interface_0_create_log}
\alias{LG_shiny_interface_0_create_log}
\title{Create \code{TS_logging}-object for the dynamic
\code{LG_shiny}-interface.}
\usage{
LG_shiny_interface_0_create_log(.env, .env2)
}
\arguments{
\item{.env}{The environment where the original arguments given to
\code{LG_shiny} lives, i.e. arguments like \code{main_dir} and
\code{data_dir}.  The logging-object will be added to this
environment.}

\item{.env2}{The environment containing the two lists \code{input}
and \code{output}.}
}
\value{
This function adds the \code{TS_logging}-object into the
    environment \code{.env}.  This object will log input-values in
    order to avoid problems when switching between different
    branches, i.e. it prevents residual input-values to trigger
    subsetting problems.  Moreover, the last selected input-values
    for an old branch will be stored when there is a switch to a
    new branch, and these will then be loaded the next time the old
    branch is visited.  The function does also add the initial
    \code{NA}-values to the reactive \code{input}-object in the
    \code{shiny}-application started by \code{LG_shiny}, and this
    is done in order for some of the logical tests to become
    simpler during the initiation phase.
}
\description{
This function initiates the \code{TS_logging}-object needed in
order for the dynamic structure of the \code{LG_shiny}-application
to work without any glitches.  Moreover, it does also adds a bunch
of values to the reactive \code{input}-object in the
\code{shiny}-application started by \code{LG_shiny}.
}
\keyword{internal}
