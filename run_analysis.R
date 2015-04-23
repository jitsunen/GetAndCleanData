# Store the number of features for error checks
num.features <- 561

# function to read feature description file
read_description <- function(features_desc_file, col_names) {
  features <- read.table(features_desc_file, sep=" ", 
                         stringsAsFactors = F, strip.white=T)
  colnames(features) <- col_names
  features
}

# function to split lines, read from measurements files, by space character and strip empty fields.
# Also does error checking to ensure the number of fields match number of expected features.
tidy_line <- function(line)
{
  # split fields by space
  line.split <- unlist(strsplit(line, "\\s+"))
  # remove empty fields
  line.split <- line.split[line.split != ""]
  if ( length(line.split) != num.features)
  {
    stop(paste("number of fields don't match the expected, line = ", line.split))
  }
  # coerce to numeric
  list <- as.numeric(as.list(line.split))
  list
}

# read the feature description
features <- read_description("data/features.txt", c("feature_id", "feature"))

# function to read a measurements file and merge it with the corresponding subjects and activities files.
read_merge <- function(meas_file, subj_file, act_file)
{
  # read measurements file, tidy it up and apply labels
  lines <- readLines(meas_file)
  lines <- as.list(lines)
  lines <- sapply(lines, tidy_line)
  df <- t(as.data.frame(lines))
  colnames(df) <- features[, "feature"]  
  
  # read subjects and bind to measurements, assuming the measurements are in the same order as the subjects data
  subject_id <- as.numeric(as.list(readLines(subj_file)))
  df <- cbind(subject_id, df)
  
  # read activities and bind to measurements, assuming activities are in same order as measurements
  activity_id <- as.numeric(as.list(readLines(act_file)))
  df <- cbind(activity_id, df)
  
  # return matrix
  df
}


# Read the test data
test_data <- read_merge("data/X_test.txt", "data/subject_test.txt", "data/y_test.txt")
# Read the training data
train_data <- read_merge("data/X_train.txt", "data/subject_train.txt", "data/y_train.txt")
# Merge the test and training data
data.merged <- rbind(test_data, train_data)
# remove variables we don't need to free up some memory
rm(test_data)
rm(train_data)

# extract only mean and std measurements
mean_sd_features = features[grep("mean\\(\\)|std\\(\\)", features[, "feature"]), ][, "feature"]
data.merged.mean_std <- subset(data.merged, select = c("subject_id", "activity_id", mean_sd_features))

# remove original merged data
rm(data.merged)

# map activity id to activity labels
data.merged.mean_std <- as.data.frame(data.merged.mean_std)

# aggregate by subject id and activity id
data.merged.mean_std.by_subject_activity <- 
  aggregate(data.merged.mean_std, 
            by = list(data.merged.mean_std$subject_id, data.merged.mean_std$activity_id), 
            FUN=mean)

# add activity label
activity.labels <- 
  read_description("data/activity_labels.txt", c("activity_id", "activity"))
activity <- sapply(data.merged.mean_std.by_subject_activity$activity_id, 
                                         function(id) {subset(activity.labels, activity_id == id, 
                                                              select = c("activity"))[1, ]} )
data.merged.mean_std.by_subject_activity <- cbind(activity, data.merged.mean_std.by_subject_activity)

# drop unneeded columns
data.merged.mean_std.by_subject_activity$Group.1 <- NULL
data.merged.mean_std.by_subject_activity$Group.2 <- NULL
data.merged.mean_std.by_subject_activity$activity_id <- NULL

# Change column names of measurements to prefix "mean "
colnames(data.merged.mean_std.by_subject_activity) <- lapply(colnames(data.merged.mean_std.by_subject_activity), 
                                                      function(n) { if (n == "activity" | n == "subject_id") n 
                                                                    else paste("aggr. mean ", n, collapse = "")})

# write data to a file
write.table(data.merged.mean_std.by_subject_activity, file = "mean_by_subject_activity.txt", 
            col.names=T, row.names=F, fileEncoding="UTF-8", sep=",")