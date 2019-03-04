library(dplyr)

if(!file.exists("./data")) {dir.create("./data")}
fileUrl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
if(!file.exists("./data/Dataset.zip")) {
  download.file(fileUrl,destfile = "./data/Dataset.zip")
}

dataDir<-"./data/UCI HAR Dataset"
if(!file.exists(dataDir)) {
  unzip("./data/Dataset.zip",exdir="./data")
}
list.files(dataDir,recursive = TRUE)
activities <- read.table(file.path(dataDir,"activity_labels.txt"))

trainingSubjects <- read.table(file.path(dataDir, "train", "subject_train.txt"))
trainingValues <- read.table(file.path(dataDir, "train", "X_train.txt"))
trainingActivity <- read.table(file.path(dataDir, "train", "y_train.txt"))

testSubjects <- read.table(file.path(dataDir, "test", "subject_test.txt"))
testValues <- read.table(file.path(dataDir, "test", "X_test.txt"))
testActivity <- read.table(file.path(dataDir, "test", "y_test.txt"))

features <- read.table(file.path(dataDir, "features.txt"), as.is = TRUE)

colnames(activities) <- c("activityId", "activityLabel")

#Merges the training and the test sets to create one data set.
# concatenate individual data tables
humanActivity <- rbind(
  cbind(trainingSubjects, trainingValues, trainingActivity),
  cbind(testSubjects, testValues, testActivity)
)

# remove individual data tables to save memory
rm(trainingSubjects, trainingValues, trainingActivity, 
   testSubjects, testValues, testActivity)

# assign column names
colnames(humanActivity) <- c("subject", features[, 2], "activity")

#Extracts only the measurements on the mean and standard deviation for each measurement.
# determine columns of data set to keep based on column name...
columnsToKeep <- grepl("subject|activity|mean|std", colnames(humanActivity))

# ... and keep data in these columns only
humanActivity <- humanActivity[, columnsToKeep]


#Uses descriptive activity names to name the activities in the data set

# replace activity values with named factor levels
humanActivity$activity <- factor(humanActivity$activity, 
                                 levels = activities[, 1], labels = activities[, 2])



#Appropriately labels the data set with descriptive variable names.
# get column names
humanActivityCols <- colnames(humanActivity)

# remove special characters
humanActivityCols <- gsub("[\\(\\)-]", "", humanActivityCols)

# expand abbreviations and clean up names
humanActivityCols <- gsub("^f", "frequencyDomain", humanActivityCols)
humanActivityCols <- gsub("^t", "timeDomain", humanActivityCols)
humanActivityCols <- gsub("Acc", "Accelerometer", humanActivityCols)
humanActivityCols <- gsub("Gyro", "Gyroscope", humanActivityCols)
humanActivityCols <- gsub("Mag", "Magnitude", humanActivityCols)
humanActivityCols <- gsub("Freq", "Frequency", humanActivityCols)
humanActivityCols <- gsub("mean", "Mean", humanActivityCols)
humanActivityCols <- gsub("std", "StandardDeviation", humanActivityCols)

# correct typo
humanActivityCols <- gsub("BodyBody", "Body", humanActivityCols)

# use new labels as column names
colnames(humanActivity) <- humanActivityCols

#From the data set in step 4, creates a second, independent tidy data set with the average of each variable 
#for each activity and each subject.

# group by subject and activity and summarise using mean
humanActivityMeans <- humanActivity %>% 
  group_by(subject, activity) %>%
  summarise_each(funs(mean))

# output to file "tidy_data.txt"
write.table(humanActivityMeans, "tidy_data.txt", row.names = FALSE, 
            quote = FALSE)