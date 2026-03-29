# groupmscorev

An R package for constructing within-group trimming M-scores for sensitivity analysis. It implements the methodology proposed in:

> Fan, Y. and Small, D. (2026). *A subgroup-aware scoring approach to the study of effect modification in observational studies.* Observational Studies.

## Installation

You can install the development version from GitHub with:

```r
# install.packages("remotes")
remotes::install_github("yjf326/groupmscorev")
```

## Function

The package includes an R function (see `groupscoremv.R`) that generates the within-group trimming M-scores suitable for subgroup comparisons in matched observational studies.

## Example
```r
# 1. Generate baseline parameters
set.seed(123) # Set seed for reproducibility
#Baseline parameters
I = 1000
c = rep(1,I)
c1 = c(rep(1,I/2),rep(0,I*1/2))
c1_rev = 1-c1
c2 = rep(c(0,1),I/2)
c2_rev = 1 - c2

# Create the cmat matrix
cmat = cbind(c,c1,c1_rev,c2,c2_rev)
# Simulate the raw scores
effect_1 = 4
effect_2 = 0.2
raw = rep(0,I)
raw[1:(I/2)] = 5*rnorm(n = I/2)+effect_1
raw[(1+I/2):I] = rnorm(n = I/2)+effect_2


# 2. Generate the scores
trimmed_default <- groupmscorev(raw,cmat)
```

Then, the score is ready for conducting sensitivity analysis that involves subgroup comparisons and one may want to use the `submax` package by calling `submax(groupmscore,cmat,gamma = Gamma)`.

## Reference
Please cite the following paper if you want to use the package:
> Fan, Y. and Small, D. (2026). *A subgroup-aware scoring approach to the study of effect modification in observational studies.* Observational Studies.

The submax method is implemented in the `submax` package and is detailed in the following paper:
> Lee, K., Small, D.S. and Rosenbaum, P.R. (2018), *A powerful approach to the study of moderate effect modification in observational studies.* Biometrics.
