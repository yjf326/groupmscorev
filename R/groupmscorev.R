#' Calculate Group M-Score
#'
#' @description groupmscorev makes subgroup trimming for submax method.
#'
#' @param raw A numeric vector representing the raw scores.
#' @param cmat A matrix representing the group categories.
#' @param inner_para A numeric value for the inner parameter. Default is 0.
#' @param trim_para A numeric value for the trim parameter. Default is 3.
#' @param lambda A numeric value for the lambda parameter. Default is 0.5.
#' @importFrom stats quantile
#' @return A numeric vector of trimmed scores.
#' @export
#'
#' @examples
#' # 1. Generate baseline parameters
#' set.seed(123) # Set seed for reproducibility
#'
#' #Baseline parameters
#' I = 1000
#' c = rep(1,I)
#' c1 = c(rep(1,I/2),rep(0,I*1/2))
#' c1_rev = 1-c1
#' c2 = rep(c(0,1),I/2)
#' c2_rev = 1 - c2
#'
#' # Create the cmat matrix
#' cmat = cbind(c,c1,c1_rev,c2,c2_rev)
#' # Simulate the raw scores
#' effect_1 = 4
#' effect_2 = 0.2
#' raw = rep(0,I)
#' raw[1:(I/2)] = 5*rnorm(n = I/2)+effect_1
#' raw[(1+I/2):I] = rnorm(n = I/2)+effect_2

#' # 2. Generate the scores
#' trimmed_default <- groupmscorev(raw,cmat)
#'


groupmscorev <- function(raw, cmat, inner_para = 0, trim_para = 3, lambda = 0.5) {
  raw = as.numeric(raw)
  cmat = as.matrix(cmat)
  score = cbind(raw,cmat)
  colnames(score) = c(colnames(score)[1],paste0('g',1:(ncol(score)-1)))
  score = as.data.frame(score)

  unique_groups <- unique(score[, -1])
  score$trim = rep(0,nrow(score))

  for (i in 1:nrow(unique_groups)) {
    # Identify the rows corresponding to this unique subgroup
    subgroup_mask <- apply(score[, -1], 1, function(row) all(row == unique_groups[i,]))

    # Extract the current non-overlapped subgroup in this loop
    subgroup_cur = score[subgroup_mask,]
    # Assign the scores to the trim vector for these rows
    score$trim[subgroup_mask] = ifelse(
      abs(subgroup_cur$raw)/quantile(abs(subgroup_cur$raw),lambda)>trim_para,
      trim_para*quantile(abs(subgroup_cur$raw),lambda),
      abs(subgroup_cur$raw))

    score$trim[subgroup_mask] = ifelse(
      abs(subgroup_cur$raw)/quantile(abs(subgroup_cur$raw),lambda)<inner_para,
      0,
      score$trim[subgroup_mask])
  }
  score$trim = sign(score$raw)*score$trim
  return(score$trim)
}
































