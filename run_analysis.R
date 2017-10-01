library(reshape2)

# 1.Merges the training and the test sets to create one data set.

xTrain = read.table("./train/X_train.txt")
xTest = read.table("./test/X_test.txt")
X = rbind(xTrain, xTest)

yTrain = read.table("./train/y_train.txt")
yTest = read.table("./test/y_test.txt")
Y = rbind(yTrain, yTest)

sTrain = read.table("./train/subject_train.txt")
sTest = read.table("./test/subject_test.txt")
S = rbind(sTrain, sTest)



#2. Extracts only the measurements on the mean and standard deviation for each measurement.
features=read.table("./features.txt")
selectedFeatures = grep('.*std.*|.*mean.*', features[,2])
selectedFeatureNames = features[selectedFeatures,2]
selectedFeatureNames = gsub('-mean', 'Mean', selectedFeatureNames)
selectedFeatureNames = gsub('-std', 'Std', selectedFeatureNames)
selectedFeatureNames = gsub('[-()]', '', selectedFeatureNames)
X = X[,selectedFeatures]


#3.Uses descriptive activity names to name the activities in the data set
activityLabels = read.table("./activity_labels.txt")
activityLabels[,2] = as.character(activityLabels[,2])
Y[,1] = activityLabels[Y[,1],2]

#4.Appropriately labels the data set with descriptive variable names.
colnames(X) = selectedFeatureNames
colnames(Y) = "activity"
colnames(S) = "subject"

#5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
ds = cbind(S,Y,X)
ds$activity <- as.factor(ds$activity)
ds$subject <- as.factor(ds$subject)
dsMelted = melt(ds, id = c("subject", "activity"))
dsMean = dcast(dsMelted, subject + activity ~ variable, mean)

write.table(dsMean, "tidyData.txt")

