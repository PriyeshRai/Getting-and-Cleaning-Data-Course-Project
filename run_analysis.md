# run_analysis, markdown version
This is the markdown version of the run_analysis.R script. It's here for convenience - it may be easier to look at this to get a feel for what's involved in this project before reading and running the script.

## Step 0: Read in the data
The dataset can been downloaded by running downloadData.R, which downloads and stores the data locally in the current directory's UCI HAR Dataset folder:

```r
if (!file.exists("UCI HAR Dataset")) downloadData()
We'll be using the following libraries to process the data. Using data.table instead of data.frames speeds up much of the processing of this large dataset:
```
```r
library(data.table)
library(reshape2)
```
```r
path <- file.path("./", "UCI HAR Dataset")
list.files(path, recursive = TRUE)
```
```r
##  [1] "activity_labels.txt"                         
##  [2] "features.txt"                                
##  [3] "features_info.txt"                           
##  [4] "README.txt"                                  
##  [5] "test/Inertial Signals/body_acc_x_test.txt"   
##  [6] "test/Inertial Signals/body_acc_y_test.txt"   
##  [7] "test/Inertial Signals/body_acc_z_test.txt"   
##  [8] "test/Inertial Signals/body_gyro_x_test.txt"  
##  [9] "test/Inertial Signals/body_gyro_y_test.txt"  
## [10] "test/Inertial Signals/body_gyro_z_test.txt"  
## [11] "test/Inertial Signals/total_acc_x_test.txt"  
## [12] "test/Inertial Signals/total_acc_y_test.txt"  
## [13] "test/Inertial Signals/total_acc_z_test.txt"  
## [14] "test/subject_test.txt"                       
## [15] "test/X_test.txt"                             
## [16] "test/y_test.txt"                             
## [17] "train/Inertial Signals/body_acc_x_train.txt" 
## [18] "train/Inertial Signals/body_acc_y_train.txt" 
## [19] "train/Inertial Signals/body_acc_z_train.txt" 
## [20] "train/Inertial Signals/body_gyro_x_train.txt"
## [21] "train/Inertial Signals/body_gyro_y_train.txt"
## [22] "train/Inertial Signals/body_gyro_z_train.txt"
## [23] "train/Inertial Signals/total_acc_x_train.txt"
## [24] "train/Inertial Signals/total_acc_y_train.txt"
## [25] "train/Inertial Signals/total_acc_z_train.txt"
## [26] "train/subject_train.txt"                     
## [27] "train/X_train.txt"                           
## [28] "train/y_train.txt"
```
```r
# READ TRAINING data-set
motion_train_df <- fread(file.path(path, "train", "X_train.txt"))
activity_label_train_df <- fread(file.path(path, "train", "y_train.txt"))
subject_train_df <- fread(file.path(path, "train", "subject_train.txt"))

# READ TEST data-set
motion_test_df <- fread(file.path(path, "test", "X_test.txt"))
activity_label_test_df <- fread(file.path(path, "test", "y_test.txt"))
subject_test_df <- fread(file.path(path, "test", "subject_test.txt"))
```

## Step 1: Merge the training and the test data-sets to create one data set.
```r
# COMBINE TEST and TRAIN data-set
motion_df <- rbind(motion_train_df, motion_test_df)

activity_label_df <- rbind(activity_label_train_df, activity_label_test_df)
setnames(activity_label_df, names(activity_label_df), "activity.number")

subject_df <- rbind(subject_train_df, subject_test_df)
setnames(subject_df, names(subject_df), "subject.number")

# COMBINE motion, subject and activity DATA to one DataFrame
df <- cbind(subject_df, activity_label_df)
df <- cbind(df, motion_df)
```
```r
dim(df)
```
```r
[1] 10299   563
```
number of observation : 10,2999
number of variables: 563

## Step 2. Extract only the measurements on the mean and standard deviation for each measurement.
The features.txt file lists the names of all features. From these names we will extract the ones that contain mean and std. We have 66 features that have either mean or std in their names.
```r
### READ the FEATURE variable names
feature_df <- fread(file.path(path, "features.txt"))
setnames(feature_df, names(feature_df), c("feature.number", "feature.name"))

feature_df <- feature_df[ grepl("mean\\(\\)|std\\(\\)", feature.name)]
dim(feature_df)
```
```r
[1] 66  3
```
Now, here's an important step: with each of these features we associate a feature.code that matches the column name in the "df" data frame:
```r
feature_df$feature.code <- feature_df[, paste0("V", feature.number)]
setkey(df, subject.number, activity.number)
tail(feature_df)
```
```r
   feature.number                feature.name feature.code
1:            516  fBodyBodyAccJerkMag-mean()         V516
2:            517   fBodyBodyAccJerkMag-std()         V517
3:            529     fBodyBodyGyroMag-mean()         V529
4:            530      fBodyBodyGyroMag-std()         V530
5:            542 fBodyBodyGyroJerkMag-mean()         V542
6:            543  fBodyBodyGyroJerkMag-std()         V543
```
Extracting only those columns that we need
```r
required_cols <- c(key(df), feature_df$feature.code)
result <- df[,required_cols, with = FALSE]
str(result)
```
```r
Classes ‘data.table’ and 'data.frame':	10299 obs. of  68 variables:
 $ subject.number : int  1 1 1 1 1 1 1 1 1 1 ...
 $ activity.number: int  1 1 1 1 1 1 1 1 1 1 ...
 $ V1             : num  0.282 0.256 0.255 0.343 0.276 ...
 $ V2             : num  -0.0377 -0.06455 0.00381 -0.01445 -0.02964 ...
 $ V3             : num  -0.1349 -0.0952 -0.1237 -0.1674 -0.1426 ...
 $ V4             : num  -0.328 -0.229 -0.275 -0.23 -0.227 ...
 $ V5             : num  -0.1372 0.0165 0.0131 0.1739 0.1643 ...
 $ V6             : num  -0.189 -0.26 -0.284 -0.213 -0.123 ...
 $ V41            : num  0.945 0.941 0.946 0.952 0.947 ...
 $ V42            : num  -0.246 -0.252 -0.264 -0.26 -0.257 ...
 $ V43            : num  -0.0322 -0.0329 -0.0256 -0.0261 -0.0284 ...
 $ V44            : num  -0.984 -0.984 -0.963 -0.981 -0.977 ...
 $ V45            : num  -0.929 -0.917 -0.956 -0.964 -0.989 ...
 $ V46            : num  -0.933 -0.949 -0.972 -0.964 -0.96 ...
 $ V81            : num  -0.156 -0.208 0.202 0.336 -0.236 ...
 $ V82            : num  -0.143 0.358 0.417 -0.464 -0.112 ...
 $ V83            : num  -0.11308 -0.4524 0.13908 -0.00503 0.17265 ...
 $ V84            : num  -0.184 -0.108 -0.178 -0.12 -0.192 ...
 $ V85            : num  -0.1705 -0.0187 -0.0296 0.0287 0.054 ...
 $ V86            : num  -0.614 -0.548 -0.58 -0.521 -0.469 ...
 $ V121           : num  -0.47973 0.09409 0.2112 0.09608 0.00874 ...
 $ V122           : num  0.082 -0.3092 -0.2729 -0.1634 0.0117 ...
 $ V123           : num  0.25644 0.08644 0.10199 0.02586 0.00417 ...
 $ V124           : num  -0.324 -0.399 -0.445 -0.36 -0.378 ...
 $ V125           : num  -0.1419 -0.0884 -0.0631 0.0423 0.1337 ...
 $ V126           : num  -0.457 -0.402 -0.347 -0.276 -0.308 ...
 $ V161           : num  0.0942 0.1667 -0.1632 -0.0546 -0.0757 ...
 $ V162           : num  -0.47621 -0.0338 -0.00556 0.34029 0.17147 ...
 $ V163           : num  -0.1421 -0.0893 -0.2316 -0.2697 0.1365 ...
 $ V164           : num  -0.346 -0.25 -0.264 -0.102 -0.129 ...
 $ V165           : num  -0.487 -0.454 -0.425 -0.243 -0.19 ...
 $ V166           : num  -0.422 -0.37 -0.343 -0.312 -0.418 ...
 $ V201           : num  -0.2246 -0.1265 -0.1601 -0.0735 -0.0495 ...
 $ V202           : num  -0.238 -0.213 -0.258 -0.195 -0.211 ...
 $ V214           : num  -0.2246 -0.1265 -0.1601 -0.0735 -0.0495 ...
 $ V215           : num  -0.238 -0.213 -0.258 -0.195 -0.211 ...
 $ V227           : num  -0.289 -0.139 -0.194 -0.129 -0.16 ...
 $ V228           : num  -0.165 -0.199 -0.22 -0.174 -0.15 ...
 $ V240           : num  -0.0344 -0.1409 -0.0946 -0.0493 -0.0214 ...
 $ V241           : num  -0.1682 -0.2161 -0.2908 -0.0901 -0.0446 ...
 $ V253           : num  -0.466 -0.39 -0.374 -0.236 -0.22 ...
 $ V254           : num  -0.434 -0.439 -0.418 -0.229 -0.213 ...
 $ V266           : num  -0.261 -0.151 -0.23 -0.151 -0.226 ...
 $ V267           : num  -0.1226 -0.029 0.0254 0.1953 0.1103 ...
 $ V268           : num  -0.331 -0.257 -0.377 -0.321 -0.205 ...
 $ V269           : num  -0.357 -0.262 -0.294 -0.263 -0.227 ...
 $ V270           : num  -0.1996 -0.0239 -0.0577 0.0879 0.1188 ...
 $ V271           : num  -0.178 -0.322 -0.29 -0.217 -0.146 ...
 $ V345           : num  -0.21 -0.178 -0.193 -0.183 -0.285 ...
 $ V346           : num  -0.2635 -0.1208 -0.1096 -0.026 -0.0111 ...
 $ V347           : num  -0.536 -0.499 -0.526 -0.487 -0.426 ...
 $ V348           : num  -0.228 -0.114 -0.236 -0.132 -0.169 ...
 $ V349           : num  -0.12427 0.02785 -0.00582 0.02037 0.05578 ...
 $ V350           : num  -0.698 -0.595 -0.633 -0.553 -0.51 ...
 $ V424           : num  -0.185 -0.205 -0.317 -0.162 -0.237 ...
 $ V425           : num  -0.198 -0.2458 -0.2082 0.0266 0.0472 ...
 $ V426           : num  -0.308 -0.311 -0.186 -0.18 -0.258 ...
 $ V427           : num  -0.368 -0.461 -0.486 -0.423 -0.422 ...
 $ V428           : num  -0.11505 -0.00984 0.00973 0.04465 0.17602 ...
 $ V429           : num  -0.565 -0.49 -0.469 -0.377 -0.389 ...
 $ V503           : num  -0.1668 -0.0793 -0.1563 -0.1044 -0.1232 ...
 $ V504           : num  -0.4 -0.423 -0.437 -0.376 -0.388 ...
 $ V516           : num  -0.154 -0.178 -0.149 -0.132 -0.116 ...
 $ V517           : num  -0.185 -0.231 -0.321 -0.233 -0.201 ...
 $ V529           : num  -0.22218 -0.26828 -0.30867 -0.06013 -0.00382 ...
 $ V530           : num  -0.274 -0.315 -0.401 -0.275 -0.246 ...
 $ V542           : num  -0.432 -0.428 -0.401 -0.218 -0.188 ...
 $ V543           : num  -0.476 -0.493 -0.482 -0.299 -0.3 ...
 - attr(*, ".internal.selfref")=<externalptr> 
 - attr(*, "sorted")= chr [1:2] "subject.number" "activity.number"
 ```
 
 ## Step 3. Use descriptive activity names to name the activities in the data set
 So far, our activity labels were some not-very-informative-to-the-initiated integers. We now set the more natural names for these labels. activity_labels.txt contains such 'natural' names:
 ```r
activity_name_df <- fread(file.path(path, "activity_labels.txt"))
setnames(activity_name_df, names(activity_name_df), c("activity.number", "activity.names"))
activity_name_df
```
```r
   activity.number     activity.names
1:               1            WALKING
2:               2   WALKING_UPSTAIRS
3:               3 WALKING_DOWNSTAIRS
4:               4            SITTING
5:               5           STANDING
6:               6             LAYING
```

## Step 4: Appropriately label the data set with descriptive activity names
Now we can merge the activity_name_df with the df data.frame by activity.number. We use reshape2 library to melt the dataset. Here is what the result looks like:
```r
dt <- data.table(melt(dt, key(dt), variable.name = "feature.code"))
dt <- merge(dt, feature_df[, c("feature.number", "feature.code", "feature.name")], by="feature.code", all.x = TRUE)
head(dt, n=10)
```
```r
    feature.code subject.number activity.number activity.names     value feature.number      feature.name
 1:           V1              1               1        WALKING 0.2820216              1 tBodyAcc-mean()-X
 2:           V1              1               1        WALKING 0.2558408              1 tBodyAcc-mean()-X
 3:           V1              1               1        WALKING 0.2548672              1 tBodyAcc-mean()-X
 4:           V1              1               1        WALKING 0.3433705              1 tBodyAcc-mean()-X
 5:           V1              1               1        WALKING 0.2762397              1 tBodyAcc-mean()-X
 6:           V1              1               1        WALKING 0.2554682              1 tBodyAcc-mean()-X
 7:           V1              1               1        WALKING 0.3211398              1 tBodyAcc-mean()-X
 8:           V1              1               1        WALKING 0.2346659              1 tBodyAcc-mean()-X
 9:           V1              1               1        WALKING 0.3126340              1 tBodyAcc-mean()-X
10:           V1              1               1        WALKING 0.2769154              1 tBodyAcc-mean()-X
```
```r
tail(dt, n=10)
```
```r
    feature.code subject.number activity.number activity.names      value feature.number         feature.name
 1:          V86             30               6         LAYING -0.9862202             86 tBodyAccJerk-std()-Z
 2:          V86             30               6         LAYING -0.9722861             86 tBodyAccJerk-std()-Z
 3:          V86             30               6         LAYING -0.9773967             86 tBodyAccJerk-std()-Z
 4:          V86             30               6         LAYING -0.9879726             86 tBodyAccJerk-std()-Z
 5:          V86             30               6         LAYING -0.9842890             86 tBodyAccJerk-std()-Z
 6:          V86             30               6         LAYING -0.9883015             86 tBodyAccJerk-std()-Z
 7:          V86             30               6         LAYING -0.9946520             86 tBodyAccJerk-std()-Z
 8:          V86             30               6         LAYING -0.9958571             86 tBodyAccJerk-std()-Z
 9:          V86             30               6         LAYING -0.9917411             86 tBodyAccJerk-std()-Z
10:          V86             30               6         LAYING -0.9902446             86 tBodyAccJerk-std()-Z
```

## Step 5: Create a second, independent tidy data set with the average of each variable for each activity and each subject.
Before computing the means, we will create a few variables based on the features. In particular, we will be selecting observations based on:
* whether the feature comes from the frequency or the time domain
* whether the feature was measured with the Accelerometer or the Gyroscope (which instrument)
* whether the acceleration is due to Gravity or Body
* whether the feature variable has "mean" or "std" in its name
* whether the feature variable has "Jerk" or "Mag" (magnitude) in its name
* whether it is an -X, -Y, or -Z spatial measurement
```r
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
```
```r
#------------------------------------------------------------------------------------------------------#
#-------------------------------FINALLY, CREATE THE TIDY DATASET---------------------------------------#
#------------------------------------------------------------------------------------------------------#
setkey(dt, subject.number, activity, Domain, Instrument, Acceleration, Jerk, Magnitude, Statistic, Axis)
tidy_dt <- dt[, list(count = .N, average = mean(value)), by = key(dt)]
head(tidy_dt)
```
```r
   subject.number activity Domain    Instrument Acceleration Jerk Magnitude Statistic Axis count     average
1:              1   LAYING   Time Accelerometer         Body <NA>      <NA>      Mean    X    50  0.22159824
2:              1   LAYING   Time Accelerometer         Body <NA>      <NA>      Mean    Y    50 -0.04051395
3:              1   LAYING   Time Accelerometer         Body <NA>      <NA>      Mean    Z    50 -0.11320355
4:              1   LAYING   Time Accelerometer         Body <NA>      <NA>        SD    X    50 -0.92805647
5:              1   LAYING   Time Accelerometer         Body <NA>      <NA>        SD    Y    50 -0.83682741
6:              1   LAYING   Time Accelerometer         Body <NA>      <NA>        SD    Z    50 -0.82606140
```
```r
#--------------------------- SAVE THE TIDY DATA -------------------------------------------------------#
fwrite(tidy_dt, "tidy_data.csv", sep = ",")
```
