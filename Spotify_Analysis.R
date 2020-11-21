setwd("~/Documents/statistics-project-spotify/data")
raw_data = read.csv('spotify_data.csv')
dim(raw_data); dimnames(raw_data)
str(raw_data); head(raw_data); View(raw_data)

# from duration_ms to duration_s
raw_data$duration_ms = round((raw_data$duration_ms/1000), 1)
names(raw_data)[names(raw_data) == "duration_ms"] = "duration_s"
dimnames(raw_data)

# subset for numerical analysis ('year' is still maintained for grouping purposes, even if categorical)
dataset = raw_data[, c(1, 3, 4, 5, 6, 8, 9, 10, 11, 12, 14, 16, 17, 18, 19)]
dimnames(dataset)
names(dataset)

# Rolling stone wants to make a special number for the last 100 years of music 
# The magazine will contain some analysis for 5 different decades (20-49, 50-79, 80-99, 00-09, 10-20)
# UNIVARIATE IDEAS:
# box plot for different decades but same variables put together
# cross of skeweness for shifting trends, kurtosis for convegences
# MULTIVARIATE IDEAS:
# search for evergreen correlations ()
# ...
# AT THE END..
# After that, it would be cool have the mean of the variables each year every year plotted with an explanation

# subsets for decades
d20_49 = dataset[1920 <= dataset$year & dataset$year < 1950, ]
d50_79 = dataset[1950 <= dataset$year & dataset$year < 1980, ]
d80_99 = dataset[1980 <= dataset$year & dataset$year < 2000, ]
d00_09 = dataset[2000 <= dataset$year & dataset$year < 2010, ]
d10_20 = dataset[2010 <= dataset$year & dataset$year < 2021, ]

# acousticness in different decades
boxplot(d20_49$acousticness,horizontal=FALSE, main='Boxplot d20_49', ylab='acousticness', ylim=c(min(d20_49$acousticness), max(d20_49$acousticness)))
boxplot(d50_79$acousticness,horizontal=FALSE, main='Boxplot d50_79', ylab='acousticness', ylim=c(min(d50_79$acousticness), max(d50_79$acousticness)))
boxplot(d80_99$acousticness,horizontal=FALSE, main='Boxplot d80_99', ylab='acousticness', ylim=c(min(d80_99$acousticness), max(d80_99$acousticness)))
boxplot(d00_09$acousticness,horizontal=FALSE, main='Boxplot d00_09', ylab='acousticness', ylim=c(min(d00_09$acousticness), max(d00_09$acousticness)))
boxplot(d10_20$acousticness,horizontal=FALSE, main='Boxplot d10_20', ylab='acousticness', ylim=c(min(d10_20$acousticness), max(d10_20$acousticness)))

# test the shifting with skeweness: confirmed
install.packages('moments')
library(moments)
skewness(d20_49$acousticness) # -2.340799
skewness(d50_79$acousticness) # -0.5802139
skewness(d80_99$acousticness) # 0.8749373
skewness(d00_09$acousticness) # 1.048702
skewness(d10_20$acousticness) # 1.131833

# test through kurtosis if artists followed the trend!
kurtosis(d20_49$acousticness)
kurtosis(d50_79$acousticness)
kurtosis(d80_99$acousticness)
kurtosis(d00_09$acousticness)
kurtosis(d10_20$acousticness)

