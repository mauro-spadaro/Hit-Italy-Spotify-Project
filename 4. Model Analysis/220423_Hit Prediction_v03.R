# Preparation
library(corrplot)
library(mlr3verse)
library(mlr3learners)
library(kknn)
library(caret)
library(tidyverse)
library(mlr3measures)
library(mlr3extralearners)
library(mlr3viz)
library(ggplot2)
library(GenSA)
library(bbotk)


# Import datasets
all_non_hits = read.csv("Non_hits_cleaned.csv")
all_hits = read.csv("hits_database_clean.csv")

# Add "hit" indicator to "all_hits" given that this is missing
all_hits$hit = 1

## Create non-hits dataset for 50/50 split
n_non_hits = nrow(all_non_hits)
set.seed(123)
non_hits_list = sample(1:n_non_hits, size = 1402, replace = FALSE)
CV_non_hits_list = all_non_hits[non_hits_list,]

# Create datasets that include both hits & non-hits
CV_songs = rbind(all_hits, CV_non_hits_list)
small_songs = rbind(all_hits, all_non_hits)

# Check for and delete potential duplicates
CV_songs[!duplicated(CV_songs$TrackID),]
small_songs[!duplicated(small_songs$TrackID),]

# Change "hit" variable to a factor
CV_songs$hit = as.factor(CV_songs$hit)
small_songs$hit = as.factor(small_songs$hit)

# Delete variables that are not wanted/needed for the prediction
str(CV_songs)
CV_songs[ , c("X", "TrackID", "playlistID", "TrackName", "SampleURL", "ReleaseYear", 
               "Genres", "Popularity")] = list(NULL)
small_songs[ , c("X", "TrackID", "playlistID", "TrackName", "SampleURL", "ReleaseYear", 
              "Genres", "Popularity")] = list(NULL)


### Do analysis for 50/50 Datasplit
# Define Cost-Sensitive Classification Optimization (assuming that the company 
# will make 10x profit if the investment is good but lose 80% of original 
# investment if investment flops)
CV_costs = matrix(c(0, 0.8, 0, -10), nrow = 2)
dimnames(CV_costs) = list(response = c("0", "1"), truth = c("0", "1"))
print(CV_costs)

# Define benchmarking inputs
resampling_strategy = rsmps("cv", folds = 10)
CV_task = TaskClassif$new(id = "CV_analysis", CV_songs, target = "hit")
CV_learners = c(lrn("classif.featureless"), lrn("classif.cv_glmnet", predict_type = "prob"),
                lrn("classif.rpart", predict_type = "prob"), lrn("classif.ranger", predict_type = "prob"),
                lrn("classif.naive_bayes", predict_type = "prob"))

# Define and run benchmark
set.seed(123)
CV_benchmark_design = benchmark_grid(tasks = CV_task, learners = CV_learners, 
                                     resamplings = resampling_strategy)
CV_benchmark = benchmark(CV_benchmark_design, store_models = TRUE)

# Analyze model measures 
CV_measures = list(msr("classif.ce"), msr("classif.fpr"), msr("classif.fnr"), 
                   msr("classif.tpr"), msr("classif.tnr"), msr("classif.acc"),
                   msr("classif.precision"), msr("classif.recall"))
CV_measures_table = CV_benchmark$aggregate(CV_measures)
print(CV_measures_table)


CV22 = data.frame(lapply(CV_measures_table, as.character), stringsAsFactors=FALSE)

write.csv(CV22, "50_50_CV_Measures.csv")

# Analyze classification costs
CV_cost_measure = msr("classif.costs", costs = CV_costs)
abc23 = CV_benchmark$aggregate(CV_cost_measure)

CV23 = data.frame(lapply(abc23, as.character), stringsAsFactors=FALSE)

write.csv(CV23, "50_50_COST_Measures.csv")



# Create boxplots of results
## Classification Error
Boxplot_ce = autoplot(CV_benchmark) + 
        ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 45, hjust = 1))
Boxplot_ce
## False-positive Rate
Boxplot_fpr = autoplot(CV_benchmark, measure = msr("classif.fpr")) + 
        ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 45, hjust = 1))
Boxplot_fpr
## False-negative Rate
Boxplot_fnr = autoplot(CV_benchmark, measure = msr("classif.fnr")) + 
        ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 45, hjust = 1))
Boxplot_fnr
## True-positive Rate
Boxplot_tpr = autoplot(CV_benchmark, measure = msr("classif.tpr")) + 
        ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 45, hjust = 1))
Boxplot_tpr
## True-negative Rate
Boxplot_tnr = autoplot(CV_benchmark, measure = msr("classif.fnr")) + 
        ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 45, hjust = 1))
Boxplot_tnr
## Accuracy 
Boxplot_acc = autoplot(CV_benchmark, measure = msr("classif.acc")) + 
        ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 45, hjust = 1))
Boxplot_acc
## Precision
Boxplot_precision = autoplot(CV_benchmark, measure = msr("classif.precision")) + 
        ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 45, hjust = 1))
Boxplot_precision
## Recall
Boxplot_recall = autoplot(CV_benchmark, measure = msr("classif.recall")) + 
        ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 45, hjust = 1))
Boxplot_recall

# Create confusion matrices based on individual models
resampling_strategy_individual = rsmp("cv", folds = 10)
CV_task_individual = TaskClassif$new(id = "song_name", CV_songs, target = "hit")
## Featureless
CV_learner_featureless = lrn("classif.featureless")
set.seed(1234)
CV_resampling_featureless = resample(task = CV_task_individual, learner = CV_learner_featureless, 
                                    resampling = resampling_strategy_individual)
CM_logistic_featureless_50 =CV_resampling_featureless$prediction()$confusion
CM_logistic_featureless_50
## Logistic regression
CV_learner_regression = lrn("classif.cv_glmnet")
set.seed(1234)
CV_resampling_regression = resample(task = CV_task_individual, learner = CV_learner_regression, 
                                       resampling = resampling_strategy_individual)
CM_logistic_regression_50 =CV_resampling_regression$prediction()$confusion
CM_logistic_regression_50
## Classification tree
CV_learner_rpart = lrn("classif.rpart")
set.seed(1234)
CV_resampling_rpart = resample(task = CV_task_individual, learner = CV_learner_rpart, 
                                    resampling = resampling_strategy_individual)
CM_logistic_rpart_50 =CV_resampling_rpart$prediction()$confusion
CM_logistic_rpart_50
## Random forest
CV_learner_ranger = lrn("classif.ranger")
set.seed(1234)
CV_resampling_ranger = resample(task = CV_task_individual, learner = CV_learner_ranger, 
                               resampling = resampling_strategy_individual)
CM_logistic_ranger_50 =CV_resampling_ranger$prediction()$confusion
CM_logistic_ranger_50
## Naive Bayes
CV_learner_naive_bayes = lrn("classif.naive_bayes")
set.seed(1234)
CV_resampling_naive_bayes = resample(task = CV_task_individual, learner = CV_learner_naive_bayes, 
                                resampling = resampling_strategy_individual)
CM_logistic_naive_bayes_50 =CV_resampling_naive_bayes$prediction()$confusion
CM_logistic_naive_bayes_50

### Do analysis for 15/85 Datasplit
# Define Cost-Sensitive Classification Optimization (assuming that the company 
# will make 10x profit if the investment is good but lose 80% of original 
# investment if investment flops)
small_costs = matrix(c(0, 0.8, 0, -10), nrow = 2)
dimnames(small_costs) = list(response = c("0", "1"), truth = c("0", "1"))
print(small_costs)

# Define benchmarking inputs
small_task = TaskClassif$new(id = "small_analysis", small_songs, target = "hit")
small_learners = c(lrn("classif.featureless"), lrn("classif.cv_glmnet", predict_type = "prob"),
                lrn("classif.rpart", predict_type = "prob"), lrn("classif.ranger", predict_type = "prob"),
                lrn("classif.naive_bayes", predict_type = "prob"))

# Define and run benchmark
set.seed(123)
small_benchmark_design = benchmark_grid(tasks = small_task, learners = small_learners, 
                                     resamplings = resampling_strategy)
small_benchmark = benchmark(small_benchmark_design, store_models = TRUE)

# Analyze model measures 
small_measures = list(msr("classif.ce"), msr("classif.fpr"), msr("classif.fnr"), 
                   msr("classif.tpr"), msr("classif.tnr"), msr("classif.acc"),
                   msr("classif.precision"), msr("classif.recall"))
small_measures_table = small_benchmark$aggregate(small_measures)
print(small_measures_table)

CV24 = data.frame(lapply(small_measures_table, as.character), stringsAsFactors=FALSE)

write.csv(CV24, "15_85_CV_Measures.csv")

# Analyze classification costs
small_cost_measure = msr("classif.costs", costs = small_costs)
dfg= small_benchmark$aggregate(small_cost_measure)


CV25 = data.frame(lapply(dfg, as.character), stringsAsFactors=FALSE)

write.csv(CV25, "15_85_COST_Measures.csv")

# Create boxplots of results
## Classification Error
small_boxplot_ce = autoplot(small_benchmark) + 
        ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 45, hjust = 1))
small_boxplot_ce
## False-positive Rate
small_boxplot_fpr = autoplot(small_benchmark, measure = msr("classif.fpr")) + 
        ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 45, hjust = 1))
small_boxplot_fpr
## False-negative Rate
small_boxplot_fnr = autoplot(small_benchmark, measure = msr("classif.fnr")) + 
        ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 45, hjust = 1))
small_boxplot_fnr
## True-positive Rate
small_boxplot_tpr = autoplot(small_benchmark, measure = msr("classif.tpr")) + 
        ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 45, hjust = 1))
small_boxplot_tpr
## True-negative Rate
small_boxplot_tnr = autoplot(small_benchmark, measure = msr("classif.fnr")) + 
        ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 45, hjust = 1))
small_boxplot_tnr
## Accuracy 
small_boxplot_acc = autoplot(small_benchmark, measure = msr("classif.acc")) + 
        ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 45, hjust = 1))
small_boxplot_acc
## Precision
small_boxplot_precision = autoplot(small_benchmark, measure = msr("classif.precision")) + 
        ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 45, hjust = 1))
small_boxplot_precision
## Recall
small_boxplot_recall = autoplot(small_benchmark, measure = msr("classif.recall")) + 
        ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 45, hjust = 1))
small_boxplot_recall

# Create confusion matrices based on individual models
small_task_individual = TaskClassif$new(id = "song_name", small_songs, target = "hit")
## Featureless
small_learner_featureless = lrn("classif.featureless")
set.seed(1234)
small_resampling_featureless = resample(task = small_task_individual, learner = small_learner_featureless, 
                                     resampling = resampling_strategy_individual)
CV_logistic_featureless_15 =small_resampling_featureless$prediction()$confusion
CV_logistic_featureless_15
## Logistic regression
small_learner_regression = lrn("classif.cv_glmnet")
set.seed(1234)
small_resampling_regression = resample(task = small_task_individual, learner = small_learner_regression, 
                                    resampling = resampling_strategy_individual)
CV_logistic_regression_15 = small_resampling_regression$prediction()$confusion
CV_logistic_regression_15
## Classification tree
small_learner_rpart = lrn("classif.rpart")
set.seed(1234)
small_resampling_rpart = resample(task = small_task_individual, learner = small_learner_rpart, 
                               resampling = resampling_strategy_individual)
CV_logistic_rpart_50 = small_resampling_rpart$prediction()$confusion
CV_logistic_rpart_50
## Random forest
small_learner_ranger = lrn("classif.ranger")
set.seed(1234)
small_resampling_ranger = resample(task = small_task_individual, learner = small_learner_ranger, 
                                resampling = resampling_strategy_individual)
CV_logistic_ranger_15 = small_resampling_ranger$prediction()$confusion
CV_logistic_ranger_15
## Naive Bayes
small_learner_naive_bayes = lrn("classif.naive_bayes")
set.seed(1234)
small_resampling_naive_bayes = resample(task = small_task_individual, learner = small_learner_naive_bayes, 
                                     resampling = resampling_strategy_individual)
CV_logistic_naive_bayes_15 = small_resampling_naive_bayes$prediction()$confusion
CV_logistic_naive_bayes_15