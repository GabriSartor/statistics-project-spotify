library(ggplotify)
library(ggpubr)
library(farver)
library(moments)
library(dplyr)  


###################################
######## Statistics project #######
## 100 Years of Music on Spotify ##
##### Part 3 - Trend analysis #####
###################################

setwd(".")

########################
### Dataset cleaning ###
########################

# Do not run if 0_dataset_cleaning has already been executed
data <- read.csv('../data/spotify_data.csv')
data$duration_s <- round((data$duration_ms/1000), 1)

q1 = quantile(data$duration_s, 0.25)
q2 = quantile(data$duration_s, 0.5) # median
q3 = quantile(data$duration_s, 0.75)

iqr = IQR(data$duration_s)   # or q3 - q1 

clean_data <- subset(data, data$duration_s > (q1 - 1.5*iqr) & data$duration_s < (q2+6*iqr))

### END DATASET CLEANING ###
############################



## Numerical subset


# Select numerical columns
numerical_columns_names <- c("popularity", "instrumentalness", "acousticness", "danceability", "energy", "liveness", "loudness", "speechiness", "tempo", "valence", "duration_s")

# Shows distribution for each numerical column
for (attribute in numerical_columns_names) {
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