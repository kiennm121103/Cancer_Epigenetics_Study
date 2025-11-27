# Loading required libraries
library(bayesplot)
library(ggplot2)
library(rstanarm)

# Data
head(mtcars)

# Fitting a Bayesian linear model using rstanarm
fit <- stan_glm(mpg ~ ., data = mtcars, seed = 1111)
print(fit)

# Extracting posterior samples as an array
posterior <- as.array(fit)
dim(posterior)

# Checking dimnames
dimnames(posterior)

# Visualizations using bayesplot
color_scheme_set("red")
mcmc_intervals(posterior, pars = c("cyl","drat","am", "sigma"))

mcmc_areas(
    posterior,
    pars = c("cyl","drat","am","sigma"),
    prob = 0.8,
    prob_outer = 0.99,
    point_est = "mean"
)

color_scheme_set("green")
mcmc_hist(
    posterior,
    pars = c("wt","sigma")
)

color_scheme_set("blue")
mcmc_hist(
    posterior,
    pars = c("wt","sigma")
    transformations = list("sigma" = "log")
)

color_scheme_set("brightblue")
mcmc_hist_by_chain(
    posterior,
    pars = c("wt","sigma")
)

color_scheme_set("purple")
mcmc_dens(
    posterior,
    pairs = c("wt","sigma")
)

mcmc_dens_overlay(posterior, pars = c("wt", "sigma"))

color_scheme_set("teal")
mcmc_violin(
    posterior,
    pars = c("wt", "sigma")
    probs = c(0.1, 0.5, 0.9)
)

color_scheme_set("gray")
mcmc_scatter(posterior, pars = c("(Intercept)", "wt"),
             size = 1.5, alpha = 0.5)

# Required hexbin packages
if (requireNamespace("hexbin", quietly = TRUE)) {
    color_scheme_set("gray")
    mcmc_hex(
      posterior,
      pars = c("(Intercept)", "wt")
  )
}

color_scheme_set("pink")
mcmc_pairs(
    posterior,
    pairs = c("(Intercept)", "wt", "sigma"),
    off_diag_args = list(size = 1.5)
)

color_scheme_set("blue")
mcmc_trace(
    posterior,
    pars = c("wt","sigma")
)

color_scheme_set("mix-blue-red")
mcmc_trace(
    posterior,
    pars = c("wt", "sigma"),
    fact_args = list(ncol = 1, strip.positron = "left"))

color_scheme_set("viridis")
mcmc_trace(posterior, pars = "(Intercept)")

mcmc_trace_highlight(posterior, pars = "sigma", highlight=3)