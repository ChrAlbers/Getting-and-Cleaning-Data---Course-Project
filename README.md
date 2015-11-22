#README.md

README.md for the R-script run_analysis.R

The script processes data that has to be downloaded manually before from:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
The zip file has to be unpacked in to the same folder as the script run_analysis.R,
i.e. in folder there has to be a subfolder "./UCI HAR Dataset" with the respective
subfolder and data files. The processed data will be written to a textfile 
named "courseProjectSubmission.txt" in the same folder where run_analysis.R
is.

The original UCI HAR dataset is from an experiment to learn to classify data from an
accelerometer worn by a human test subject in order to predict the activity of
the subject as either walking, walking upstairs, walking downstairs, sitting,
standing, or laying. The UCI HAR dataset consists of time series data from
accelerometers which has been filtered, and derivative data has been computed
(for example separating data into acceleration from body and gravity, computing
fourier transforms, and so on), labeled with subject ID and activity ID. The
data outputted by run_analysis.R is a condensed version of the UCI HAR dataset
by selecting only mean and standard deviation data. Furthermore, the time
series are collapsed into an average for each subject and activity. There are
30 different human subjects and 6 activity labels, which results in 180 rows of
data (observations).


#Description of run_analysis.R-script

line 11: 	uncomment the setwd-command to run analysis in fixed working
			directory

line 15: 	Load the features from features.txt to use them as column names
line 17: 	The labels for the activities are defined (later use as factors)

line 18-34: The data is loaded for train and test sets seperately. For each
			case there is a variable subject (contains subject IDs), y
			(contains activity levels as numerics), X (actual data). The link
			between IDs and data is by row
			
line 38-39:	Generate a character vector of column names from feature vector
			and using Subject.ID and Activity.ID as names for the respective
			factors
			
line 43-47: Merge test data and training data into one single data frame
			called "fulldata"
line 48: 	Give names to columns

line 55-56: Use regular expressions to retrieve the numeric indices of the
			column names that contain "mean()" and "std()". This is done in
			order to discard the other measurements. Make a vector of the
			indices of the data that should be kept.

line 66:	Condense "fulldata" by only keeping the columns with indices that
			correspond to names that contain "mean()" and "std()" (see above)
			
line 71-71:	Convert the numeric Subject and Activity labels to factors
line 73:	Replace numeric activity labels with the word for the activity
			(walking, standing, etc.)
			
line 76-82: Prepare the following for-loop. Retrieve vectors containing the
			factor levels for Subject and Activity IDs. Allocate an empty
			matrix to which the average of each data column with respect to
			subject and activity ID will be appended. Do the same for subject
			and activity ID to correctly keep track of the mapping.

line 99-100: Convert the subject and activity ID vectors to factors.

line 103: 	Bind the factors and averaged data into one data frame

line 106:	Assign the column names

line 109: 	Write the data frame into a text file with name
			"courseProjectSubmission.txt"
			