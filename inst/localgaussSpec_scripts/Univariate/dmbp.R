#' An investigation of the 'dmbp'-data, length 1974.  This example is
#' used in figures 11-14 of
#' "Nonlinear spectral analysis via the local Gaussian correlation".

###############
##  NOTE: This script is a part of the package 'localgaussSpec'.  Its
##  purpose is to provide the code needed for the reproduction of one
##  or more of the examples used in the two papers "Nonlinear spectral
##  analysis via the local Gaussian correlation" and "Nonlinear
##  cross-spectrum analysis via the local Gaussian correlation".  The
##  present setup contains a wider range of input parameters than
##  those used in the figures of the previous mentioned papers, which
##  enables the interested reader to see how the result varies based
##  on these input parameters.
#####
##  WARNING: The user that want to adjust this script in order to
##  investigate other time series (or a wider range of input
##  parameters for the present example) should keep in mind that the
##  selected input parameters must take into account the length of the
##  investigated example. In particular, see the before mentioned
##  papers for a discussion of how small-sample variation might occur
##  even for long samples if the coordinates of the point of interest
##  correspond to low or high quantiles.
###############

##############################

###############
## Check that the required package(s) are available.
.required_packages <- c("localgaussSpec")
.successful <- vapply(
    X = .required_packages,
    FUN = requireNamespace,
    quietly = TRUE,
    FUN.VALUE = logical(1))
if (! all(.successful)) {
    stop(sprintf(
        fmt = "\nThe following package%s must be installed for this script to work: %s.",
        ifelse(test = sum(!.successful) > 1,
               yes  = "s",
               no   = ""),
        paste(paste("\n\t",
                    names(.successful[!.successful]),
                    sep = ""),
              collapse = ", ")))
}
rm(.required_packages, .successful)
###############

##############################

###############
##  Add comment(s) related to the need for a parallel-backend suitable
##  for the operative system.
###############

###############
##  Specify the directory in which the resulting file-hierarchy will
##  be stored. The default directory "LG_DATA" will be created if it
##  does not exist, whereas other storage-alternatives must be created
##  manually before this script is called.

main_dir <- "~/LG_DATA"
###############

##############################

###############
##  Extract the desired time series needed for the present
##  investigation from 'dmbp', and save it into the file-hierarchy.

.TS <- localgaussSpec::dmbp[, "V1"]
##  (The 'dmbp' in the 'localgaussSpec'-package is a copy of the one
##  from the 'rugarch'-package.  It has been copied in order for this
##  script to run without the need for installating 'rugarch' first.)

set.seed(136)
tmp_TS_LG_object <- TS_LG_object(
    TS_data = .TS,
    main_dir = main_dir)
rm(.TS)
###############

##############################

###############
##  Compute the local Gaussian spectral densities.  This requires
##  first that the local Gaussian correlations of interest must be
##  computed, which implies that the points of interest must be
##  selected together with information about the bandwidth and the
##  number of lags. WARNING: The type of approximation must also be
##  specified, i.e. the argument 'LG_type', where the options are
##  "par_five" and "par_one".  The "five" and "one" refers to the
##  number of free parameters used in the approximating bivariate
##  local Gaussian density.  The results should be equally good for
##  Gaussian time series, but the "par_one" option will in general
##  produce dubious/useless results.  Only use "par_one" if it is of
##  interest to compare the result with "par_five", otherwise avoid it
##  as it most likely will be a waste of computational resources.

.LG_type <- c("par_five", "par_one")
.LG_points <- LG_select_points(
    .P1 = c(0.1, 0.1),
    .P2 = c(0.9, 0.9),
    .shape = c(3, 3))
lag_max <- 20
##  Reminder: length 1974, b = 1.75 * (1974)^(-1/6) = 0.4940985.  Thus
##  use bandwidths 0.5, 0.75, 1 and see how it fares for the different
##  alternatives.  
.b <- c(0.5, 0.75, 1)

##  Do the main computation on the sample at hand.
LG_AS <- LG_approx_scribe(
    main_dir = main_dir,
    data_dir = tmp_TS_LG_object$TS_info$save_dir,
    TS = tmp_TS_LG_object$TS_info$TS,
    lag_max = lag_max,
    LG_points = .LG_points,
    .bws_fixed = .b,
    .bws_fixed_only = TRUE,
    LG_type = .LG_type)
rm(tmp_TS_LG_object, lag_max, .LG_points, .b, .LG_type)

##  Specify the details needed for the construction of the bootstrapped
##  pointwise confidence intervals, and do the computations.
nb <- 100
block_length <- 100

set.seed(1421236)
LG_BS <- LG_boot_approx_scribe(
    main_dir        = main_dir,
    data_dir         = LG_AS$data_dir,
    nb              = nb,
    boot_type       = NULL,
    block_length    = block_length,
    boot_seed       = NULL,
    lag_max         = NULL,
    LG_points       = NULL,
    .bws_mixture    = NULL,
    bw_points       = NULL,
    .bws_fixed      = NULL,
    .bws_fixed_only = NULL,
    content_details = NULL,
    LG_type         = NULL,
    threshold       = 100)
rm(nb, block_length, LG_AS)

##  The 'NULL'-arguments ensures that the same values are used as in
##  the computation based on the original sample. (These 'NULL'-values
##  are the default values for these arguments, and it is thus not
##  necessary to specify them.)  It is possible to restrict these
##  arguments to a subset (of the original one) if that is desirable.
##  In particular: It might not be too costly to compute the local
##  Gaussian spectral density for a wide range of input parameters
##  when only the original sample is considered, and it could thus be
##  of interest to first investigate that result before deciding upon
##  which subsets of the selected parameter-space that it could be
##  worthwhile to look closer upon.
###############

##############################

##  Extract the directory information needed for 'LG_shiny'.
data_dir_for_LG_shiny <- LG_BS$data_dir
rm(LG_BS)

##  And start the shiny application for an interactive inspection of
##  the result.

shiny::runApp(LG_shiny(
    main_dir = main_dir,
    data_dir = data_dir_for_LG_shiny))

################################################################################
###### NOTE:
###  The interaction with the file-hierarchy contains tests that
###  prevents previously computed local Gaussian correlations to be
###  computed all over again if this script is sourced a second time,
###  but the initial computation of '.TS_sample' will be performed
###  every time the script is sourced.  It can thus be of interest to
###  note that the 'dump'-function might be used to capture the
###  'data_dir'-argument, such that the call to the shiny-application
###  can be done without the need for the script to be sourced
###  directly.  The result for the present script (based on the
###  original input parameters) are given below (in the case where
###  this script is used before the script 'dmbp_200_lags.R').

## dump("data_dir_for_LG_shiny", stdout())
## data_dir_for_LG_shiny <-
##     c(ts.dir = "234f779b58b1cf8aee6ebcdb5d6853e0",
##       approx.dir = "Approx__1",
##       boot.approx.dir = "Boot_Approx__1")

#####
## Note that 'data_dir' only contains the specification of the
## in-hierarchy part of the required path, and this path is stored as
## a vector.  The reason for this is that it should be possible to
## move the storage directory 'main_dir' to another location on your
## computer, or even move it to a computer using another OS than the
## one used for the original computation.
################################################################################
