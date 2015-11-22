# run_analysis.R
#
# R script for the Course Project for Getting and Cleaning Data
#
# This script expects that the UCI HAR data has been unzipped in the following working
# directory: d:/Projects/GetCleanData/CourseProject
# 
# Change it on your computer to match the folder.

# uncomment this line in order to execute the script in another working directory
# setwd("d:/Projects/GetCleanData/CourseProject")

# Read the different data files
# The feature vector with the column labels
features <- read.table("./UCI HAR Dataset/features.txt")
# activity labels to rename the y-data
activity_labels <- c("walking", "walking upstairs",
                     "walking downstairs",
                     "sitting", "standing", "laying")


# The following is split into test and training data.
# subject_<test, train> is the identification for the subject
# y_<test, train> is the label of the activity as a number between 1 and 6
# X_<test, train> is the actual data, processed from the raw acceleration
#                 data in the subfolders

subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")

subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")

# Merge the test and train data sets
# first, generate a vector of strings from the features with the column names
feature_vec <- as.character(features$V2)
name_vec <- append(c("Subject.ID", "Activity.ID"), feature_vec)

# Next, put all data into new data frames that contain subject ID, 
# activity ID and the actual data
testdata <- data.frame(subject_test, y_test, X_test)
traindata <- data.frame(subject_train, y_train, X_train)

# row bind the two seperate test and train data sets and give them their names
fulldata <- rbind(testdata, traindata)
colnames(fulldata) <- name_vec

# Now it is time to extract only the columns that contain mean and
# standard deviation for each measurement. For this, I take advantage of
# the fact that the names in the name_vec contain substrings "mean()"
# and "std()", which I can use to weed out the required columns.

idcs_mean <- grep("mean()", name_vec, fixed = TRUE)
idcs_std <- grep("std()", name_vec, fixed = TRUE)

# Make it one vector and add columns 1 and 2 for the IDs

idcs <- append(c(1, 2), idcs_mean)
idcs <- append(idcs, idcs_std)
idcs <- sort(idcs)

# retrieve the desired columns

fulldata <- fulldata[, idcs]

# Turn the Activity ID column to factor and replace the numeric factors
# with descriptive factors

fulldata$Activity.ID <- as.factor(fulldata$Activity.ID)
fulldata$Subject.ID <- as.factor(fulldata$Subject.ID)
levels(fulldata$Activity.ID) <- activity_labels

# For the condensed data set, I need to know the levels of Subject.ID and Activity.ID
list_SubID_levels <- levels(fulldata$Subject.ID)
list_ActID_levels <- levels(fulldata$Activity.ID)

# generate empty vectors and matrix to hold the data.
cropdata_mat <- matrix(0, nrow = 0, ncol = (length(idcs) - 2))
SubID_vec <- c()
ActID_vec <- c()

# Main loop to condense the data. From the level vectors I generate a logical vector that points
# at the rows which have the respective levels (from Subject.ID and Activity.ID)
# I compute the mean of each column and save it into variable "zwischen", and append the respective
# levels of subject and activity to separate vectors; just to make sure the mapping stays correct
for (SubID_level in list_SubID_levels) {
    for (ActID_level in list_ActID_levels) {
        zwischen <- colMeans(fulldata[fulldata$Subject.ID == SubID_level &
                             fulldata$Activity.ID == ActID_level, 3:length(idcs)])
        SubID_vec <- append(SubID_vec, SubID_level)
        ActID_vec <- append(ActID_vec, ActID_level)
        cropdata_mat <- rbind(cropdata_mat, zwischen)
    }
}

# Convert string vectors to factors
SubID_vec <- as.factor(SubID_vec)
ActID_vec <- as.factor(ActID_vec)

# Put factors and average data into one data frame
cropdata <- data.frame(SubID_vec, ActID_vec, cropdata_mat, row.names = NULL)

# The column names need to be re-established.
colnames(cropdata) <- name_vec[idcs]

# Last item on the list: Write the table
write.table(cropdata, 'courseProjectSubmission.txt', row.names = FALSE)


