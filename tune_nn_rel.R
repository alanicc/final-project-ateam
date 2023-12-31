library(tidyverse)
library(tidymodels)
library(tictoc)

tidymodels_prefer()

# set seed ----
set.seed(1234)

# load in data ---- 
load("results/rec_2_short_setup.rda")

# create models ----
## neural network model ----
nn_mod <- mlp(mode = "classification",
              hidden_units = tune(),
              penalty = tune()) %>%
  set_engine("nnet")


# create grids and parameters ----
## neural network model ----
nn_params <- extract_parameter_set_dials(nn_mod)

nn_grid <- grid_regular(nn_params, levels = 5)


# create workflow ----
## neural network model ----
nn_workflow_rel <- workflow() %>% 
  add_model(nn_mod) %>% 
  add_recipe(rec_rel)


# tuning/fitting ----
tic.clearlog()
tic("Neural Network: Relationship Recipe")


nn_tune_rel <- tune_grid(
  nn_workflow_rel,
  resamples = cars_fold,
  grid = nn_grid,
  control = control_grid(save_pred = TRUE,
                         save_workflow = TRUE,
                         parallel_over = "everything"))

toc(log = TRUE)

time_log <- tic.log(format = FALSE)

nn_tictoc_rel <- tibble(model = time_log[[1]]$msg,
                       runtime = time_log[[1]]$toc - time_log[[1]]$tic)

save(nn_tune_rel, nn_tictoc_rel,
     file = "results/tuning_nn_rel.rda")