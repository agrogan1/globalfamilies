# simulate MICS data

# call libraries

library(tibble) # new dataframes

library(ggplot2) # nifty graphs

library(labelled) # labels

library(haven) # write Stata

library(tidyr) # tidy data

library(dplyr) # wrangle data

# setup

set.seed(1234) # random seed

N_countries <- 30 # number of countries

N <- 100 # sample size / country

# simulate data based on MICS

# Level 2

country <- seq(1:N_countries)

u0 <- rnorm(N_countries, 0, .1) # random intercept

u1 <- rnorm(N_countries, 0, .05) # random slope

randomeffects <- data.frame(country, u0, u1) # dataframe of random effects

# Level 1

MICSsimulated <- randomeffects %>% 
  uncount(N) %>% # N individuals / country
  mutate(id = row_number()) %>% # unique id
  mutate(cd1 = rbinom(N * N_countries, 1, .38), # spank
         cd2 = rbinom(N * N_countries, 1, .05), # beat
         cd3 = rbinom(N * N_countries, 1, .64), # shout
         cd4 = rbinom(N * N_countries, 1, .78)) %>% # explain
  mutate(z = .7 + # linear combination based on MICS
           .23 * cd1 +
           .52 * cd2 +
           .42 * cd3 +
           -.21 * cd4 + 
           u0) %>%
  mutate(p = exp(z) / (1 + exp(z))) %>% # probability
  mutate(aggression = rbinom(N * N_countries, 1, p)) %>% # binomial y
  select(id, country, 
         cd1, cd2, cd3, cd4, 
         aggression)

# variable labels

var_label(MICSsimulated$id) <- "id"

var_label(MICSsimulated$country) <- "country"

var_label(MICSsimulated$cd1) <- "spank"

var_label(MICSsimulated$cd2) <- "beat"

var_label(MICSsimulated$cd3) <- "shout"

var_label(MICSsimulated$cd4) <- "explain"

var_label(MICSsimulated$aggression) <- "aggression"

# explore with graph

ggplot(MICSsimulated,
       aes(x = cd1, # x is spanking
           y = aggression, # y is aggression
           color = factor(country))) + # color is country
  geom_smooth(method = "glm", # glm smoother
              method.args = list(family = "binomial"),
              alpha = .1) + # transparency for CI's
  labs(title = "Aggression as a Function of Spanking",
       x = "spank",
       y = "aggression") +
  scale_color_viridis_d(name = "Country") + # nice colors
  theme_minimal()

# explore with logistic regression model

fit1 <- glmer(aggression ~ cd1 + cd2 + cd3 + cd4 +
                (1 | country), 
              family = "binomial",
              data = MICSsimulated)

summary(fit1)

# write data to various formats

save(MICSsimulated, file = "./simulate-data/MICSsimulated.RData")

write_dta(MICSsimulated, "./simulate-data/MICSsimulated.dta")

