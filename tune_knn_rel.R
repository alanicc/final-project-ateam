
library(tidyverse)
library(tidymodels)
library(tictoc)
library(doMC)

tidymodels_prefer()

# set seed ----
set.seed(1234)

# load in data ----
load("results/rec_2_setup.rda")


# create models ----
## k nearest neighbors model ----
knn_mod <- nearest_neighbor(mode = "classification",
                            neighbors = tune()) %>% 
  set_engine("kknn")


# create grids and parameters ----
# k nearest neighbors model ----
knn_params <- extract_parameter_set_dials(knn_mod)

knn_grid <- grid_regular(knn_params, levels = 5)


# create workflow ----
## k nearest neighbors model ----
knn_workflow_ks <- workflow() %>% 
  add_model(knn_mod) %>% 
  add_recipe(rec_ks)

knn_workflow_rel <- workflow() %>% 
  add_model(knn_mod) %>% 
  add_recipe(rec_rel)


# tuning/fitting ----

## set up parallel processing
registerDoMC(cores = 8)

tic.clearlog()
tic("KNN: Relationship Recipe")

knn_tune_rel <- tune_grid(
  knn_workflow_rel,
  resamples = cars_fold,
  grid = knn_grid,
  control = control_grid(save_pred = TRUE,
                         save_workflow = TRUE,
                         parallel_over = "everything"))

toc(log = TRUE)

time_log <- tic.log(format = FALSE)

knn_tictoc_rel <- tibble(model = time_log[[1]]$msg,
                     runtime = time_log[[1]]$toc - time_log[[1]]$tic)

save(knn_tune_rel, knn_tictoc_rel,
     file = "results/tuning_knn_rel.rda")
