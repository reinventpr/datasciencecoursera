#######################################################################
##
## The data set for the project
## https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
##
##	Goal: create one R script called run_analysis.R that does the following. 
##	1. Merges the training and the test sets to create one data set.
##	2. Extracts only the measurements on the mean and standard deviation for each measurement. 
##	3. Uses descriptive activity names to name the activities in the data set
##	4. Appropriately labels the data set with descriptive variable names. 
##	5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
##


library(plyr)

# the files have been downloaded and unzip into ~/Downloads/UCI HAR Dataset
#	Set Working Directory


setwd("~/Downloads/UCI HAR Dataset/")

# read all the data files
activityLabels <- read.table("activity_labels.txt")
features <- read.table("features.txt")

trainSubject <- read.table("./train/subject_train.txt")
trainX <- read.table("./train/X_train.txt")
trainY <- read.table("./train/y_train.txt")

testSubject <- read.table("./test/subject_test.txt")
testX <- read.table("./test/X_test.txt")
testY <- read.table("./test/y_test.txt")

#	  1. Merge the training and the test data.
train <- cbind(trainY, trainSubject, trainX)
test <- cbind(testY, testSubject, testX)
mergedata<- rbind(train, test)

#	  Assign column names to the data above.
feature_names <- as.vector(features[[2]])
names(mergedata) <- c('activity', 'subject', feature_names)

# 	2. Extract the mean and standard deviation for each measurement
ms_data <- mergedata[, c('activity', 'subject', feature_names[grep('mean|std', feature_names)])]

# 	3. Uses descriptive activity names to name the activities in the data set
activity_names <- activityLabels[[2]]
ms_data$activity <- activity_names[ms_data$activity]

# 	4. Appropriately labels the data set with descriptive variable names
tidy_data <- aggregate(. ~ activity + subject, ms_data, FUN = mean)

#	5. Creates a second, independent tidy data set 
write.table(tidy_data, file="./tidy_data.txt", row.name = FALSE)
