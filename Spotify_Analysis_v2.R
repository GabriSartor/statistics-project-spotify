# set wd and import dataset
setwd("~/Documents/statistics-project-spotify/data")
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
length(data$duration_s[which(data$duration_s>q3+6*iqr)])

dim(data)
dataset <- subset(data, data$duration_s > (q1 - 1.5*iqr) & data$duration_s < (q2+6*iqr))

n_dataset = dataset[c("acousticness", "danceability", "duration_s", "energy", 'instrumentalness', 'popularity', "liveness", "loudness", "speechiness", "tempo", "valence")]
dimnames(n_dataset)
names(n_dataset)

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

##################################################

# it would be cool have the mean of the variables each year every year plotted with an explanation
mean_master = aggregate(n_dataset[, -length(n_dataset)], list(n_dataset$year), mean)
dim(mean_master)
head(mean_master)

for (i in 2:length(mean_master)) {
  plot(mean_master[, 1], mean_master[, i], type="l", col="blue", lwd=3, xlab="year", ylab=names(mean_master)[i], main=paste("100 yrs of", names(mean_master)[i]))
}

#################################################

# first we use the mean, we notice in the output one-time hit artist
# artist who recently got a hit (how recent is weighted on the 'populatity' variable) a not many more song (low denominator).
pop_artist = aggregate(dataset$popularity, list(dataset$artists), mean)
sort_pa = pop_artist[order(pop_artist[, 2],decreasing=TRUE),]
head(sort_pa)

# using the sum, we encounter in the output long time established artist with several evergreen
# each one with high values of 'populariry'
pop_artist = aggregate(dataset$popularity, list(dataset$artists), sum)
sort_pa = pop_artist[order(pop_artist[, 2],decreasing=TRUE),]
head(sort_pa)
sort_pa[1:10, ]

# the most popular songs
pop_songs = dataset[order(dataset[, "popularity"], decreasing=TRUE),]
pop_songs[1:3, "name"]


