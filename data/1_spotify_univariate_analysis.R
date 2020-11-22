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

#Create x different time periods
time_periods <- list(  c(1921,1940), 
                       c(1941,1960), 
                       c(1961,1970), 
                       c(1971,1980), 
                       c(1981,1990), 
                       c(1991,2010), 
                       c(2011,2020) )
time_periods_labels <- list( 'Name_1', 'Name_2', 'Name_3', 'Name_4', 'Name_5', 'Name_6', 'Name_7' )

# Extract columns for univariate analysis

univariate_columns_names <- c("acousticness", "energy", "loudness")

# Compute boxplot, skewness and kurtosis for each column extracted

for (attribute in univariate_columns_names) {
  print(paste("Computing boxplots, skewness and kurtosis for ", attribute))
  bp_list = list()
  sk_list = list()
  ku_list = list()
  # Compute boxplot, skewness and kurtosis for the selected column for each time period
  for (i in 1:length(time_periods)) {
    d <- data[ which(data$year>=time_periods[[i]][1] & data$year <= time_periods[[i]][2]), ]
    bp_list[[i]] = as.grob(~boxplot(d[attribute],
                                    horizontal=FALSE, 
                                    main=paste('Boxplot ', time_periods_labels[[i]]),
                                    ylab=attribute, 
                                    ylim=c(min(data[attribute]), max(data[attribute]))))
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






