library(tidyverse)
library(tidymodels)
library(textrecipes)
library(tictoc)

tidymodels_prefer()

# set seed ----
set.seed(1234)

# load in data ---- 
load("results/rec_1_setup.rda")


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
nn_workflow_ks <- workflow() %>% 
  add_model(nn_mod) %>% 
  add_recipe(rec_ks)


# tuning/fitting ----
tic.clearlog()
tic("Neural Network: Kitchen Sink")


nn_tune_ks <- tune_grid(
  nn_workflow_ks,
  resamples = cars_fold,
  grid = nn_grid,
  control = control_grid(save_pred = TRUE,
                         save_workflow = TRUE,
                         parallel_over = "everything"))

toc(log = TRUE)

time_log <- tic.log(format = FALSE)

nn_tictoc_ks <- tibble(model = time_log[[1]]$msg,
                     runtime = time_log[[1]]$toc - time_log[[1]]$tic)


<<<<<<< HEAD
<<<<<<< HEAD:2_tune_nn.R
save(nn_tune, nn_tictoc, nn_workflow,
     file = "results/tuning_nn.rda")




## rec 2

# set seed ----
set.seed(1234)

# load in data ---- 
load("results/rec_2_setup.rda")
=======
save(nn_tune, nn_tictoc_ks, nn_workflow_ks,
     file = "results/tuning_nn_ks.rda")
>>>>>>> 09ecc67545282768e93d0a0a7e4bef9e53f4e95e:tune_nn_ks.R
=======
save(nn_tune, nn_tictoc_ks, nn_workflow_ks,
     file = "results/tuning_nn_ks.rda")
>>>>>>> d88a78f6dfcb0649d983d532b46a7f0a9568333a