library(dplyr)

#Reading features
features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))

#Reading Activities
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))

#Reading Subject
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")

#Reading test data
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")


#Reading train data
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")


#Merging the Data.
merged_data <- cbind(rbind(subject_train, subject_test), rbind(y_train, y_test), rbind(x_train, x_test))

#Extracting the measurements on the mean and standard deviation for each measurement.
extracted_data <- merged_data %>% select(subject, code, contains("mean"), contains("std"))


#Assigning activity names
extracted_data$code <- activity_labels[extracted_data$code, 2]


#Assigning descriptive variable names.
names(extracted_data)[2] = "Activity"
names(extracted_data)<-gsub("tBody", "TimeBody", names(extracted_data))
names(extracted_data)<-gsub("^t", "Time", names(extracted_data))
names(extracted_data)<-gsub("^f", "Frequency", names(extracted_data))
names(extracted_data)<-gsub("-mean()", "Mean", names(extracted_data), ignore.case = TRUE)
names(extracted_data)<-gsub("-std()", "STD", names(extracted_data), ignore.case = TRUE)
names(extracted_data)<-gsub("-freq()", "Frequency", names(extracted_data), ignore.case = TRUE)


#Data set with the average of each variable for each activity and each subject.
extracted_data_2 <- extracted_data %>%
  group_by(subject, Activity) %>%
  summarise_all(funs(mean))
write.table(extracted_data_2, "tidy_data.txt", row.name=FALSE)

