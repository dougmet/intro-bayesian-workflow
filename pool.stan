data {
 int<lower=1> N;
 vector[N] basement;
 vector[N] log_radon;
}

parameters {
  real basement_effect;
  real<lower=0> sigma;
  real alpha;
}

model {
  log_radon ~ normal(alpha + basement_effect * basement, sigma);
}
