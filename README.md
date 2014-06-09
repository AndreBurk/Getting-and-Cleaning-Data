Getting-and-Cleaning-Data
=========================

README:
-------------------------
System: Mac (10.9.3),
RStudio: 0.98.507

-------------------------

At first the Analysis-Code starts with downloading the raw data set into the working directory.

```
url = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, destfile = "Samsung.zip", method = "curl")
```

Then the downloaded file gets unzipped in the working directory.

```
unzip("Samsung.zip", exdir = ".")
```

After that the code begins loading data into R. First the training set data ("train"). Then the training label data for the different activities ("acttrain") and finally the subject data for the participants ("subtrain"). After renaming the columns of the activity and subject data frames the code puts all three data frames together. The columns were renamed so that while combining the data frames no column name problems arise.
The same applies for the test data ("test", "acttest", "subtest").

```
train = read.table("UCI HAR Dataset/train/X_train.txt")
acttrain = read.table("UCI HAR Dataset/train/y_train.txt")
colnames(acttrain)[1] = "Activity"
subtrain = read.table("UCI HAR Dataset/train/subject_train.txt")
colnames(subtrain)[1] = "Subject"
train = cbind(train, acttrain)
train = cbind(train, subtrain)
```

Following loading and combing each the training and test data both data frames get combined to the new data frame called "merge".

```
merge = rbind(train, test)
```

After the code has removed some unnecessary objects the code loads the features data into R and renames the columns of the "merge" data frame. The last two columns get renamed by hand as their names are not in the features data table.

```
features = read.table("UCI HAR Dataset/features.txt")
colnames(merge) = features$V2
```

That was task 1 from the "Course Project" so far.
Task 2 asks for extracting only the columns that have "Mean" or "Std" in their names. This gets done by using the function "grepl" to logically check the column names for the keywords. "Activity" and "Subject" are added here so that these columns do not get lost after subsetting the fitting columns as "Activity" and "Subject" are also needed. "merge2" then contains "Activity", "Subject" and columns that either have "mean" or "std" in their columns names.

```
ext1 = grepl("[Mm]ean|[Ss]td|Activity|Subject", colnames(merge))
merge2 = subset(merge[,ext1])
```

For task 3 now first the "labels" data set has to be loaded into R containing the activity names for the yet coded activities. The activity codes get replaced by their activity names according to the "labels" data.

```
labels = read.table("UCI HAR Dataset/activity_labels.txt")

for (i in labels$V1){
    merge2$Activity = gsub(i, labels[i, 2], merge2$Activity)    
}
```

Task 4 asks for cleaning up the column names so that they look more tidy. This gets done with the function "gsub" and appropriate replacements.

```
colnames(merge2) = gsub("-mean", "Mean", colnames(merge2))
colnames(merge2) = gsub("-std", "Std", colnames(merge2))
colnames(merge2) = gsub("[[:punct:]]", "", colnames(merge2))
colnames(merge2) = gsub("BodyBody", "Body", colnames(merge2))
```

Last but not least task 5. Using the "aggregate" function the tidy data frame gets created which contains the average value for each column grouped by "Subject" and "Activity" so that one can see the average value of each variable for each subject and each activity. Finally the tidy data frame get written into a ".txt" file so it can be loaded up on "coursera".

```
tidy = aggregate(merge2[, 1:86], list(Subject = merge2$Subject, Activity = merge2$Activity), mean)
write.table(tidy, file = "tidy-dataset.txt", row.names=FALSE)
```