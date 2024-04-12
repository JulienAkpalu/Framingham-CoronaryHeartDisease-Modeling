# Set the working directory
setwd("C:/Users/julien/Desktop/GITHUB/Framingham")

###### EXPLORATORY DATA ANALYSIS ######

# Load necessary libraries
library(ggplot2)
library(dplyr)

# Load the dataset
framingham_data <- read.csv("framingham.csv")

# View the first few rows of the dataset
head(framingham_data)
View(framingham_data)

# Get a basic statistical overview of the dataset
summary(framingham_data)

# Check the structure of the dataset
str(framingham_data)

# Histogram for Age Distribution
ggplot(framingham_data, aes(x = age)) +
  geom_histogram(binwidth = 1, fill = "blue", color = "black") +
  labs(title = "Age Distribution", x = "Age", y = "Frequency")

# Box plot for Total Cholesterol by Gender
ggplot(framingham_data, aes(x = as.factor(male), y = totChol, fill = as.factor(male))) +
  geom_boxplot() +
  labs(title = "Total Cholesterol by Gender", x = "Gender (0 = Female, 1 = Male)", y = "Total Cholesterol")

# Scatter plot for Age vs. Total Cholesterol
ggplot(framingham_data, aes(x = age, y = totChol)) +
  geom_point(aes(color = as.factor(male))) +
  labs(title = "Age vs Total Cholesterol", x = "Age", y = "Total Cholesterol")

###### DATA PREPARATION AND CLEANING ######

# Loading necessary libraries
library(dplyr)
library(tidyr)

# Loading the dataset
data <- read.csv("framingham.csv")

# Imputing missing values
# For continuous variables, median is used for imputation
# For categorical variables, mode is used for imputation
data$cigsPerDay[is.na(data$cigsPerDay)] <- median(data$cigsPerDay, na.rm = TRUE)
data$BPMeds[is.na(data$BPMeds)] <- median(data$BPMeds, na.rm = TRUE)
data$totChol[is.na(data$totChol)] <- median(data$totChol, na.rm = TRUE)
data$BMI[is.na(data$BMI)] <- median(data$BMI, na.rm = TRUE)
data$heartRate[is.na(data$heartRate)] <- median(data$heartRate, na.rm = TRUE)
data$glucose[is.na(data$glucose)] <- median(data$glucose, na.rm = TRUE)

# Finding the mode for 'education' and imputing missing values
educationMode <- as.numeric(names(sort(table(data$education), decreasing=TRUE)))[1]
data$education[is.na(data$education)] <- educationMode

# Applying log transformation for 'cigsPerDay' and 'glucose' to address skewness
# Adding a small constant to avoid log(0)
data$cigsPerDay <- log(data$cigsPerDay + 1)
data$glucose <- log(data$glucose + 1)

# Function to cap outliers
cap_value <- function(x, limit, lower_upper = "upper") {
  if(lower_upper == "upper"){
    x[x > limit] <- limit
  } else {
    x[x < limit] <- limit
  }
  return(x)
}

# Capping outliers in variables
# The cap limits are set based on clinical relevance or statistical considerations
data$sysBP <- cap_value(data$sysBP, 180)   # Capping systolic blood pressure at 180
data$diaBP <- cap_value(data$diaBP, 120)   # Capping diastolic blood pressure at 120
data$BMI <- cap_value(data$BMI, 50)        # Capping BMI at 50
data$heartRate <- cap_value(data$heartRate, 150)  # Capping heart rate at 150
data$totChol <- cap_value(data$totChol, 350)  # Capping total cholesterol at 350

# Saving the cleaned and preprocessed dataset
write.csv(data, "framingham_cleaned.csv", row.names = FALSE)


####### Statistical Methods in Feature Selection and Analysis #######

# Load necessary libraries
library(readr)
library(dplyr)
library(ggplot2)
library(caret)
library(MASS)
library(e1071)

# Read the data
data <- read_csv("framingham_cleaned.csv")

# Univariate Analysis
# Logistic Regression for continuous variables and Chi-Square for categorical variables
univariate_results <- list()

for (column in names(data)) {
  if (column != 'TenYearCHD') {
    if (is.numeric(data[[column]]) && length(unique(data[[column]])) > 10) {
      # Continuous variable
      fit <- glm(TenYearCHD ~ data[[column]], data = data, family = binomial())
      univariate_results[[column]] <- summary(fit)$coefficients[2,]
    } else {
      # Categorical variable
      chi_res <- chisq.test(table(data[[column]], data$TenYearCHD))
      univariate_results[[column]] <- c(Statistic = chi_res$statistic, 
                                        'p-value' = chi_res$p.value)
    }
  }
}

# Print univariate analysis results
print(univariate_results)

# Multivariate Analysis with Logistic Regression
fit_full <- glm(TenYearCHD ~ ., data = data, family = binomial())

# Model summary
summary(fit_full)

# Classification report
predicted_prob <- predict(fit_full, type = "response")
predicted_class <- ifelse(predicted_prob > 0.5, 1, 0)
conf_matrix <- table(Predicted = predicted_class, Actual = data$TenYearCHD)
print(conf_matrix)


###### R Script for Predicting 10-Year Risk of CHD ######

# Install and load necessary libraries
install.packages("caret")
install.packages("ROSE")
install.packages("pROC")
library(caret)
library(ROSE)
library(pROC)

# Load the cleaned Framingham dataset
# Replace the path with the actual path to your dataset file
data <- read.csv("framingham_cleaned.csv")

# Splitting the data into training and testing sets
set.seed(42)
index <- createDataPartition(data$TenYearCHD, p = 0.7, list = FALSE)
train_data <- data[index,]
test_data <- data[-index,]

# Applying ROSE to balance the training data
size_of_balanced_data <- 2 * sum(train_data$TenYearCHD == 0)
balanced_data <- ovun.sample(TenYearCHD ~ ., data = train_data, method = "over", N = size_of_balanced_data)$data

# Training a logistic regression model
model <- glm(TenYearCHD ~ ., data = balanced_data, family = 'binomial')

# Making predictions on the test set
predictions <- predict(model, newdata = test_data, type = "response")
predictions_binary <- ifelse(predictions > 0.5, 1, 0)

# Generating a confusion matrix
confusion_matrix <- table(Predicted = predictions_binary, Actual = test_data$TenYearCHD)
print(confusion_matrix)

# Calculating AUC
roc_curve <- roc(test_data$TenYearCHD, predictions)
auc_score <- auc(roc_curve)
print(paste("AUC Score:", auc_score))
