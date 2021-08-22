<h1 align="center">Codebook</h1>

## Variables in the tidy dataset
The cleaned dataset contains 11,881 observations of 11 variables and is saved in both text (TIDY_HumanActivity.txt) and csv (TIDY_HumanActivity.csv) formats.

run_analysis.md or run_analysis.R contain details on dataset creation.

## Variable list and descriptions
| Variable name	| Description |
| ------------- | ----------- |
| subject	| Subject ID (1,2, ..., 30 - 30 subjects in total) |
| activity	| Activity name ( WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING 6 activities in total) |
| Domain |	Time domain or Frequency domain signal (Time or Freq) |
| Instrument |	Instrument that measured the signal (Accelerometer or Gyroscope) |
| Acceleration |	Acceleration signal (Body or Gravity) |
| Statistic |	Mean or Standard Deviation (Mean, STD) |
| Jerk |	Jerk signal |
| Magnitude |	Magnitude of the signals |
| Axis |	3-axial signals in the X, Y and Z directions (X, Y, or Z) |
| Count	| Number of data points used to compute average |
|Average |	Average of each variable for each activity and each subject |

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
