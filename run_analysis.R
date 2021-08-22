library(data.table)
library(reshape2)

path <- file.path("./", "UCI HAR Dataset")
list.files(path, recursive = TRUE)

# READ TRAINING data-set
motion_train_df <- fread(file.path(path, "train", "X_train.txt"))
activity_label_train_df <- fread(file.path(path, "train", "y_train.txt"))
subject_train_df <- fread(file.path(path, "train", "subject_train.txt"))

# READ TEST data-set
motion_test_df <- fread(file.path(path, "test", "X_test.txt"))
activity_label_test_df <- fread(file.path(path, "test", "y_test.txt"))
subject_test_df <- fread(file.path(path, "test", "subject_test.txt"))

# COMBINE TEST and TRAIN data-set
motion_df <- rbind(motion_train_df, motion_test_df)

activity_label_df <- rbind(activity_label_train_df, activity_label_test_df)
setnames(activity_label_df, names(activity_label_df), "activity.number")

subject_df <- rbind(subject_train_df, subject_test_df)
setnames(subject_df, names(subject_df), "subject.number")

# COMBINE motion, subject and activity DATA to one DataFrame
df <- cbind(subject_df, activity_label_df)
df <- cbind(df, motion_df)

# GET THE COLUMNS WE REQUIRE
### READ the FEATURE variable names
feature_df <- fread(file.path(path, "features.txt"))
setnames(feature_df, names(feature_df), c("feature.number", "feature.name"))

feature_df <- feature_df[ grepl("mean\\(\\)|std\\(\\)", feature.name)]

feature_df$feature.code <- feature_df[, paste0("V", feature.number)]
setkey(df, subject.number, activity.number)

required_cols <- c(key(df), feature_df$feature.code)
result <- df[,required_cols, with = FALSE]

# REPLACING ACTIVITY NUMBER WITH ACTIVITY NAME
activity_name_df <- fread(file.path(path, "activity_labels.txt"))
setnames(activity_name_df, names(activity_name_df), c("activity.number", "activity.names"))

dt <- merge(result, activity_name_df, by = "activity.number", x.all = TRUE)
setkey(dt, subject.number, activity.number, activity.names)

dt <- data.table(melt(dt, key(dt), variable.name = "feature.code"))
dt <- merge(dt, feature_df[, c("feature.number", "feature.code", "feature.name")], by="feature.code", all.x = TRUE)

#--------------------------------------------------------------------------------------------------------#
### First, make `feature_name` and `activity_name` factors:
dt[,`:=`(feature, factor(dt$feature.name))]
dt[,`:=`(activity, factor(dt$activity.name))]
#### 1: Is the feature from the Time domain or the Frequency domain?
levels <- matrix(1:2, nrow = 2)
logical <- matrix(c(grepl("=^t", dt$feature), grepl("^f", dt$feature)), ncol = 2)
dt$Domain <- factor(logical %*% levels, labels = c("Time", "Freq"))

#### 2: Was the feature measured on Accelerometer or Gyroscope?
levels <- matrix(1:2, nrow=2)
logical <- matrix(c(grepl("Acc", dt$feature), grepl("Gyro", dt$feature)), ncol=2)
dt$Instrument <- factor(logical %*% levels, labels = c("Accelerometer", "Gyroscope"))

#### 3: Was the Acceleration due to Gravity or Body (other force) ?
levels <- matrix(1:2, nrow=2)
logical <- matrix(c(grepl("BodyAcc", dt$feature), grepl("GravityAcc", dt$feature)), ncol=2)
dt$Acceleration <- factor(logical %*% levels, labels = c(NA, "Body", "Gravity"))

#### 4: The statistics - mean and std?
logical <- matrix(c(grepl("mean()", dt$feature), grepl("std()", dt$feature)), ncol = 2)
dt$Statistic <- factor(logical %*% levels, labels = c("Mean", "SD"))

#### 5, 6: Features on One category - 'Jerk', 'Magnitude'
dt$Jerk <- factor(grepl("Jerk", dt$feature), labels = c(NA, "Jerk"))
dt$Magnitude <- factor(grepl("Mag", dt$feature), labels = c(NA, "Magnitude"))

#### 7 Axial variables, 3-D:
levels <- matrix(1:3, 3)
logical <- matrix(c(grepl("-X", dt$feature), grepl("-Y", dt$feature), grepl("-Z", dt$feature)), ncol=3)
dt$Axis <- factor(logical %*% levels, labels = c(NA, "X", "Y", "Z"))

#------------------------------------------------------------------------------------------------------#
#-------------------------------FINALLY, CREATE THE TIDY DATASET---------------------------------------#
#------------------------------------------------------------------------------------------------------#
setkey(dt, subject.number, activity, Domain, Instrument, Acceleration, Jerk, Magnitude, Statistic, Axis)
tidy_dt <- dt[, list(count = .N, average = mean(value)), by = key(dt)]

fwrite(tidy_dt, "tidy_data.csv", sep = ",")

tidy <- read.csv("tidy_data.csv")
