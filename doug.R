library(rstan)
#library(tidyverse) # clashes with the extract function...
util = new.env()
source("stan_utility.R", local = util)
rstan_options(auto_write = TRUE)
options(mc.cores = parallel::detectCores())


df <- read.csv("data.csv")

View(df)

model <- stan_model("pool.stan")

fit <- sampling(model, list(log_radon=df$log_radon,
                            basement = df$basement,
                            N=nrow(df)))

fit
sample = extract(fit)

util$check_all_diagnostics(fit)


ggplot(df, aes(basement, log_radon)) + geom_count() +
  # This next snippet will select every 10th posterior sample and plot the 
  # fit lines corresponding to that sample. It's a good way to get a sense of
  # the uncertainty / distribution of the posterior
  sapply(seq(1, nrow(sample$alpha), 10), function(i) {
    geom_abline(intercept = sample$alpha[i],
                slope = sample$basement_effect[i], alpha=0.03)
  })


model_unpooled <- stan_model("unpooled.stan")


fit <- sampling(
  model_unpooled,
  list(
    log_radon = df$log_radon,
    basement = df$basement,
    county = df$county,
    N = nrow(df),
    J = max(df$county)
  )
)
fit

model_hierachical <- stan_model("hierarchy.stan")


fit <- sampling(
  model_hierachical,
  list(
    log_radon = df$log_radon,
    basement = df$basement,
    county = df$county,
    N = nrow(df),
    J = max(df$county)
  )
)

model_uranium <- stan_model("uranium.stan")


fit <- sampling(
  model_uranium,
  list(
    log_radon = df$log_radon,
    basement = df$basement,
    county = df$county,
    u = df$log_uranium,
    N = nrow(df),
    J = max(df$county)
  )
)


model_uranium_nc <- stan_model("uranium_nc.stan")

fit <- sampling(
  model_uranium_nc,
  list(
    log_radon = df$log_radon,
    basement = df$basement,
    county = df$county,
    u = df$log_uranium,
    N = nrow(df),
    J = max(df$county)
  )
)
