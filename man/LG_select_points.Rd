% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/LG_select_points.R
\name{LG_select_points}
\alias{LG_select_points}
\title{Select points for the local Gaussian inspections.}
\usage{
LG_select_points(.P1, .P2, .shape)
}
\arguments{
\item{.P1}{A bivariate vector, with values in the range (0,1), that
gives the first endpoint.  A single number will be accepted, in
which case it will be registered as a diagonal point.  The
values will be converted by \code{qnorm} to get points in the
plane.}

\item{.P2}{A bivariate vector, with values in the range (0,1), that
gives the second endpoint.  A single number will be accepted,
in which case it will be registered as a diagonal point.  The
values will be converted by \code{qnorm} to get points in the
plane.  Note that \code{.P2} can coincide with \code{.P1} in
which case the values given to \code{.shape} will be ignored.}

\item{.shape}{A bivariate vector of integers, that describes the
shape of the resulting "grid".  Note that it is required that
the first component of \code{.shape} must be a positive integer
and the second a non-negative integer.  This argument will,
when \code{.P1} and \code{.P2} are different, either specify a
rectangular/quadratic with the points \code{.P1} and \code{.P2}
as opposite corners, or it will specify points upon a line with
\code{.P1} and \code{.P2} as endpoints if the second component
is zero.  A single positive integer will be accepted, and
it will be interpreted as if the missing number should be zero.
This argument will be ignored if \code{.P1} and \code{.P2}
coincide completely.  If \code{.P1} and \code{.P2} coincide at
one of the components, and a bivariate vector with two positive
integers is given to \code{.shape}, then shape will be adjusted
to produce a line instead in order to avoid redundant
computations.  The values given in \code{.P1} and \code{.P2}
must be contained in the grid, so the value \code{1} can only
be used in \code{.shape} when \code{.P1} and \code{.P2} have a
common component.  If the components differ, the value will be
corrected to \code{2}, which is the smallest integer that gives
a reasonable result.}
}
\value{
An array containing points computed according to the rules
    specified under the description of the shape-argument.  The
    three arguments \code{.P1}, \code{.P2} and \code{.shape} will
    be stored as attributes, together with three additional
    attributes \code{Shape}, \code{Horizontal} and \code{Vertical},
    of which the last two will specify the points at the corner of
    the grid, whereas \code{Shape} will contain the value "point"
    if \code{.P1} and \code{.P2} are equal, the value "rectangle"
    if \code{.shape} contains two positive integers, or else it
    will contain the value "line.".  The result will in addition
    have the class-attribute "LG_points"
}
\description{
The purpose of this function is to create the
"points to inspect"-argument needed for the local Gaussian
investigation.
}
