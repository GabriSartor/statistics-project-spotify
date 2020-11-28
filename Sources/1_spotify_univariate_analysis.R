library(ggplotify)
library(ggpubr)
library(farver)
library(moments)
library(dplyr)  
library(corrplot)

# set wd and import dataset
setwd("./data")
# info about the dataset:
data <- read.csv('spotify_data.csv')
dim(data)
names(data)
# from duration_ms to duration_s, added a column
data$duration_s <- round((data$duration_ms/1000), 1)

######################
## OUTLIER DETECTION##
######################
min(data$duration_s) # 5 sec
max(data$duration_s) # 1h30min

mean(data$duration_s)

sd(data$duration_s)
# sqrt(var(Density))

q1 = quantile(data$duration_s, 0.25)
q2 = quantile(data$duration_s, 0.5)
# median(Density)
q3 = quantile(data$duration_s, 0.75)

iqr = IQR(data$duration_s)   # or quantile(Density, 0.75) - quantile(Density, 0.25)


length(data$duration_s[which(data$duration_s<q1-1.5*iqr)])
length(data$duration_s[which(data$duration_s>q3+1.5*iqr)])

dim(data)
eliminated_data_1_5<- subset(data, data$duration_s < (q1 - 1.5*iqr) | data$duration_s > (q2+1.5*iqr))
eliminated_data_6<- subset(data, data$duration_s < (q1 - 1.5*iqr) | data$duration_s > (q2+6*iqr))

top_10_eliminated_6 = eliminated_data_6[order(eliminated_data_6$popularity, decreasing = TRUE),][1:10,]
top_10_eliminated_1_5 = eliminated_data_1_5[order(eliminated_data_1_5$popularity, decreasing = TRUE),][1:10,]
write.csv(top_10_eliminated_6,"top_10_outliers_6iqr.csv", row.names = FALSE)
write.csv(top_10_eliminated_1_5,"top_10_outliers_1_5iqr.csv", row.names = FALSE)

hist(eliminated_data_1_5$popularity,main="Histogram Popularity",ylab="popularity frequence", xlab="Eliminated data 1.5*IQR")
hist(eliminated_data_6$popularity,main="Histogram Popularity",ylab="popularity frequence", xlab="Eliminated data 6*IQR")

#We choose to use 6*iqr since 1.5*iqr eliminates some famous songs
clean_data<- subset(data, data$duration_s > (q1 - 1.5*iqr) & data$duration_s < (q2+6*iqr))
dim(clean_data)

###################

## Numerical subset


# Select columns for univariate analysis
numerical_columns_names <- c("popularity", "instrumentalness", "acousticness", "danceability", "energy", "liveness", "loudness", "speechiness", "tempo", "valence", "duration_s")
for (attribute in numerical_columns_names) {
  #str(clean_data[attribute])
  hist(clean_data[attribute][,], main=paste("Histogram ", attribute), xlab=paste(attribute))
}


## clean_data is my new dataset without outliers
head(clean_data)

#Create x different time periods with labels
time_periods <- list(  c(1920,1949), 
                       c(1950,1979), 
                       c(1980,1999), 
                       c(2000,2009), 
                       c(2010,2020))
time_periods_labels <- list( "20s-40s", "50s-70s", "80s-90s", "00s", "10s" )

# Compute boxplot, skewness and kurtosis for each column extracted
for (attribute in numerical_columns_names) {
  print(paste("Computing boxplots, skewness and kurtosis for ", attribute))
  bp_list = list()
  sk_list = list()
  ku_list = list()
  
  # Compute boxplot, skewness and kurtosis for the selected column for each time period
  for (i in 1:length(time_periods)) {
    d <- clean_data[ which(clean_data$year>=time_periods[[i]][1] & clean_data$year <= time_periods[[i]][2]), ]
    bp_list[[i]] = as.grob(~boxplot(d[attribute],
                                    horizontal=FALSE, 
                                    main=paste(time_periods_labels[[i]]),
                                    #ylim=c(0, 1000 )))
                                    ylim=c(min(clean_data[attribute]), max(clean_data[attribute]))))
    sk_list[[i]] = skewness(d[attribute])
    ku_list[[i]] = kurtosis(d[attribute])
  }
  print(ggarrange(plotlist = bp_list, nrow = 1))
  print('Skewness values: ')
  print(sk_list)
  
  print('Kurtosis values: ')
  print(ku_list)
  
  readline(prompt="Press [enter] to continue")
}