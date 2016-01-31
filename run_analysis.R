library(data.table)
library(dplyr)

##read supporting labels
featurevariables <- read.table("UCI HAR Dataset/features.txt")
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt", header = FALSE)
colnames(activityLabels) <- c("Activityid","Activity")

##read train & test data subject_train-personid, activity - activitytype,featuresTrain-calculated readings  
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", header = FALSE)
activityTrain <- read.table("UCI HAR Dataset/train/y_train.txt", header = FALSE)
featuresTrain <- read.table("UCI HAR Dataset/train/X_train.txt", header = FALSE)

subjectTest <- read.table("UCI HAR Dataset/test/subject_test.txt", header = FALSE)
activityTest <- read.table("UCI HAR Dataset/test/y_test.txt", header = FALSE)
featuresTest <- read.table("UCI HAR Dataset/test/X_test.txt", header = FALSE)

#1. merge test and train data
##combinding both data
subject <- rbind(subject_train,subjectTest)
activity <- rbind(activityTrain,activityTest)
features <- rbind(featuresTrain,featuresTest)

##naming columns
colnames(features) <- t(featurevariables[2])
colnames(subject) <- "Subjectid"
colnames(activity) <- "Activityid"

##full data set
MergedFullData <- cbind(features,activity,subject)

##2. Extracts only the measurements on the mean and standard deviation for each measurement

colwithMeanSTD <- grep(".*Mean.*|.*Std.*", names(MergedFullData), ignore.case=TRUE)

Neededcolumns <- c(colwithMeanSTD, 562, 563)

AllMeanSTDData <- MergedFullData[,Neededcolumns]

## 3. descriptive activity names to name the activities in the data set

##for AllMeanSTDData data set
WithActivity <- merge(AllMeanSTDData,activityLabels)

AllMeanSTDData <- select(WithActivity , -Activityid)

## 4. Appropriately labels the data set with descriptive variable names.

names(AllMeanSTDData)<-gsub("Acc", "Accelerometer", names(AllMeanSTDData))
names(AllMeanSTDData)<-gsub("Gyro", "Gyroscope", names(AllMeanSTDData))
names(AllMeanSTDData)<-gsub("BodyBody", "Body", names(AllMeanSTDData))
names(AllMeanSTDData)<-gsub("Mag", "Magnitude", names(AllMeanSTDData))
names(AllMeanSTDData)<-gsub("^t", "Time", names(AllMeanSTDData))
names(AllMeanSTDData)<-gsub("^f", "Frequency", names(AllMeanSTDData))
names(AllMeanSTDData)<-gsub("tBody", "TimeBody", names(AllMeanSTDData))
names(AllMeanSTDData)<-gsub("-mean()", "Mean", names(AllMeanSTDData), ignore.case = TRUE)
names(AllMeanSTDData)<-gsub("-std()", "STD", names(AllMeanSTDData), ignore.case = TRUE)
names(AllMeanSTDData)<-gsub("-freq()", "Frequency", names(AllMeanSTDData), ignore.case = TRUE)
names(AllMeanSTDData)<-gsub("angle", "Angle", names(AllMeanSTDData))
names(AllMeanSTDData)<-gsub("gravity", "Gravity", names(AllMeanSTDData))

## 4. From the data set in step 4, creates a second, independent tidy data set with the average 
##of each variable for each activity and each subject.

Indtidydata <- aggregate(. ~Subjectid + Activity, AllMeanSTDData, mean)
Indtidydata <- arrange(Indtidydata,Subjectid,Activity)

write.table(Indtidydata, file = "IndepentTidy.txt", row.names = FALSE)
