pkgs_cran <- readLines('/mfs/cvl/groups/kenrod/software/scripts/eep170030/GitHub/dockerfiles/dockerfiles/r/4.2.1-gs/pkgs_cran.txt')
pkgs_gh <- readLines('/mfs/cvl/groups/kenrod/software/scripts/eep170030/GitHub/dockerfiles/dockerfiles/r/4.2.1-gs/pkgs_gh.txt')
pkgs_gh <- stringr::str_split(pkgs_gh, '/') |> purrr::map(2) |> unlist()
pkgs <- c(pkgs_cran, pkgs_gh)

is_installed <- function(package) {
  return(ifelse(system.file(package = package) != "", TRUE, FALSE))
}

pkgs_installed <- unlist(lapply(pkgs, is_installed))

if (mean(pkgs_installed) < 1) {
  cat('❎\tmissing package(s):', '\n')
  cat(paste0(pkgs[which(!pkgs_installed)], collapse = '\n'))
} else {
  cat('✅\tall packages installed', '\n')
}
