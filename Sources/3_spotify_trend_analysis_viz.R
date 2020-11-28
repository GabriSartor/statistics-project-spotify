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

#Create an only numerical dataset
numerical_columns_names <- c("popularity", "instrumentalness", "acousticness", "danceability", "energy", "liveness", "loudness", "speechiness", "tempo", "valence", "duration_s")

n_dataset = clean_data[numerical_columns_names]
dimnames(n_dataset)
names(n_dataset)

##################################################

# it would be cool have the mean of the variables each year every year plotted with an explanation
mean_master = aggregate(n_dataset[, -length(n_dataset)], list(clean_data$year), mean)
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
write.csv(sort_pa[1:10,],"top_mean_pop_artist.csv", row.names = FALSE)

# using the sum, we encounter in the output long time established artist with several evergreen
# each one with high values of 'populariry'
pop_artist = aggregate(clean_data$popularity, list(clean_data$artists), sum)
sort_pa = pop_artist[order(pop_artist[, 2],decreasing=TRUE),]
head(sort_pa)
write.csv(sort_pa[1:10,],"top_total_pop_artist.csv", row.names = FALSE)

# the most popular songs
pop_songs = clean_data[order(clean_data[, "popularity"], decreasing=TRUE),]
pop_songs[1:3, "name"]
write.csv(pop_songs[1:10,],"top_pop_songs.csv", row.names = FALSE)

#################################################









