###################################
######## Statistics project #######
## 100 Years of Music on Spotify ##
##### Part 0 - Dataset cleaning ###
###################################

setwd(".")

########################
### Dataset cleaning ###
########################

#Run this before running scripts 1-2-3

setwd("../data")
data <- read.csv('spotify_data.csv')

# from duration_ms to duration_s, added a column
data$duration_s <- round((data$duration_ms/1000), 1)

######################
## OUTLIER DETECTION##
######################
min(data$duration_s) #5.1
max(data$duration_s) #5403.5 -> 90 minutes!!!

mean(data$duration_s) #231.4063

sd(data$duration_s) #121.322

q1 = quantile(data$duration_s, 0.25) #171
q2 = quantile(data$duration_s, 0.5) #209
q3 = quantile(data$duration_s, 0.75) #263

iqr = IQR(data$duration_s) #92

length(data$duration_s[which(data$duration_s<q1-1.5*iqr)]) #283 inferior outliers
length(data$duration_s[which(data$duration_s>q3+1.5*iqr)]) #9183 superior outliers

#Do eliminated data contain important tracks of music history?
#Let's see the most popular tracks longer than mean+1.5iqr (6 minutes)
eliminated_data_1_5<- subset(data, data$duration_s < (q1 - 1.5*iqr) | data$duration_s > (q2+1.5*iqr))
top_10_eliminated_1_5 = eliminated_data_1_5[order(eliminated_data_1_5$popularity, decreasing = TRUE),][1:10,]
(top_10_eliminated_1_5[1:10, c('name', 'artists')])
hist(eliminated_data_1_5$popularity,main="Histogram Popularity",ylab="popularity frequence", xlab="Eliminated data 1.5*IQR")

#Many important tracks (in terms of popularity) have been eliminated, so we decide to cut data with a wider range -> mean+6*iqr (13 minutes)
#Popularity histogram now shows that only a few of popular tracks have been cut out
eliminated_data_6<- subset(data, data$duration_s < (q1 - 1.5*iqr) | data$duration_s > (q2+6*iqr))
top_10_eliminated_6 = eliminated_data_6[order(eliminated_data_6$popularity, decreasing = TRUE),][1:10,]
(top_10_eliminated_6[1:10, c('name', 'artists', 'duration_s')])
hist(eliminated_data_6$popularity,main="Histogram Popularity",ylab="popularity frequence", xlab="Eliminated data 6*IQR")

#Save results for later use
write.csv(top_10_eliminated_6,"top_10_outliers_6iqr.csv", row.names = FALSE)
write.csv(top_10_eliminated_1_5,"top_10_outliers_1_5iqr.csv", row.names = FALSE)

#Extract final clean dataset
clean_data<- subset(data, data$duration_s > (q1 - 1.5*iqr) & data$duration_s < (q2+6*iqr))

