##import subject, activite and data to data frames, merge test and train data
data <- read.table("data/UCI HAR Dataset/test/X_test.txt") 
data <- rbind(data,read.table("data/UCI HAR Dataset/train/X_train.txt") )

subjects <- read.table("data/UCI HAR Dataset/test/subject_test.txt") 
subjects <- rbind(subjects,read.table("data/UCI HAR Dataset/train/subject_train.txt") )

activity <- read.table("data/UCI HAR Dataset/test/y_test.txt") 
activity <- rbind(activity,read.table("data/UCI HAR Dataset/train/y_train.txt") )
actlabel <- read.table("data/UCI HAR Dataset/activity_labels.txt") 

#get col headers for data
features <- read.table("data/UCI HAR Dataset/features.txt") 


##get col indexes for mean and std
lstmeanstd <- grep("-(mean|std)\\(\\)", features[, 2])


##update column names
colnames(data) <- features[,2]
colnames(subjects) <- "subject"
colnames(activity) <- "activity"

##cleanup col names
colnames(data) <- gsub("[[:punct:]+]","", colnames(data))
colnames(data)<- gsub("tBody","TimeBody",colnames(data))
colnames(data)<- gsub("tGravity","TimeGravity",colnames(data))
colnames(data)<- gsub("fBody","FreqBody",colnames(data))
colnames(data)<- gsub("fGravity","FreqGravity",colnames(data))

##reduce so we only have columns with mean and std
data <- data[,lstmeanstd] 

##merge subject, activity, and data 
alldata <- cbind(subjects,activity, data)

##Update variable names for activity

    i <- 1
    while(i < 7){
      
      alldata$activity <- gsub(i,actlabel[i,2],alldata$activity)
      i<-i+1
    }


##average by activitity and subject

tblData <- tbl_df(alldata)
gdata <- group_by(tblData, activity,subject)
tidydata <- summarise_each(gdata,funs(mean))

write.table(tidydata ,"tidy_data.txt" ,row.name=FALSE)

