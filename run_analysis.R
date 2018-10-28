## Read Test Data:
xtest <- read.table("UCI HAR Dataset/test/X_test.txt")
ytest <- read.table("UCI HAR Dataset/test/y_test.txt")
subjTest <- read.table("UCI HAR Dataset/test/subject_test.txt")

## Read Train Data:
xtrain <- read.table("UCI HAR Dataset/train/X_train.txt")
ytrain <- read.table("UCI HAR Dataset/train/y_train.txt")
subjTrain <- read.table("UCI HAR Dataset/train/subject_train.txt")

## Merge Test an Train Data:
x <- rbind(xtest, xtrain)
y <- rbind(ytest, ytrain)
subj <- rbind(subjTest, subjTrain)

## Read features and activity
features<-read.table("UCI HAR Dataset/features.txt")
activity<-read.table("UCI HAR Dataset/activity_labels.txt")

## Extract only mean and standard values
index <- grep("mean\\(\\)|std\\(\\)", features[,2])
x <- x[,index]

## Put activity names in dataset:
library(dplyr)
Ynamed <- left_join(y, activity, by = "V1")
y[,1] <- Ynamed[,2]

## Label data set
VARnames <- features[index,2]
names(x) <- VARnames
names(subj) <- "SubjectID"
names(y) <- "Activity"
tidydata <- cbind(subj, y, x)

## Average of each variable dataset
library(data.table)
tidydata <- data.table(tidydata)
tidyavg <- tidydata[, lapply(.SD, mean), by = 'SubjectID,Activity']
