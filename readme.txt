I first loaded in the features.txt to use as the headers for my dataset. I concatenated these character strings with "activity" and "subject" headers as I will be taking these variables into account. I read in the observation data for the test and training data (x_test/train) separately. I used the magrittr and dplyr libraries to read in and attach the activity (y_test/train) and subject labels. As a side note, I did try to just nest these two scripts together with the following script:

		merged_data <-read.table("./UCI HAR Dataset/test/x_test.txt")%>%
  bind_cols(read.table("./UCI HAR   Dataset/test/y_test.txt")) %>%
  bind_cols(read.table("./UCI HAR Dataset/test/subject_test.txt"))%>%
  bind_rows(read.table("./UCI HAR Dataset/train/X_train.txt")%>%
 	bind_cols(read.table("./UCI HAR Dataset/train/y_train.txt"))) %>%
  	bind_cols(read.table("./UCI HAR Dataset/train/subject_train.txt"))%>%
  set_colnames(headers)
	
however, I kept running into an error where only 561 (rather than 563 columns) would read-in causing issues with the set_colnames function. As a workaround I read them in separately and merged them using the bind_rows function. I tacked on the select function heree to pull out only the columns that matched any one of the 'std' 'mean' 'activity' or 'subject' variables.

Next, I utilized the 'split-apply-combine' methodology and separated my merged dataframe into each separate activity, changed the activity to is descriptive title and recombined the data into the 'all.measures' data.frame. The merged data still seemed messy. I resolved this by accounting that the different measures could really be considered variables themselves, so I used the gather function to gather all of the measurement observations (as the key) into a measurement column and stored the data in a value column. I removed the excess variables (t1, t2, t3..) as my workspace was beginning to feel claustrophobic. A this point I had a nice tidy dataset with 4 columns (activity, subject, measure, value).

To complete the next step, I created a new variable called 'averages'. I first grouped the data created previously by measure, activity and subject (as the task called to get the average for each variable for each activity and each subject.) I then called called summarise on the grouped data to take the mean of the value. The summarise function takes into account the grouping parameters called previously. The result is four columns: measure, activity, subject, and mean(value), and displays the mean for each measure, for each activity for each subect.