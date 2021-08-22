<h1 align="center">Codebook</h1>

## Variables in the tidy dataset
The cleaned dataset contains 11,880 observations of 11 variables and is saved in csv (tidy_data.csv) formats.

run_analysis.md or run_analysis.R contain details on dataset creation.

## Variable list and descriptions
| Variable name	| Description |
| ------------- | ----------- |
| subject.number	| Subject ID (1,2, ..., 30 - 30 subjects in total) |
| activity	| Activity name ( WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING 6 activities in total) |
| Domain |	Time domain or Frequency domain signal (Time or Freq) |
| Instrument |	Instrument that measured the signal (Accelerometer or Gyroscope) |
| Acceleration |	Acceleration signal (Body or Gravity) |
| Jerk |	Jerk signal |
| Magnitude |	Magnitude of the signals |
| Statistic |	Mean or Standard Deviation (Mean, STD) |
| Axis |	3-axial signals in the X, Y and Z directions (X, Y, or Z) |
| count	| Number of data points used to compute average |
| average |	Average of each variable for each activity and each subject |

## TIDY data
The first few observations of the TIDY dataset are prented below. The structure of the data is also shown:

```r 
tidy <- read.csv("tidy_data.csv", header = FALSE) 
head(TIDY, n = 30) 
```
```r
  subject.number activity Domain    Instrument Acceleration Jerk Magnitude Statistic Axis count      average
1               1   LAYING   Time Accelerometer         Body <NA>      <NA>      Mean    X    50  0.221598244
2               1   LAYING   Time Accelerometer         Body <NA>      <NA>      Mean    Y    50 -0.040513953
3               1   LAYING   Time Accelerometer         Body <NA>      <NA>      Mean    Z    50 -0.113203554
4               1   LAYING   Time Accelerometer         Body <NA>      <NA>        SD    X    50 -0.928056469
5               1   LAYING   Time Accelerometer         Body <NA>      <NA>        SD    Y    50 -0.836827406
6               1   LAYING   Time Accelerometer         Body <NA>      <NA>        SD    Z    50 -0.826061402
7               1   LAYING   Time Accelerometer         Body <NA> Magnitude      Mean <NA>    50 -0.841929152
8               1   LAYING   Time Accelerometer         Body <NA> Magnitude        SD <NA>    50 -0.795144864
9               1   LAYING   Time Accelerometer         Body Jerk      <NA>      Mean    X    50  0.081086534
10              1   LAYING   Time Accelerometer         Body Jerk      <NA>      Mean    Y    50  0.003838204
```

## The structure of the data
```r
str(tidy)
```
```r
Classes ‘data.table’ and 'data.frame':	11880 obs. of  11 variables:
 $ subject.number: int  1 1 1 1 1 1 1 1 1 1 ...
 $ activity      : Factor w/ 6 levels "LAYING","SITTING",..: 1 1 1 1 1 1 1 1 1 1 ...
 $ Domain        : Factor w/ 2 levels "Time","Freq": 1 1 1 1 1 1 1 1 1 1 ...
 $ Instrument    : Factor w/ 2 levels "Accelerometer",..: 1 1 1 1 1 1 1 1 1 1 ...
 $ Acceleration  : Factor w/ 3 levels NA,"Body","Gravity": 2 2 2 2 2 2 2 2 2 2 ...
 $ Jerk          : Factor w/ 2 levels NA,"Jerk": 1 1 1 1 1 1 1 1 2 2 ...
 $ Magnitude     : Factor w/ 2 levels NA,"Magnitude": 1 1 1 1 1 1 2 2 1 1 ...
 $ Statistic     : Factor w/ 2 levels "Mean","SD": 1 1 1 2 2 2 1 2 1 1 ...
 $ Axis          : Factor w/ 4 levels NA,"X","Y","Z": 2 3 4 2 3 4 1 1 2 3 ...
 $ count         : int  50 50 50 50 50 50 50 50 50 50 ...
 $ average       : num  0.2216 -0.0405 -0.1132 -0.9281 -0.8368 ...
 - attr(*, "sorted")= chr [1:9] "subject.number" "activity" "Domain" "Instrument" ...
 - attr(*, ".internal.selfref")=<externalptr>
```
