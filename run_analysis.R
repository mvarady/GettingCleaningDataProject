## Load modules
library(dplyr)
library(reshape2)

## Read data 
actLabels <- read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/activity_labels.txt")
features <- read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/features.txt")

Xtest <- read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/X_test.txt")
Ytest <- read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/y_test.txt")
Subtest <- read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/subject_test.txt")

Xtrain <- read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/X_train.txt")
Ytrain <- read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/y_train.txt")
Subtrain <- read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/subject_train.txt")

## Extract variable names
names(Subtest) <- "Subject"
names(Subtrain) <- "Subject"
names(Ytest) <- "Activity"
names(Ytrain) <- "Activity"

## Retain only mean and std_dev of measurements
idx <- grepl("mean|std",features[,2])
Xtest <- Xtest[,idx]
Xtrain <- Xtrain[,idx]

## Get descriptive variable names
names(Xtest) <- gsub("(-|[()])","",tolower(features[idx,2]))
names(Xtrain) <- gsub("(-|[()])","",tolower(features[idx,2]))

## Add subject and activity variables to accel and groscope data
TestData <- cbind(Subtest,Ytest,Xtest)
TrainData <- cbind(Subtrain,Ytrain,Xtrain)

## Combine Training and Test data
AllData <- rbind(TestData,TrainData)

## Use descriptive activity names in data frame
AllData$Activity <- actLabels$V2[AllData$Activity]

## Average data for each activity for each subject
meltAllData <- melt(AllData,id.vars = c("Subject","Activity"))
SummData <- dcast(meltAllData,Subject + Activity~variable,mean)