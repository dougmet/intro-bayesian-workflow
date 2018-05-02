data {
 int<lower=0> N;
 int<lower=0> J;
 vector[N] basement;
 vector[N] log_radon;
 int<lower=1,upper=J> county[N];
}


parameters {
  real basement_effect;
  real<lower=0> sigma;
  vector[J] a;
}

model {
  log_radon ~ normal(a[county] + basement_effect * basement, sigma);
  a ~ normal(0, 5);
  basement_effect ~ normal(0, 5);
  sigma ~ normal(0, 5);
}
