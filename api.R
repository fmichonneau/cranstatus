library(foghorn)
library(dplyr)


download_cran_file <- function(file = "results") {
    if (!dir.exists("data")) {
        dir.create("data")
    }
    latest <- file.path("data", paste0("latest_check_", file, ".rds"))
    timestamp <- format(Sys.time(), "%Y%m%d-%H%M%S")
    crandb <- foghorn:::fetch_cran_rds_file(file,
                                            dest = "data",
                                            file_prefix = paste0(timestamp, "_"))
    if (file.exists(crandb)) {
        if (file.exists(latest)) {
            file.remove(latest)
            message("latest_exist: ", file.exists(latest))
        }
        file.copy(crandb, latest)
        if (file.exists(latest)) message("file copied")
    }
    foghorn:::check_cran_rds_file(latest, return_logical = TRUE)
}
download_cran_file()


#* @get /package_status
package_status <- function(package, email, ...) {
    if (missing(package))
        package <- NULL
    if (missing(email))
        email <- NULL
    if (!is.null(package))
        res <- foghorn:::crandb_pkg_info_pkg(pkg = package, file = "data/latest_check_results.rds")
    else if (!is.null(email))
        res <- foghorn:::crandb_pkg_info_email(email = email, file = "data/latest_check_results.rds")
    res
}


#* @get /api_status
api_status <- function() {
    data_file_info <- file.info(list.files("data", full.names = TRUE))
    last_data_update <- max(data_file_info$mtime)
    latest_data <- data_file_info[abs(data_file_info$mtime - last_data_update) < 1, ]

    latest_results_exists <- file.exists("data/latest_check_results.rds")
    using_latest_data <- nrow(latest_data) == 2L
    latest_data_file <- rownames(latest_data)[!grepl("latest", rownames(latest_data))]
    list(
        latest_results_exists = latest_results_exists,
        last_data_update = last_data_update,
        using_latest_data = using_latest_data,
        latest_data_file = basename(latest_data_file)
    )
}
