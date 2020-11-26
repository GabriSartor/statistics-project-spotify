library(ggplotify)
library(ggpubr)
library(farver)
library(moments)
library(dplyr)  

# set wd and import dataset
setwd("./data")
# info about the dataset:
data <- read.csv('spotify_data.csv')

# from duration_ms to duration_s, added a column
data$duration_s <- round((data$duration_ms/1000), 1)
# added a column "decade" - 1920,1930,1940,1950,1960,1970,1980,1990,2000,2010,2020
data$decade <- as.numeric((floor( (data$year) / 10) * 10))

column_names <- dimnames(data)

min(data$duration_s)
max(data$duration_s)

mean(data$duration_s)

sd(data$duration_s)
# sqrt(var(Density))

q1 = quantile(data$duration_s, 0.25)
q2 = quantile(data$duration_s, 0.5)
# median(Density)
q3 = quantile(data$duration_s, 0.75)

quantile(data$duration_s)

iqr = IQR(data$duration_s)   # or quantile(Density, 0.75) - quantile(Density, 0.25)


length(data$duration_s[which(data$duration_s<q1-1.5*iqr)])   # one inferior outlier
length(data$duration_s[which(data$duration_s>q3+1.5*iqr)])

dim(data)
new_data<- subset(data, data$duration_s > (q1 - 1.5*iqr) & data$duration_s < (q2+1.5*iqr))

#Create x different time periods with labels
time_periods <- list(  c(1920,1949), 
                       c(1950,1979), 
                       c(1980,1999), 
                       c(2000,2009), 
                       c(2010,2020))
time_periods_labels <- list( "20s-40s", "50s-70s", "80s-90s", "00s", "10s" )

# Select columns for univariate analysis
univariate_columns_names <- c("acousticness", "danceability", "energy", "liveness", "loudness", "speechiness", "tempo", "valence", "duration_s")

# Compute boxplot, skewness and kurtosis for each column extracted
for (attribute in univariate_columns_names) {
  print(paste("Computing boxplots, skewness and kurtosis for ", attribute))
  bp_list = list()
  sk_list = list()
  ku_list = list()
  
  # Compute boxplot, skewness and kurtosis for the selected column for each time period
  for (i in 1:length(time_periods)) {
    d <- new_data[ which(new_data$year>=time_periods[[i]][1] & new_data$year <= time_periods[[i]][2]), ]
    bp_list[[i]] = as.grob(~boxplot(d[attribute],
                                    horizontal=FALSE, 
                                    main=paste(time_periods_labels[[i]]),
                                    #ylim=c(0, 1000 )))
                                    ylim=c(min(new_data[attribute]), max(new_data[attribute]))))
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






