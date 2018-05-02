data {
 int<lower=0> N;
 int<lower=0> J;
 vector[N] basement;
 vector[N] log_radon;
 int<lower=1,upper=J> county[N];
 vector[N] u;
}


parameters {
  real basement_effect;
  real beta_u;
  real<lower=0> sigma;
  vector[J] a;
  real mu_alpha;
  real<lower=0> sigma_alpha;
}

model {
  log_radon ~ normal(a[county] + basement_effect * basement + beta_u * u, sigma);
  basement_effect ~ normal(0, 5);
  beta_u ~ normal(0, 5);
  sigma ~ normal(0, 5);
  sigma_alpha ~ normal(0, 5);
  mu_alpha ~ normal(0, 5);
  a ~ normal(mu_alpha, sigma_alpha);
}

generated quantities {
  vector[N] yppc;
  for(i in 1:N)
    yppc[i] = normal_rng(a[county[i]] + 
                         basement_effect * basement[i] + 
                         beta_u * u[i], sigma);
}
