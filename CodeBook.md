# Codebook
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

` TIDY <- read.csv("TIDY_HumanActivity.csv", header = FALSE) `
` head(TIDY, n = 30) `
