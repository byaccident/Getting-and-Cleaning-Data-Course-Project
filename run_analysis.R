#You should create one R script called run_analysis.R that does the following. 
#Merges the training and the test sets to create one data set.
#Extracts only the measurements on the mean and standard deviation for each measurement. 
#Uses descriptive activity names to name the activities in the data set
#Appropriately labels the data set with descriptive variable names. 
#From the data set in step 4, creates a second, independent tidy data set 
#with the average of each variable for each activity and each subject.

library(tidyr)
library(dplyr)
library(magrittr)

#read in column names
headers <- read.table("./UCI HAR Dataset/features.txt") %>%
  extract(2) %>%
  as.list() %>%
  lapply(., make.names, unique = TRUE) %>%
  extract2(1) %>%
  c(., "activity", "subject")


#read in both datasets, as well as the activity and subject columns
test <- read.table("./UCI HAR Dataset/test/x_test.txt")%>%
  bind_cols(read.table("./UCI HAR Dataset/test/y_test.txt")) %>%
  bind_cols(read.table("./UCI HAR Dataset/test/subject_test.txt"))%>%
  set_colnames(headers)

train <- read.table("./UCI HAR Dataset/train/X_train.txt")%>%
  bind_cols(read.table("./UCI HAR Dataset/train/y_train.txt")) %>%
  bind_cols(read.table("./UCI HAR Dataset/train/subject_train.txt"))%>%
  set_colnames(headers)

#merge the train and test datasets, pull out only the std, mean, activity and subject columns
everything <- bind_rows(test, train) %>%
  select(matches("(std|mean|activity|subject)"))

#split-apply-combine methodology. split the dataset by activity and replace the activity
#number with the appropriate activity description

t1 <- everything %>%
  filter(activity == 1) %>%
  mutate(activity = "walking")

t2<- everything %>%
  filter(activity == 2) %>%
  mutate(activity = "walking_upstairs")

t3 <- everything %>%
  filter(activity == 3) %>%
  mutate(activity = "walking_downstairs")

t4<- everything %>%
  filter(activity == 4) %>%
  mutate(activity = "sitting")

t5<- everything %>%
  filter(activity == 5) %>%
  mutate(activity = "standing")

t6<- everything %>%
  filter(activity == 6) %>%
  mutate(activity = "laying")

#re-combine the dataset together. bring all the different measurement columns under one
#column 'measure' (as the key) and put the observational values in a new value column
all.measures <- bind_rows(t1, t2, t3, t4, t5, t6) %>%
  gather(measure, value, -activity, -subject) 

#house cleaning
rm(t1, t2, t3, t4, t5, t6, test, train, everything, headers)

#group the data by measure, activity and subject then run the mean by group
averages <- group_by(all.measures, measure, activity, subject) %>%
  summarise(mean = mean(value))
  
averages



