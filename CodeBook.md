# Code Book

This code book describes: 
  - Data format of original data
  - Data format of output data
  - Steps to transform original to output data

### Original Data

The original data set can be downloaded from here: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones.
The data consists of various measurements taken from a mobile device while human subjects perform various activities like walking, sitting, lying down, etc. The various files in this data set consist of the following data:
* The activities are listed in a file called **_activity_labels.txt_**. There are six of these:`WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING`
* The measurements, also called features, are listed in a file called **_features.txt_**. 
* The human subjects who performed these activities are identified by a numeric number and are listed in files which have prefix **_'subject_'_**. The order of the subjects in this file is the same as the order of the measurements in the corresponding files. There are 30 subjects in total.
* The data set is divided into a train and a test set for machine learning purposes. The measurement variables are stored in files prefixed with **_'X_'_** and the predicted variables, the activities, are stored in files prefixed with **_'y_'_**.

### Tidy Data

The tidy data set is stored in a file called **_'mean_by_subject_activity.txt'_**. Its a comma separated file with headers for each column. It consists of the following columns:

* **_activity_**: Activity identifier, as read from the activity_labels.txt file from the original data set.
* **_'subject_id'_**: Numeric identifier of human subject, as read from **_'subject_*'_** files from original data set. 
* **_aggregated mean of measurements_**: The column titles for the measurements begin with **_'aggr. mean'_** and represent the aggregated mean of the measurements from both the train and test data sets, **_averaged for each subject and activity_**. Only the __mean and std__ measurements from the original data sets are exported to the tidy data set. A few of the measurements are: `aggr. mean  tGravityAcc-mean()-Y, aggr. mean  fBodyGyro-std()-X, aggr. mean  fBodyBodyGyroMag-std()`

### Steps to transform original data set to tidy data set

1. Read features' names and their ids. Store in a data frame with names feature_id and feature.
2. Read the measurements file, tidy it up by removing empty fields. Store the data in a data frame, label the columns with names same as features' data frame's feature column values.
3. Read the corresponding subject identifier file and column bind it to the measurements data frame.
4. Read the activities text file into a data frame, label its columns as activity_id and activity.
5. Column bind activity_id from activities data frame to measurements data frame.
6. Merge train and test data sets after transforming them using the above procedures.
7. Extract only mean and std measurements from the merged data frame.
8. Map the activity_id of the merged data frame to activity labels.
9. Modify the measurement labels to prefix 'aggr. mean'.
10. Export the data frame as a comma separated text file.
