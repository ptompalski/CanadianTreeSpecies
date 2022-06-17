#' Canadian tree species data
#'
#' A dataset containing Canadian tree species names (English, French, Scientific) and
#' species codes used at the national level (NFI) and provincial/territorial.
#'
#' @format A data frame with 367 rows and 20 variables:
#' \describe{
#'   \item{NFI_code}{NFI species code}
#'   \item{CommonNameEnglish}{Common species name in English}
#'   \item{CommonNameFrench}{Common species name in French}
#'   \item{ScientificName}{Scientific species name (Latin)}
#'   \item{Genus}{Four letter genus code}
#'   \item{Species}{Three letter species code}
#'   \item{Var}{Three letter variety code}
#'   \item{ab_code, bc_code, nb_code, nt_code, on_code, ns_code, sk_code, yt_code, pe_code, qc_code, mb_code, nl_code}{Provincial/Territorial species codes}
#'   \item{canfi_code}{Numeric species code}
#' }
#' @source
#' https://nfi.nfis.org/en/documentation
#'
#' https://github.com/CASFRI/CASFRI/blob/master/translation/tables/species_code_mapping.csv

"CanadianTreeSpeciesData"
