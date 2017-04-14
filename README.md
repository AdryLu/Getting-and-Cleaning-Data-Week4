# Getting-and-Cleaning-Data-Week4
This repo contains the week 4 assignment for the Getting and Cleaning Data Course in Coursera

For using the xx R script, please unzip the file containing the Samsung data sets downloaded using this link:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

Set the working directory in R to be the extracted folder *UCI HARD Dataset*
Below is a description of the steps/operations performed by the R scrip:
* The path to the current working directory is store in "datafolder"

THe features file is read into R to obtain suitable variable names. The activity_labels file is read, since it cotains the names to be used for the activity levels. Small editing of the text is done to remove certain characters like () and -
* THe *features.txt* file in the *UCI HARD Dataset* folder is read into a data frames *variables*
* The variables description is store in a character vector, this will be used to name the columns of the X_test/X_train datasets  using descriptive names
* The *()*, and *-* characters are removed from the name description by combining lappy and the sub/gsub functions, so they are *cleaner* to assig them as variablenames
* The *activity_labels.txt* file is read and store into a data frame *activity_labels*, descriptive varible/column names are used
* The *-* character is removed from the activity labels, using the gsub() function.

The files in the test folder (subjec_test, y_test and X_test) are each read an stored in data frames
* The *subject_test.txt* file from the */test* folder is read into a data frame, and the variable name subject is assigned
* The *y_test.txt* file from the */test* folder is read into a data frame, and the variable name activity is assigned
* The *X_test.txt* file from the */test* folder is read into a data frame, the variable names obtain from the *features.txt* file are assigned as column names (variables)

The three data frames (subject_test,y_test and X_test) are merge into a single data frame
* The cbind() function is used to combine the test data frames 

The same operations describe above are done for the files in the train flder (subject_train, y_train and X_train)

The rbind() function is used to combine the test and train datasets, the column names for both datasets (test and train) are the same

To extract the only the measurements on the mean and standard deviation the following steps are applied:
* The grepl() function is used to match the variable names that contain the text "mean" and "std". 
* grepl() is used to match the variable names that contain the text"meanFreq", to exclude this variables from the selected variables, 
* the variables "subject" and "activity" are also preserve as part of the extracted dataset (activitysubset).

The function factor() is used to replace the numeric/integer activity levels to descriptive names. (Walking, walkingup, walkingdown, etc)

The function in the dlpyr library are used to group and summarize the dataset. 
* The pile line operator %>% is used to first group the data by subject and activity, and them summarize (mean)
* The results is stored in a new data frame

The write.table function is used to write the final dataset in the working directory


