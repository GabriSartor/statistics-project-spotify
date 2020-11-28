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
mean_master = aggregate(dataset_NT[, -length(dataset_NT)], list(dataset_NT$year), mean)
dim(mean_master)
head(mean_master)

for (i in 2:length(mean_master)) {
  plot(mean_master[, 1], mean_master[, i], type="l", col="blue", lwd=3, xlab="year", ylab=names(mean_master)[i], main=paste("100 yrs of", names(mean_master)[i]))
}

#################################################

# first we use the mean, we notice in the output one-time hit artist
# artist who recently got a hit (how recent is weighted on the 'populatity' variable) a not many more song (low denominator).
pop_artist = aggregate(clean_data$popularity, list(clean_data$artists), mean)
sort_pa = pop_artist[order(pop_artist[, 2],decreasing=TRUE),]
head(sort_pa)

# using the sum, we encounter in the output long time established artist with several evergreen
# each one with high values of 'populariry'
pop_artist = aggregate(clean_data$popularity, list(clean_data$artists), sum)
sort_pa = pop_artist[order(pop_artist[, 2],decreasing=TRUE),]
head(sort_pa)
sort_pa[1:10, ]

# the most popular songs
pop_songs = clean_data[order(clean_data[, "popularity"], decreasing=TRUE),]
pop_songs[1:3, "name"]







