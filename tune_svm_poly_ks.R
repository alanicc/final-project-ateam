library(tidyverse)
library(tidymodels)
library(tictoc)

tidymodels_prefer()

# set seed ----
set.seed(1234)

# load in data ---- 
load("results/rec_ks_short_setup.rda")


# create models ----
svm_poly_mod <- svm_poly(mode = "classification", 
                         cost = tune(),
                         degree = tune(),
                         scale_factor = tune()) %>%
  set_engine("kernlab")


# create grids and parameters ----
## svm poly model ----
svm_poly_params <- extract_parameter_set_dials(svm_poly_mod)

svm_poly_grid <- grid_regular(svm_poly_params, levels = 5)


# create workflow ----
## svm poly model ----
svm_poly_workflow_ks <- workflow() %>% 
  add_model(svm_poly_mod) %>% 
  add_recipe(rec_ks)

# tuning/fitting ----
tic.clearlog()
tic("Polynomial SVM: KS Recipe")


svm_poly_tune_ks <- tune_grid(
  svm_poly_workflow_ks,
  resamples = cars_fold,
  grid = svm_poly_grid,
  control = control_grid(save_pred = TRUE,
                         save_workflow = TRUE,
                         parallel_over = "everything"))


toc(log = TRUE)

time_log <- tic.log(format = FALSE)

svm_poly_tictoc_ks <- tibble(model = time_log[[1]]$msg,
                          runtime = time_log[[1]]$toc - time_log[[1]]$tic)

save(svm_poly_tune_ks, svm_poly_tictoc_ks,
     file = "results/tuning_svm_poly_ks.rda")
