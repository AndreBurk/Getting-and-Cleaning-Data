Getting-and-Cleaning-Data
=========================

At first the Analysis-Code starts with downloading the raw data set.

```
url = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, destfile = "Samsung.zip", method = "curl")
```

