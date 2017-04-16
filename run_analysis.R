##Unzip the file containing the data sets
##Set your working directory to the extracted folder "UCI HAR Dataset"

## The following line is used to get the path to the working directory ("UCI HAR Dataset")
datafolder<-getwd()

## Read the features.txt file in the UCI HAR Dataset folder, this file cointains the variable names
variables<-read.table(paste0(datafolder,"/features.txt"))
variablenames<-as.character(variables[,2])
variablenames<-as.list(variablenames) ##convert to list to use lapply next
## Remove special characters from variable names
variablenames<-lapply(variablenames,sub,pattern="()",replacement="",fixed=TRUE)
variablenames<-lapply(variablenames,gsub,pattern="-",replacement="",fixed=TRUE)
variablenames<-unlist(variablenames) ##transform back to character vector

##Read activity labels file in the UCI HAR Dataset folder
activity_labels<-read.table(paste0(datafolder,"/activity_labels.txt"),col.names=c("level","activity"))

#Remove "_" form the activity lables
activity_labels$activity<-gsub("_","",activity_labels$activity)


##Read files in 'test' folder
# Read subject_test file, and create a descriptive variable name =subject
subject_test<-read.table(paste0(datafolder,"/test/subject_test.txt"),col.names=c("subject"))

# Read y_test file, and create a descriptive variable name =activity
activity_test<-read.table(paste0(datafolder,"/test/y_test.txt"),col.names=c("activity")) 

# Read X_test file, and include unique/descriptive variable names extracted from features.txt file 
data_test<-read.table(paste0(datafolder,"/test/X_test.txt"),col.names=variablenames)

#Merge all test tables
testtable<-cbind(subject_test,activity_test,data_test)

## Read the files in the 'train' folder
# Read subject_test file, and create a descriptive variable name =subject, sames as variable name in test table
subject_train<-read.table(paste0(datafolder,"/train/subject_train.txt"),col.names=c("subject"))

# Read y_train file, and create a descriptive variable name =activity,sames as variable name in test table
activity_train<-read.table(paste0(datafolder,"/train/y_train.txt"),col.names=c("activity")) 

# Read X_train file, and include unique/descriptive variable names extracted from features.txt file 
data_train<-read.table(paste0(datafolder,"/train/X_train.txt"),col.names=variablenames)

#Merge all train tables
traintable<-cbind(subject_train,activity_train,data_train)

##Merge the test and train table
activitydata<-rbind(testtable,traintable)

## EXTRACT ONLY THE MEASUREMENTS ON THE MEAN AND STANDARD DEVIATION
# use grepl to find variable names cointaining "mean" or "std" , exclude meanFrequency data
index<-(grepl("mean",names(activitydata),fixed=TRUE) 
        | grepl("std",names(activitydata),fixed=TRUE)
        | grepl("subject",names(activitydata),fixed=TRUE)
        | grepl("activity",names(activitydata),fixed=TRUE))& !grepl("meanFreq",names(activitydata),fixed=TRUE) 

# Get a subset of the activity data table using the index vector created above

activitysubset<-activitydata[,index]

## USE DESCRIPTIVE ACTIVITY NAMES TO NAME THE ACTIVITIES IN THE DATA SET 
## define activity variable as a factor

activitysubset$activity<-factor(activitysubset$activity,levels=activity_labels[,1],labels=activity_labels[,2])

## CREATE A TIDY DATASET WITH THE AVERAGE OF EACH VARIABLE FOR EACH ACTIVITY AND EACH SUBJECT

# Load dplyr package to group and summarize the data
library(dplyr)

averageactivitydata<-activitysubset %>% group_by(subject,activity) %>% summarise_each(funs(mean))

## Save the dataframe in the working directory

write.table(averageactivitydata, "averageactivitydata.txt",row.names=FALSE)

