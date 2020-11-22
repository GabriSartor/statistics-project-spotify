####################################
### SPOTIFY DATASET PREPROCESSING ##
####################################

## Read the raw data
spotify = read.csv('data/spotify_data.csv')

## Keep only categorical and numerical columns
spotify_processed <- spotify[, c(1,3, 5:6,8:12, 14, 16:19)]

## Add 2 calculated columns which are duration in seconds
## and the decade the track belongs to
spotify_processed$duration_s = spotify$duration_ms / 1000
spotify_processed$decade =   as.numeric((floor( (spotify$year-1) / 10) * 10))

## Save the pre-processed dataset in a new csv for ease of use
write.csv(spotify_processed, 'data/spotify_data_processed.csv')

attach(spotify_processed)

## Count the number of track in each decade
for (i in seq(1920, 2010, 10)) {
  print(c("Year:", i, "count:", length(which(decade==i))) )
}

## Selecting 9 time intervals the number of tracks for each interval is almost constant
## with 15-20k tracks present in each one
## LIST: 1921-1940, 1941-1950, 1951-1960, 1961-1970, 1971-1980, 1981-1990, 1991-2000, 2001-2010, 2011-2020


## As easily predictable popularity is very low for tracks before the 50-60's
hist(popularity[c(which(decade==1920), which(decade==1930))])
hist(popularity[which(decade==1940)])
hist(popularity[which(decade==1950)])
hist(popularity[which(decade==1960)])
hist(popularity[which(decade==1970)])
hist(popularity[which(decade==1980)])
hist(popularity[which(decade==1990)])
hist(popularity[which(decade==2000)])
hist(popularity[which(decade==2010)])
