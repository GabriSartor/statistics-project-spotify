# set wd and import dataset
setwd("~/Documents/statistics-project-spotify/data")
# info about the dataset:
# https://developer.spotify.com/documentation/web-api/reference/tracks/get-audio-features/
raw_data = read.csv('spotify_data.csv')
dim(raw_data) # # 169909 x 19
dimnames(raw_data)
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
# - let's find the major shifts in music
# box plot for different decades but same variables put together
# cross of skeweness for shifting trends, kurtosis for convegences
# ... <----------
# MULTIVARIATE IDEAS:
# - search for evergreen correlations ()
# ... <----------
# AT THE END..
# - After that, it would be cool have the mean of the variables each year every year plotted with an explanation
# - max popularity artist
# - max popularity song

# subsets for decades
d20_49 = dataset[1920 <= dataset$year & dataset$year < 1950, ]
d50_79 = dataset[1950 <= dataset$year & dataset$year < 1980, ]
d80_99 = dataset[1980 <= dataset$year & dataset$year < 2000, ]
d00_09 = dataset[2000 <= dataset$year & dataset$year < 2010, ]
d10_20 = dataset[2010 <= dataset$year & dataset$year < 2021, ]

# acousticness in different decades
# install.packages('ggplotify')
library(ggplotify)
bp_20 = as.grob(~boxplot(d20_49$acousticness,horizontal=FALSE, main='Boxplot d20_49', ylab='acousticness', ylim=c(min(d20_49$acousticness), max(d20_49$acousticness))))
bp_50 = as.grob(~boxplot(d50_79$acousticness,horizontal=FALSE, main='Boxplot d50_79', ylab='acousticness', ylim=c(min(d50_79$acousticness), max(d50_79$acousticness))))
bp_80 = as.grob(~boxplot(d80_99$acousticness,horizontal=FALSE, main='Boxplot d80_99', ylab='acousticness', ylim=c(min(d80_99$acousticness), max(d80_99$acousticness))))
bp_00 = as.grob(~boxplot(d00_09$acousticness,horizontal=FALSE, main='Boxplot d00_09', ylab='acousticness', ylim=c(min(d00_09$acousticness), max(d00_09$acousticness))))
bp_10 = as.grob(~boxplot(d10_20$acousticness,horizontal=FALSE, main='Boxplot d10_20', ylab='acousticness', ylim=c(min(d10_20$acousticness), max(d10_20$acousticness))))
# install.packages('ggpubr')
library(ggpubr)
# install.packages('farver')
library(farver)
bp_list <- list(bp_20, bp_50, bp_80, bp_00, bp_10)
ggarrange(plotlist = bp_list, labels = c('20\'s to \'49', '50\'s to \'79', '80\'s to \'99', '00\'s to \'09', '10\'s to \'20'), nrow = 1)
dev.off()
# test the shifting with skeweness: confirmed
# install.packages('moments')
library(moments)
skewness(d20_49$acousticness) # -2.340799
skewness(d50_79$acousticness) # -0.5802139
skewness(d80_99$acousticness) # 0.8749373
skewness(d00_09$acousticness) # 1.048702
skewness(d10_20$acousticness) # 1.131833

# test through kurtosis if artists followed the trend!
kurtosis(d20_49$acousticness) # 7.415011 -> the music was entirely acoustic because of technological reasons
kurtosis(d50_79$acousticness) # 1.96459
kurtosis(d80_99$acousticness) # 2.430211
kurtosis(d00_09$acousticness) # 2.818377
kurtosis(d10_20$acousticness) # 3.0802

##################################################

# it would be cool have the mean of the variables each year every year plotted with an explanation
mean_master = aggregate(dataset[, -length(dataset)], list(dataset$year), mean)
dim(mean_master)
head(mean_master)

for (i in 2:length(mean_master)) {
  plot(mean_master[, 1], mean_master[, i], type="l", col="blue", lwd=3, xlab="year", ylab=names(mean_master)[i], main=paste("100 yrs of", names(mean_master)[i]))
}

