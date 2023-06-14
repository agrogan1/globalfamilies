# simulate MICS data

set.seed(1234) # random seed

N <- 100 # sample size

cd1 <- rbinom(N, 1, .38) # spank

cd2 <- rbinom(N, 1, .05) # beat

cd3 <- rbinom(N, 1, .64) # shout

cd4 <- rbinom(N, 1, .78) # explain

z <- .7 + # based on MICS
  .23 * cd1 + 
  .52 * cd2 + 
  .42 * cd3 + 
  -.21 * cd4 

p <- exp(z) / (1 + exp(z))

aggression <- rbinom(N, 1, p) # gets along

MICSsimulated <- data.frame(cd1, cd2, cd3, cd4, aggression)

fit1 <- glm(aggression ~ cd1 + cd2 + cd3 + cd4 , 
            family = "binomial",
            data = MICSsimulated)

summary(fit1)



