library(ggplotify)
library(ggpubr)
library(farver)
library(moments)
library(dplyr)  
library(ggplot2)
library(stringr) 
require(plyr)


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

rm(iqr)
rm(q1)
rm(q2)
rm(q3)

## Numerical subset


# Select numerical columns
numerical_columns_names <- c("popularity", "instrumentalness", "acousticness", "danceability", "energy", "liveness", "loudness", "speechiness", "tempo", "valence", "duration_s")

# Shows distribution for each numerical column
for (attribute in numerical_columns_names) {
  print(ggplot(clean_data, aes(x=clean_data[attribute][,])) + 
    geom_histogram(aes(y=..density..), colour="black", fill="#1DB954")+
    labs(title=str_to_title(paste(gsub("_", " ",attribute), "histogram plot")),x=attribute, y = "Density"));
}


## clean_data is my new dataset without outliers
head(clean_data)

#Create x different time periods with labels
time_periods <- c(  1920,1950,1980, 2000, 2010)
time_periods_labels <- c( "20s-40s", "50s-70s", "80s-90s", "00s", "10s" )

clean_data$time_period <- mapvalues(clean_data$year, 
                               from=seq(1921,2020), 
                               to=c(replicate(length(seq(1921,1949)), 1920), replicate(length(seq(1950,1979)), 1950),
                                    replicate(length(seq(1980,1999)), 1980), replicate(length(seq(2000,2009)), 2000),
                                    replicate(length(seq(2010,2020)), 2010)) )

clean_data$time_period <- as.factor(clean_data$time_period)


# Compute boxplot, skewness and kurtosis for each column extracted
for (attribute in numerical_columns_names) {
  print(paste("Computing boxplots, skewness and kurtosis for ", attribute))
  sk_list = list()
  ku_list = list()
  
  p <- ggplot(clean_data, aes(time_period, clean_data[attribute][,]))
  print(p + geom_boxplot(colour="black", fill="#1DB954",
                         # custom outliers
                         outlier.colour="black",
                         outlier.fill="black",
                         outlier.size=1,
                         outlier.alpha = 0.3) +
          labs(title=str_to_title(paste(gsub("_", " ",attribute), "boxplot")),
               x="Time Period", 
               y = str_to_title(attribute) ) )

  # Compute boxplot, skewness and kurtosis for the selected column for each time period
  for (i in seq(1,length(time_periods))) {
    d <- clean_data[ which(clean_data$time_period==time_periods[i]), ]
    sk_list[[i]] = skewness(d[attribute])
    ku_list[[i]] = kurtosis(d[attribute])
  }
  
  print('Skewness values: ')
  print(sk_list)
  
  print('Kurtosis values: ')
  print(ku_list)
}
