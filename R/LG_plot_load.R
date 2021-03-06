#' Load files to be used during the interactive inspection.
#'
#' This helper function that takes care of some details related to the
#' loading of files, i.e. with regard to the interactive inspection
#' required by \code{shiny}.
#'
#' @param .look_up A list created by \code{LG_lookup} (in the function
#'     \code{LG_plot_helper}), where the key details have been
#'     extracted (or constructed) from a (non-reactive copy) of the
#'     values defined by the \code{shiny}-interface.
#'
#' @param .env The environment in which the loaded stuff should be
#'     stored.
#'
#' @return The required data will be loaded from files into
#'     \code{.env}, but only if it hasn't been done before.  The
#'     resulting array will then be assigned to the environment of the
#'     calling function under the name given by \code{.result}.
#'
#' @keywords internal

LG_plot_load <- function(.look_up,
                         .env) {
    ##  Some shortcuts to make the code slightly easier to read.
    cache <- .look_up$cache
    .env_name <- cache$.env_name
    .global_name <- .look_up$.global_name
    .local_name <- .look_up$.local_name
    ###-------------------------------------------------------------------
    ##  Check if existing data has been loaded already.  If necessary
    ##  load the data from files.  Reminder: The strategy is based on
    ##  the existence of an environment inside of '.env'.  If that
    ##  environment does not exist, then it is necessary to create it.
    if (! exists(x = .env_name, envir = .env)) {
        ##  Create the environment
        .env[[.env_name]] <- new.env()
        ##  Load global data into the new environment, with an
        ##  adjustment for the cases where bootstrap is present.
        LG_load( 
            .file = .look_up$.global_file,
            .env = .env[[.env_name]],
            .name = .global_name)
        if (.look_up$is_bootstrap) {
            ##  Add details from the original time-series into the
            ##  details obtained from the bootstrapped values.
            LG_load( 
                .file = .look_up$.orig_files$.global_file,
                .name = ".temp")
            ##  Restrict the 'TS'-dimension of the new data in order
            ##  for the two arrays to be merged
            .ts_part <-  dimnames(.env[[.env_name]][[.global_name]])["TS"]
            .temp <- 
                leanRcoding::restrict_array(
                                 .arr = .temp,
                                 .restrict = .ts_part)
            ##  Add the new data to the bootstrap-data, which implies
            ##  that the 'content'-dimension now also will have a "orig"-component.
            .env[[.env_name]][[.global_name]] <- my_abind(
                .temp,
                .env[[.env_name]][[.global_name]])
            ##  Remove ".temp" from our desired environment.
            kill(.temp, .ts_part)
        }
        ##  Load local data into the new environment, with an
        ##  adjustment for the cases where bootstrap is present.
        LG_load(.file = .look_up$approx_file,
                .env = .env[[.env_name]],
                .name = .local_name)
        if (.look_up$is_bootstrap) {
            ##  Add details from the original time-series into the
            ##  details obtained from the bootstrapped values.
            LG_load( 
                .file = .look_up$.orig_files$approx_file,
                .name = ".temp")
            ##  Restrict the dimensions of the new data in order for
            ##  the two arrays to be merged.  Reminder: This is
            ##  necessary since the function that computes the
            ##  bootstrap-part is allowed to restrict the attention to
            ##  a subset of those used in the computation of original.
            for (.part in names(.temp)) {
                .the_dimnames <- dimnames(.env[[.env_name]][[.local_name]][[.part]])
                ##  Remove "content"-part
                .the_dimnames <- .the_dimnames[! names(.the_dimnames) %in% "content"]
                ##  Perform the update for this part.
                .temp[[.part]] <-
                    leanRcoding::restrict_array(
                                     .arr = .temp[[.part]],
                                     .restrict = .the_dimnames)
                ##  Add the new data to the bootstrap-data, which implies
                ##  that the 'content'-dimension now also will have a "orig"-component.
                .env[[.env_name]][[.local_name]][[.part]] <- my_abind(
                    .temp[[.part]],
                    .env[[.env_name]][[.local_name]][[.part]])
            }
            kill(.temp, .the_dimnames, .part)
        }
        ###-----------------------------------------------
        ##  Adjust global and local values to list-array format.
        .env[[.env_name]][[.global_name]] <- array_to_list_array(
            .arr = .env[[.env_name]][[.global_name]],
            .array_nodes = c("TS"))
        .env[[.env_name]][[.local_name]] <- array_to_list_array(
            .arr = .env[[.env_name]][[.local_name]],
            .array_nodes = c("bw_points"))
    }
    ##  To make the code later on more compact, create a pointer to
    ##  the environment that we want to update.
    ..env <- .env[[.env_name]]
    kill(.env, .env_name)
    ###-------------------------------------------------------------------
    if (.look_up$TCS_type == "S") {
        ##  The extractions and computations required for the
        ##  inspection of the local Gaussian spectra are taken care of
        ##  here, and the results are stored in '..env'.
        LG_shiny_spectra(.look_up = .look_up, ..env = ..env)
    }
    if (.look_up$TCS_type == "C") {
        ##  The extractions and computations required for the
        ##  inspection of the local Gaussian correlations are taken
        ##  care of here, and the results are stored in '..env'.
        LG_shiny_correlation(.look_up = .look_up, ..env = ..env)
    }
    ##  Create a list in '..env' with the required plot-arguments, and
    ##  return the name needed to extract it.
    .plot_list  <- LG_create_plot_df(.look_up = .look_up,
                                     ..env = ..env)
    ###-------------------------------------------------------------------
    ##  Create and return the plot
    ..env$.lag_plot <-     with(
        data = ..env[[.plot_list]],
        expr = {
            LG_plot(
                .data_list = .data_list,
                .lag = .lag,
                .percentile = .percentile,
                .xlim = .xlim,
                .ylim = .ylim,
                .aes_list = .aes_list) + 
                ##  Add title and 'trustworthiness'.
                ggplot2::ggtitle(label = .plot_label) +
                ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5)) +
                if (! is.null(.annotate_label))
                    annotate(geom = "text",
                             x = -Inf,
                             y = -Inf,
                             size = 4,
                             label = .annotate_label,
                             col = "darkgreen",
                             vjust = -.5,
                             hjust = -0.1)
        })
    ##  Add names to the layers.
    names(..env$.lag_plot$layers) <- c(
        head(x = names(..env$.lag_plot$layers), n = -1),
        ".annotate_convergence")
    ##  Add the details as an attribute.
    attributes(..env$.lag_plot)$details <- .look_up$details
    ##   Return the plot to the workflow.
    ..env$.lag_plot
}
