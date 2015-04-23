# Readme

This repository consists of the following set of files: 
  * [run_analysis.R](run_analysis.R) R script to transform original data set into a tidy data set as per Course Requirements of Getting and Cleaning Data on Coursera. 
  * [CodeBook.md](CodeBook.md) Code book describing original data, tidy data, and description of steps to transform original to tidy data set.

### How to run the script

Make sure the original data set, which can be downloaded from here: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones, is stored in a folder called data under the current working directory.

To run the script invoke:

```
Rscript run_analysis.R

```

The script will output a file called mean_by_subject_activity.txt file with the tidy data set.
