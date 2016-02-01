
Code Book

This code book summarizes the run_analysis.R script for collecting and cleansing the Human Activity Recognition data Using Smartphones  

Script 1st loads 
data.table Package: Fast aggregation of large data, fast ordered joins, fast add/modify/delete of columns by group using no copies at all, list columns and a fast file reader (fread). Offers a natural and flexible syntax, for faster development.  
dplyr packages: A fast, consistent tool for working with data frame like objects, both in memory and out of memory.

Variables and descriptions:

featurevariables - reads List of all features from features.txt. 
activityLabels - reads Links the class labels with their activity name from activity_labels.txt 
subject_train, activityTrain, featuresTrain, subjectTest, activityTest, featuresTest - read train & test data X_train.txt & X_test.txt: Training set & Test set. X_train.txt & y_train.txt: Training labels & Test labels, subject_train & subjectTest are data related to person ID's. 
subject, activity,features - merge test and train data using row bind.
MergedFullData - combining all the subject, activity,features into one file using column bind. Which gives the full data set
colwithMeanSTD - picks all the columns which contaisn Mean and STD in variable names from the MergedFullData data file.
Neededcolumns - Adding subjectid, activityid columns from MergedFullData data set to colwithMeanSTD data set
AllMeanSTDData - selects all the Neededcolumns from MergedFullData. Which gives the measurements on the mean and standard deviation for each measurement.
WithActivity - merging  AllMeanSTDData with activityLabels inner join on activity_id  
Indtidydata - second independent tidy data set with the average of each variable for each activity and each subject.

Script step-by-step details
1) read supporting labels.
2) read train & test data subject_train-personid, activity - activitytype,featuresTrain-calculated readings. 
3) combinding both train and test data.
4) combining all the combining all the subject, activity,features into one file using column bind. Which gives the full data set
5) Extracts only the measurements on the mean and standard deviation for each measurement using grep on Mean and STD.
6) descriptive activity names to name the activities in the AllMeanSTDData data set from above step by merging AllMeanSTDData with activityLabels data on activityid column. 
7) Appropriately labels the data set with descriptive variable names with gsub function to perform replacement of respective matches.
8) creates a second, independent tidy data set with the Aggregate function on each variable for each activity and each subject.
9) Write the step 8 data set to IndepentTidy.txt file.   
