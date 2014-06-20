Code Book
========================================================

This code book contains:
- Information about the choices I made to create the tidy data set
- Information about the variables in the tidy data set


Choices I made to create the tidy data set:
-------------------------------------------

The first step is reading the data from the *UCI_HAR_DataSet* folder in the working directory.


```r
############################# READING ALL THE DATA ############################# 
# reading features and activity labels
features <- read.table("./features.txt") 
activity_labels <- read.table("./activity_labels.txt") 

### Reading Data from TEST files
test_features <- read.table("./test/X_test.txt") 
test_activity <- read.table("./test/Y_test.txt") 
test_subjects <- read.table("./test/subject_test.txt") 

### Reading Data from TRAIN files
train_features <- read.table("./train/X_train.txt") 
train_activity <- read.table("./train/Y_train.txt") 
train_subjects <- read.table("./train/subject_train.txt") 
```

The next step is treating data common to both test and train data sets: extract the variables for mean and standard deviation and give the names to the activity number and names variables.


```r
############################# DATA COMMON TO BOTH TEST AND TRAIN DATASETS ############################# 

# variable corresponding measurements on the mean and standard deviation
mean_std_names <- grepl("mean()", features[,2], fixed=T) | grepl("std()", features[,2], fixed=T)

# corresponding variable names
var_names <- features[,2][mean_std_names]

#giving variable names to activity_labels data frame
names(activity_labels) <- c("actNumber", "actName")
```



Next step is treating the Test Data. This step creates a data frame named **test_data**. Combine the subjects, activity and features in the same data frame and then merge with **activity_labels** data frame to obtain the activity label (*step 3: Uses descriptive activity names to name the activities in the data set*) Finally there is some treatment in variables names (*step 4: Appropriately labels the data set with descriptive variable names*).


```r
############################# TEST DATA ############################# 
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
```

Next step is making the same treatement to the Train Data.


```r
############################# TRAIN DATA ############################# 
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
```

Next step is combining the the test **test_data** and train **train_data** data frames.


```r
# Merges the training and the test sets to create one data set.
test_train_data <- rbind(test_data,train_data)
```

Finally the Tidy data set **test_train_data_mean** is created.


```r
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
```

```
## Warning: cannot open file './UCI_HAR_Dataset//tidy_data.txt': No such file
## or directory
```

```
## Error: cannot open the connection
```


Variables:
---------
There are 69 variables in the tidy data frame **test_train_data_mean**: *actNumber*: which is the activity number, *actName* which is the activity name, *subject* which represents the person that performs the activity. The other 66 variables are measurements on the mean and standard deviation for each measurement.

List of Variables:

```r
names(test_train_data_mean)
```

```
##  [1] "actNumber"                 "actName"                  
##  [3] "subjects"                  "tBodyAcc_meanX"           
##  [5] "tBodyAcc_meanY"            "tBodyAcc_meanZ"           
##  [7] "tBodyAcc_stdX"             "tBodyAcc_stdY"            
##  [9] "tBodyAcc_stdZ"             "tGravityAcc_meanX"        
## [11] "tGravityAcc_meanY"         "tGravityAcc_meanZ"        
## [13] "tGravityAcc_stdX"          "tGravityAcc_stdY"         
## [15] "tGravityAcc_stdZ"          "tBodyAccJerk_meanX"       
## [17] "tBodyAccJerk_meanY"        "tBodyAccJerk_meanZ"       
## [19] "tBodyAccJerk_stdX"         "tBodyAccJerk_stdY"        
## [21] "tBodyAccJerk_stdZ"         "tBodyGyro_meanX"          
## [23] "tBodyGyro_meanY"           "tBodyGyro_meanZ"          
## [25] "tBodyGyro_stdX"            "tBodyGyro_stdY"           
## [27] "tBodyGyro_stdZ"            "tBodyGyroJerk_meanX"      
## [29] "tBodyGyroJerk_meanY"       "tBodyGyroJerk_meanZ"      
## [31] "tBodyGyroJerk_stdX"        "tBodyGyroJerk_stdY"       
## [33] "tBodyGyroJerk_stdZ"        "tBodyAccMag_mean"         
## [35] "tBodyAccMag_std"           "tGravityAccMag_mean"      
## [37] "tGravityAccMag_std"        "tBodyAccJerkMag_mean"     
## [39] "tBodyAccJerkMag_std"       "tBodyGyroMag_mean"        
## [41] "tBodyGyroMag_std"          "tBodyGyroJerkMag_mean"    
## [43] "tBodyGyroJerkMag_std"      "fBodyAcc_meanX"           
## [45] "fBodyAcc_meanY"            "fBodyAcc_meanZ"           
## [47] "fBodyAcc_stdX"             "fBodyAcc_stdY"            
## [49] "fBodyAcc_stdZ"             "fBodyAccJerk_meanX"       
## [51] "fBodyAccJerk_meanY"        "fBodyAccJerk_meanZ"       
## [53] "fBodyAccJerk_stdX"         "fBodyAccJerk_stdY"        
## [55] "fBodyAccJerk_stdZ"         "fBodyGyro_meanX"          
## [57] "fBodyGyro_meanY"           "fBodyGyro_meanZ"          
## [59] "fBodyGyro_stdX"            "fBodyGyro_stdY"           
## [61] "fBodyGyro_stdZ"            "fBodyAccMag_mean"         
## [63] "fBodyAccMag_std"           "fBodyBodyAccJerkMag_mean" 
## [65] "fBodyBodyAccJerkMag_std"   "fBodyBodyGyroMag_mean"    
## [67] "fBodyBodyGyroMag_std"      "fBodyBodyGyroJerkMag_mean"
## [69] "fBodyBodyGyroJerkMag_std"
```

Structure of the tidy data set:

```r
str(test_train_data_mean)
```

```
## 'data.frame':	180 obs. of  69 variables:
##  $ actNumber                : Factor w/ 6 levels "1","2","3","4",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ actName                  : Factor w/ 6 levels "LAYING","SITTING",..: 4 4 4 4 4 4 4 4 4 4 ...
##  $ subjects                 : Factor w/ 30 levels "1","2","3","4",..: 1 2 3 4 5 6 7 8 9 10 ...
##  $ tBodyAcc_meanX           : num  0.277 0.276 0.276 0.279 0.278 ...
##  $ tBodyAcc_meanY           : num  -0.0174 -0.0186 -0.0172 -0.0148 -0.0173 ...
##  $ tBodyAcc_meanZ           : num  -0.111 -0.106 -0.113 -0.111 -0.108 ...
##  $ tBodyAcc_stdX            : num  -0.284 -0.424 -0.36 -0.441 -0.294 ...
##  $ tBodyAcc_stdY            : num  0.1145 -0.0781 -0.0699 -0.0788 0.0767 ...
##  $ tBodyAcc_stdZ            : num  -0.26 -0.425 -0.387 -0.586 -0.457 ...
##  $ tGravityAcc_meanX        : num  0.935 0.913 0.937 0.964 0.973 ...
##  $ tGravityAcc_meanY        : num  -0.2822 -0.3466 -0.262 -0.0859 -0.1004 ...
##  $ tGravityAcc_meanZ        : num  -0.0681 0.08473 -0.13811 0.12776 0.00248 ...
##  $ tGravityAcc_stdX         : num  -0.977 -0.973 -0.978 -0.984 -0.979 ...
##  $ tGravityAcc_stdY         : num  -0.971 -0.972 -0.962 -0.968 -0.962 ...
##  $ tGravityAcc_stdZ         : num  -0.948 -0.972 -0.952 -0.963 -0.965 ...
##  $ tBodyAccJerk_meanX       : num  0.074 0.0618 0.0815 0.0784 0.0846 ...
##  $ tBodyAccJerk_meanY       : num  0.02827 0.01825 0.01006 0.00296 -0.01632 ...
##  $ tBodyAccJerk_meanZ       : num  -4.17e-03 7.90e-03 -5.62e-03 -7.68e-04 8.32e-05 ...
##  $ tBodyAccJerk_stdX        : num  -0.114 -0.278 -0.269 -0.297 -0.303 ...
##  $ tBodyAccJerk_stdY        : num  0.067 -0.0166 -0.045 -0.2212 -0.091 ...
##  $ tBodyAccJerk_stdZ        : num  -0.503 -0.586 -0.529 -0.751 -0.613 ...
##  $ tBodyGyro_meanX          : num  -0.0418 -0.053 -0.0256 -0.0318 -0.0489 ...
##  $ tBodyGyro_meanY          : num  -0.0695 -0.0482 -0.0779 -0.0727 -0.069 ...
##  $ tBodyGyro_meanZ          : num  0.0849 0.0828 0.0813 0.0806 0.0815 ...
##  $ tBodyGyro_stdX           : num  -0.474 -0.562 -0.572 -0.501 -0.491 ...
##  $ tBodyGyro_stdY           : num  -0.0546 -0.5385 -0.5638 -0.6654 -0.5046 ...
##  $ tBodyGyro_stdZ           : num  -0.344 -0.481 -0.477 -0.663 -0.319 ...
##  $ tBodyGyroJerk_meanX      : num  -0.09 -0.0819 -0.0952 -0.1153 -0.0888 ...
##  $ tBodyGyroJerk_meanY      : num  -0.0398 -0.0538 -0.0388 -0.0393 -0.045 ...
##  $ tBodyGyroJerk_meanZ      : num  -0.0461 -0.0515 -0.0504 -0.0551 -0.0483 ...
##  $ tBodyGyroJerk_stdX       : num  -0.207 -0.39 -0.386 -0.492 -0.358 ...
##  $ tBodyGyroJerk_stdY       : num  -0.304 -0.634 -0.639 -0.807 -0.571 ...
##  $ tBodyGyroJerk_stdZ       : num  -0.404 -0.435 -0.537 -0.64 -0.158 ...
##  $ tBodyAccMag_mean         : num  -0.137 -0.29 -0.255 -0.312 -0.158 ...
##  $ tBodyAccMag_std          : num  -0.22 -0.423 -0.328 -0.528 -0.377 ...
##  $ tGravityAccMag_mean      : num  -0.137 -0.29 -0.255 -0.312 -0.158 ...
##  $ tGravityAccMag_std       : num  -0.22 -0.423 -0.328 -0.528 -0.377 ...
##  $ tBodyAccJerkMag_mean     : num  -0.141 -0.281 -0.28 -0.367 -0.288 ...
##  $ tBodyAccJerkMag_std      : num  -0.0745 -0.1642 -0.1399 -0.3169 -0.2822 ...
##  $ tBodyGyroMag_mean        : num  -0.161 -0.447 -0.466 -0.498 -0.356 ...
##  $ tBodyGyroMag_std         : num  -0.187 -0.553 -0.562 -0.553 -0.492 ...
##  $ tBodyGyroJerkMag_mean    : num  -0.299 -0.548 -0.566 -0.681 -0.445 ...
##  $ tBodyGyroJerkMag_std     : num  -0.325 -0.558 -0.567 -0.73 -0.489 ...
##  $ fBodyAcc_meanX           : num  -0.203 -0.346 -0.317 -0.427 -0.288 ...
##  $ fBodyAcc_meanY           : num  0.08971 -0.0219 -0.0813 -0.1494 0.00946 ...
##  $ fBodyAcc_meanZ           : num  -0.332 -0.454 -0.412 -0.631 -0.49 ...
##  $ fBodyAcc_stdX            : num  -0.319 -0.458 -0.379 -0.447 -0.298 ...
##  $ fBodyAcc_stdY            : num  0.056 -0.1692 -0.124 -0.1018 0.0426 ...
##  $ fBodyAcc_stdZ            : num  -0.28 -0.455 -0.423 -0.594 -0.483 ...
##  $ fBodyAccJerk_meanX       : num  -0.171 -0.305 -0.305 -0.359 -0.345 ...
##  $ fBodyAccJerk_meanY       : num  -0.0352 -0.0788 -0.1405 -0.2796 -0.1811 ...
##  $ fBodyAccJerk_meanZ       : num  -0.469 -0.555 -0.514 -0.729 -0.59 ...
##  $ fBodyAccJerk_stdX        : num  -0.134 -0.314 -0.297 -0.297 -0.321 ...
##  $ fBodyAccJerk_stdY        : num  0.10674 -0.01533 -0.00561 -0.2099 -0.05452 ...
##  $ fBodyAccJerk_stdZ        : num  -0.535 -0.616 -0.544 -0.772 -0.633 ...
##  $ fBodyGyro_meanX          : num  -0.339 -0.43 -0.438 -0.373 -0.373 ...
##  $ fBodyGyro_meanY          : num  -0.103 -0.555 -0.562 -0.688 -0.514 ...
##  $ fBodyGyro_meanZ          : num  -0.256 -0.397 -0.418 -0.601 -0.213 ...
##  $ fBodyGyro_stdX           : num  -0.517 -0.604 -0.615 -0.543 -0.529 ...
##  $ fBodyGyro_stdY           : num  -0.0335 -0.533 -0.5689 -0.6547 -0.5027 ...
##  $ fBodyGyro_stdZ           : num  -0.437 -0.56 -0.546 -0.716 -0.42 ...
##  $ fBodyAccMag_mean         : num  -0.129 -0.324 -0.29 -0.451 -0.305 ...
##  $ fBodyAccMag_std          : num  -0.398 -0.577 -0.456 -0.651 -0.52 ...
##  $ fBodyBodyAccJerkMag_mean : num  -0.0571 -0.1691 -0.1868 -0.3186 -0.2695 ...
##  $ fBodyBodyAccJerkMag_std  : num  -0.1035 -0.1641 -0.0899 -0.3205 -0.3057 ...
##  $ fBodyBodyGyroMag_mean    : num  -0.199 -0.531 -0.57 -0.609 -0.484 ...
##  $ fBodyBodyGyroMag_std     : num  -0.321 -0.652 -0.633 -0.594 -0.59 ...
##  $ fBodyBodyGyroJerkMag_mean: num  -0.319 -0.583 -0.608 -0.724 -0.548 ...
##  $ fBodyBodyGyroJerkMag_std : num  -0.382 -0.558 -0.549 -0.758 -0.456 ...
```
