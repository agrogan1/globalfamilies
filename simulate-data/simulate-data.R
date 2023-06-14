# simulate MICS data

# call libraries

library(labelled) # labels

library(haven) # write Stata

# setup

set.seed(1234) # random seed

N <- 100 # sample size

# based on MICS

cd1 <- rbinom(N, 1, .38) # spank

cd2 <- rbinom(N, 1, .05) # beat

cd3 <- rbinom(N, 1, .64) # shout

cd4 <- rbinom(N, 1, .78) # explain

z <- .7 + 
  .23 * cd1 + 
  .52 * cd2 + 
  .42 * cd3 + 
  -.21 * cd4 

p <- exp(z) / (1 + exp(z)) # probability

aggression <- rbinom(N, 1, p) # binomial y

# data frame

MICSsimulated <- data.frame(cd1, cd2, cd3, cd4, aggression)

var_label(MICSsimulated$cd1) <- "spank"

var_label(MICSsimulated$cd2) <- "beat"

var_label(MICSsimulated$cd3) <- "shout"

var_label(MICSsimulated$cd4) <- "explain"

var_label(MICSsimulated$aggression) <- "aggression"

# logistic regression model

fit1 <- glm(aggression ~ cd1 + cd2 + cd3 + cd4 , 
            family = "binomial",
            data = MICSsimulated)

summary(fit1)

# write data to various formats

save(MICSsimulated, file = "./simulate-data/MICSsimulated.RData")

write_dta(MICSsimulated, "./simulate-data/MICSsimulated.dta")

