
library(reshape2)

filename <- "getdata_dataset.zip"

fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
download.file(fileURL, filename, method="curl")
 
if (!file.exists("UCI HAR Dataset")) { 
        unzip(filename) 
}

activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt")
activityLabels[,2] <- as.character(activityLabels[,2])
features <- read.table("UCI HAR Dataset/features.txt")
features[,2] <- as.character(features[,2])


featuresTargeted <- grep(".*mean.*|.*std.*", features[,2])
featuresTargeted.names <- features[featuresTargeted,2]
featuresTargeted.names = gsub('-mean', 'Mean', featuresTargeted.names)
featuresTargeted.names = gsub('-std', 'Std', featuresTargeted.names)
featuresTargeted.names <- gsub('[-()]', '', featuresTargeted.names)

train <- read.table("UCI HAR Dataset/train/X_train.txt")[featuresTargeted]
trainActivities <- read.table("UCI HAR Dataset/train/Y_train.txt")
trainSubjects <- read.table("UCI HAR Dataset/train/subject_train.txt")
train <- cbind(trainSubjects, trainActivities, train)

test <- read.table("UCI HAR Dataset/test/X_test.txt")[featuresWanted]
testActivities <- read.table("UCI HAR Dataset/test/Y_test.txt")
testSubjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
test <- cbind(testSubjects, testActivities, test)


MergeData_Mor<- rbind(train, test)
colnames(MergeData_Mor) <- c("subject", "activity", featuresTargeted.names)


MergeData_Mor$activity <- factor(MergeData_Mor$activity, levels = activityLabels[,1], labels = activityLabels[,2])
MergeData_Mor$subject <- as.factor(MergeData_Mor$subject)

MergeData.f <- melt(MergeData_Mor, id = c("subject", "activity"))
MergeData.mean <- dcast(MergeData.f, subject + activity ~ variable, mean)
write.table(MergeData.mean, "tidy.txt", row.names = FALSE, quote = FALSE)
