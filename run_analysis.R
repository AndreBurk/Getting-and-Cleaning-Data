
# Download zip file
url = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, destfile = "Samsung.zip", method = "curl")
dateDownloaded = date()
dateDownloaded

# Unzip file
unzip("Samsung.zip", exdir = ".")

# Task 1: Merging Training and Test set data
train = read.table("UCI HAR Dataset/train/X_train.txt")
acttrain = read.table("UCI HAR Dataset/train/y_train.txt")
colnames(acttrain)[1] = "Activity"
subtrain = read.table("UCI HAR Dataset/train/subject_train.txt")
colnames(subtrain)[1] = "Subject"
train = cbind(train, acttrain)
train = cbind(train, subtrain)

test = read.table("UCI HAR Dataset/test/X_test.txt")
acttest = read.table("UCI HAR Dataset/test/y_test.txt")
colnames(acttest)[1] = "Activity"
subtest = read.table("UCI HAR Dataset/test/subject_test.txt")
colnames(subtest)[1] = "Subject"
test = cbind(test, acttest)
test = cbind(test, subtest)

merge = rbind(train, test)

rm(acttest);rm(acttrain);rm(subtrain);rm(subtest)

features = read.table("UCI HAR Dataset/features.txt")

### Rename column names
colnames(merge) = features$V2
colnames(merge)[562] = "Activity"
colnames(merge)[563] = "Subject"

# Task 2: Extract all mean and std measurements
ext1 = grepl("[Mm]ean|[Ss]td|Activity|Subject", colnames(merge))
merge2 = subset(merge[,ext1])

# Task 3: Naming the activities
labels = read.table("UCI HAR Dataset/activity_labels.txt")

for (i in labels$V1){
    merge2$Activity = gsub(i, labels[i, 2], merge2$Activity)    
}

# Task 4: appropriate labeling
colnames(merge2) = gsub("-mean", "Mean", colnames(merge2))
colnames(merge2) = gsub("-std", "Std", colnames(merge2))
colnames(merge2) = gsub("[[:punct:]]", "", colnames(merge2))
colnames(merge2) = gsub("BodyBody", "Body", colnames(merge2))

# Task 5: Creating tidy data set with mean for each variable for each activity and each subject
tidy = aggregate(merge2[, 1:86], list(Subject = merge2$Subject, Activity = merge2$Activity), mean)

# Write Txt-File
write.table(tidy, file = "tidy-dataset.txt", row.names=FALSE)
