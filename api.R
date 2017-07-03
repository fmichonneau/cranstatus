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
        if (file.exists(latest)) file.remove(latest)
        file.symlink(normalizePath(crandb),
                     normalizePath(latest, mustWork = FALSE))
    }
    check_cran_rds_file(latest, return_logical = TRUE)
}
download_cran_file()


#* @get /package_status
package_status <- function(package, email, ...) {
    if (missing(package))
        package <- NULL
    if (missing(email))
        email <- NULL
    if (!is.null(package))
        res <- foghorn:::crandb_pkg_info_pkg(pkg = package)
    else if (!is.null(email))
        res <- foghorn:::crandb_pkg_info_email(email = email)
    res
}
