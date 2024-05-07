# Framingham Heart Study - CHD Risk Prediction

## Introduction
This project delves into the Framingham Heart Study dataset to develop a predictive model for the 10-year risk of coronary heart disease (CHD). The focus is on using R for comprehensive data analysis, exploring key risk factors, and modeling to predict CHD risk.

## Objectives
- Conduct in-depth exploratory data analysis (EDA) to understand the dataset.
- Perform data cleaning and preprocessing for effective modeling.
- Apply statistical methods for feature selection and analysis.
- Develop a predictive model to estimate the 10-year risk of CHD.

## Dataset Description
The Framingham dataset is a rich source of information for CHD risk assessment, encompassing:
- **Demographic Information**: Age, gender, etc.
- **Health Metrics**: Blood pressure, cholesterol levels, diabetes status.
- **Lifestyle Data**: Smoking status, physical activity.
- **Target Variable**: 10-year CHD risk.
  
## Repository Structure
- `README.md`: Overview of the project.
- `data/`:
  - `framingham.csv`: Original dataset.
  - `framingham_cleaned.csv`: Cleaned dataset after preprocessing.
- `scripts/`: 
  - `Framingham.R`: R script encompassing data preparation, analysis, and model development.
- `docs/`: Documentation and analysis reports.
  - `CHD_Risk_Analysis_Report.pdf`: Detailed report of the data analysis and modeling process.

## Tools and Technologies
- **R Programming**
- **Key Libraries**: Include libraries like tidyverse, caret, ROSE, pROC.

## How to Run
1. Install R and required libraries.
2. Clone the repository to your system.
3. Execute the R script:
   ```R
   source("scripts/Framingham.R")

## Model Development and Characteristics
The Logistic Regression model, developed to predict the 10-year risk of CHD, was trained on a balanced dataset using SMOTE implemented via the ROSE package. The model demonstrated a moderate discriminative ability (AUC-ROC score: 0.7134) but highlighted a need for improvement in reducing false positives. Insights from this model will guide future enhancements, including feature engineering, alternative algorithm exploration, and hyperparameter tuning.

## Contributing
We welcome contributions to this project! If you'd like to contribute, please follow these steps:
1. Fork the repository.
2. Create a new branch for your feature or bug fix.
3. Make your changes and commit them.
4. Submit a pull request with a clear description of your changes.

Your contributions are greatly appreciated!

## Contact
If you have any questions, feedback, or would like to collaborate on this project, please feel free to reach out. You can contact me at julienakpalu2@gmail.com or send a message through the issues section of this repository.
