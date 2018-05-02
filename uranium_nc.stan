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
  vector[J] a_std;
  real mu_a;
  real<lower=0> sigma_a;
}

transformed parameters {
  vector[J] a = mu_a + sigma_a * a_std;
}

model {
  log_radon ~ normal(a[county] + basement_effect * basement + beta_u * u, sigma);
  basement_effect ~ normal(0, 5);
  beta_u ~ normal(0, 5);
  sigma ~ normal(0, 5);
  sigma_a ~ normal(0, 5);
  mu_a ~ normal(0, 5);
  a_std ~ normal(0, 1);
}

generated quantities {
  vector[N] yppc;
  for(i in 1:N)
    yppc[i] = normal_rng(a[county[i]] + 
                         basement_effect * basement[i] + 
                         beta_u * u[i], sigma);
}
