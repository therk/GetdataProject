# download and unzip the data if it doesn't exisit
if (!file.exists("UCI HAR Dataset")) {
  download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", "Dataset.zip", "curl")
  unzip("Dataset.zip")
}

# Load all the data
activity_lables <- read.table("./UCI HAR Dataset/activity_labels.txt")
features <- read.table("./UCI HAR Dataset/features.txt")
train.x <- read.table("./UCI HAR Dataset/train/X_train.txt")
train.y <- read.table("./UCI HAR Dataset/train/y_train.txt")
train.subject <- read.table("./UCI HAR Dataset/train/subject_train.txt")
test.x <- read.table("./UCI HAR Dataset/test/X_test.txt")
test.y <- read.table("./UCI HAR Dataset/test/y_test.txt")
test.subject <- read.table("./UCI HAR Dataset/test/subject_test.txt")

# Merge the training and the test sets to create one data set
merged.measurements <- rbind(train.x, test.x)
merged.activityId <- rbind(test.y, train.y)
merged.subject <- data.frame(rbind(test.subject, train.subject))

# Uses descriptive activity names to name the activities in the data set
merged.activity <- data.frame(merge(merged.activityId, activity_lables, by=1)[,2])

# Appropriately label the data set with descriptive variable names
colnames(merged.measurements) <- features[, 2]
colnames(merged.activity) <- "Activity"
colnames(merged.subject) <- "Subject"

# Extract only the measurements on the mean and standard deviation for each measurement
mean.columns <- grep("-mean()", colnames(merged.measurements), fixed=TRUE)
std.columns <-grep("-std()", colnames(merged.measurements), fixed=TRUE)

measurements <- merged.measurements[c(mean.columns, std.columns)]

# Creates an independent tidy data set with the average of each variable 
# for each activity and each subject
data <- cbind(merged.activity, merged.subject, measurements)
tidyData <- aggregate(mergedData, by=list(Activity = data$Activity, Subject=data$Subject), mean)

write.table(tidyData, file = "tidyData.txt", row.name=FALSE)
