library(foghorn)
library(dplyr)

crandb <- foghorn:::get_cran_rds_file("results")

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
