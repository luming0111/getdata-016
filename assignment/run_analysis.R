container = "UCI HAR Dataset"

# Read subject dataset
subject <- c(
  scan(sprintf("%s/test/subject_test.txt", container)), 
  scan(sprintf("%s/train/subject_train.txt", container)))
dataset_subject <- cbind(subject = subject)

# Read activity dataset
activityLabels <- read.csv(sprintf("%s/activity_labels.txt", container) , header = FALSE, sep=" ")
names(activityLabels) <- c("activityKey", "activity")

# Read Y dataset
vector_y <- c(
  scan(sprintf("%s/test/y_test.txt", container)),
  scan(sprintf("%s/train/y_train.txt", container))
  )
dataset_y <- cbind(activityKey = vector_y)

# Read X dataset and filtered by features
dataset_x <- rbind(
  read.csv(sprintf("%s/test/X_test.txt", container),
           sep = "",
           header = FALSE),
  read.csv(sprintf("%s/train/X_train.txt", container),
           sep = "",
           header = FALSE)
)

features <- read.csv(sprintf("%s/features.txt", container), header = FALSE, sep="")
names(dataset_x) <- features$V2

measurement_filter <- grepl('mean()', features$V2) | grepl('std()', features$V2)
dataset_x <- dataset_x[,which(measurement_filter)]

data <- cbind(dataset_subject, dataset_y, dataset_x)

## Tidy data
tidyData <- aggregate(data[4:ncol(data)],
                      list(ActivityName=data$activity, SubjectId=data$subject),
                      FUN=mean)
write.table(tidyData, file="tidy0119.csv")