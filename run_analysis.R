############################# READING ALL THE DATA ############################# 
# reading features and activity labels
features <- read.table("./UCI_HAR_Dataset/features.txt") 
activity_labels <- read.table("./UCI_HAR_Dataset/activity_labels.txt") 

### Reading Data from TEST files
test_features <- read.table("./UCI_HAR_Dataset/test/X_test.txt") 
test_activity <- read.table("./UCI_HAR_Dataset/test/Y_test.txt") 
test_subjects <- read.table("./UCI_HAR_Dataset/test/subject_test.txt") 

### Reading Data from TRAIN files
train_features <- read.table("./UCI_HAR_Dataset/train/X_train.txt") 
train_activity <- read.table("./UCI_HAR_Dataset/train/Y_train.txt") 
train_subjects <- read.table("./UCI_HAR_Dataset/train/subject_train.txt") 


############################# DATA COMMON TO BOTH TEST AND TRAIN DATASETS############################# 

# variable corresponding measurements on the mean and standard deviation
mean_std_names <- grepl("mean()", features[,2], fixed=T) | grepl("std()", features[,2], fixed=T)

# corresponding variable names
var_names <- features[,2][mean_std_names]

#giving variable names to activity_labels data frame
names(activity_labels) <- c("actNumber", "actName")


############################# TEST DATA ############################# 

### Making some treatment in the TEST dataset

# combining the test data set with siubject and activity
test_data <- cbind(test_subjects, test_activity, test_features[,mean_std_names])

# adding the variable names
names(test_data) <- c("subjects", "actNumber", as.character(var_names))

# adding activity label
test_data <- merge(activity_labels, test_data, by.x="actNumber", by.y="actNumber", all=TRUE)

# making some treatement in variable names
names(test_data) <- sub ("-", "_", names(test_data))
names(test_data) <- sub ("\\(", "", names(test_data))
names(test_data) <- sub (")", "", names(test_data))
names(test_data) <- sub ("-", "", names(test_data))


############################# TRAIN DATA ############################# 

### Making some treatment in the TRAIN dataset

# combining the test data set with siubject and activity
train_data <- cbind(train_subjects, train_activity, train_features[,mean_std_names])

# adding the variable names
names(train_data) <- c("subjects", "actNumber", as.character(var_names))

# adding activity label
train_data <- merge(activity_labels, train_data, by.x="actNumber", by.y="actNumber", all=TRUE)

# making some treatement in variable names
names(train_data) <- sub ("-", "_", names(train_data))
names(train_data) <- sub ("\\(", "", names(train_data))
names(train_data) <- sub (")", "", names(train_data))
names(train_data) <- sub ("-", "", names(train_data))


# Merges the training and the test sets to create one data set.
test_train_data <- rbind(test_data,train_data)


############################# TIDY DATA SET############################# 
# tidy data set with the average of each variable for each activity and each subject. 

# libraries for reshape and summmarize data
library(reshape2) 
library(plyr)

#transform the actNumber and subjects columns into factor
test_train_data <- transform(test_train_data, actNumber = factor(actNumber), subjects = factor(subjects))

# melting and summarize the data
melt_data <- melt(test_train_data, id=c("actNumber","actName", "subjects"), measures.vars=names)
melt_data_mean <- ddply(melt_data, .(actNumber, actName, subjects, variable), summarize, value=mean(value))

# reshape the data frame to the original shape
test_train_data_mean <- dcast(melt_data_mean, actNumber+actName+subjects~variable)

# write the tidy data frame to a file
write.table(test_train_data_mean, "./UCI_HAR_Dataset//tidy_data.txt", sep=";")

