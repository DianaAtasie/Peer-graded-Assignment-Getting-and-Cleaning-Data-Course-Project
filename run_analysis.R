

# loading data ------------------------------------------------------------



feat <- read.table("features.txt", col.names = c("n","functions"))
activ <- read.table("activity_labels.txt", col.names = c("code", "activity"))
subtest <- read.table("subject_test.txt", col.names = "subject")
xtest <- read.table("X_test.txt", col.names = feat$functions)
ytest <- read.table("y_test.txt", col.names = "code")
subtrain <- read.table("subject_train.txt", col.names = "subject")
xtrain <- read.table("X_train.txt", col.names = feat$functions)
ytrain <- read.table("y_train.txt", col.names = "code")


# 1. Merges the training and the test sets to create one data set. -----------

sub<-rbind(subtest,subtrain)
totalx<-rbind(xtest,xtrain)
totaly<-rbind(ytest,ytrain)
total<-cbind(sub, totalx, totaly)
names(total)

# 2. Extracts only the measurements on the mean and standard deviation  for each measurement --------

library(dplyr)
data <- total %>% select(subject, code, contains("mean"), contains("std"))
head(data,1)
View(data)
# 3. Uses descriptive activity names to name the activities in the data set --------

x<-activ[,2]
x
data$code<-gsub("1",x[[1]], data$code)
data$code<-gsub("2",x[[2]], data$code)
data$code<-gsub("3",x[[3]], data$code)
data$code<-gsub("4",x[[4]], data$code)
data$code<-gsub("5",x[[5]], data$code)
data$code<-gsub("6",x[[6]], data$code)
View(data)

 
# 4. Appropriately labels the data set with descriptive variable names.
names(data)[2] = "activity"
names(data)<-gsub("Acc", "Accelerometer", names(data))
names(data)<-gsub("Gyro", "Gyroscope", names(data))
names(data)<-gsub("^f", "Frequency", names(data))
names(data)<-gsub("tBody", "TimeBody", names(data))
names(data)<-gsub("BodyBody", "Body", names(data))
names(data)<-gsub("Mag", "Magnitude", names(data))
names(data)<-gsub("^t", "Time", names(data))
names(data)<-gsub("angle", "Angle", names(data))
names(data)<-gsub("gravity", "Gravity", names(data))
names(data)<-gsub("-mean()", "Mean", names(data), ignore.case = TRUE)
names(data)<-gsub("-std()", "STD", names(data), ignore.case = TRUE)
names(data)<-gsub("-freq()", "Frequency", names(data), ignore.case = TRUE)
head(data,1)




# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


fdata <- data %>%group_by(subject, activity) %>%summarise_all(funs(mean))
write.table(fdata, "run_analysis.txt", row.name=FALSE)




