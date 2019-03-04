# Project Code Book

This code book summarizes given data for the project, transformation done to it using run_analysis.R script and the resulting clean data in `tidy.txt`.

## Source of original data
Source of the original data: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

Original description: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

## Transformation done by run_analysis.R script
The attached R script (run_analysis.R) performs the following to clean up the data:

* Data from original source location is downloaded and stored in local disc.
* All training and test sets are read into local variables
* Training and test sets are then merged to create one data set
* Only the measurements on the mean and standard deviation were extracted for each measurement, and the others are discarded.
* Using the activity_labels.txt, activity identifiers are modified with descriptive names.
* Then the activity names are renamed with more descriptive names with below operations
** special characters are remove, like (,),-
** The initial f and t were expanded to frequencyDomain and timeDomain respectively.
** Acc, Gyro, Mag, Freq, mean, and std were replaced with Accelerometer, Gyroscope, Magnitude, Frequency, Mean, and StandardDeviation respectively.
** Replaced BodyBody with Body.
* The final data set was created with the average of each variable for each activity and each subject.
