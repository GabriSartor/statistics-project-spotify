spotify = read.csv('data/spotify_data.csv')
spotify_processed <- spotify[, c(1,3, 5:6,8:12, 14, 16:19)]
spotify_processed$duration_s = spotify$duration_ms / 1000
write.csv(spotify_processed, 'data/spotify_data_processed.csv')
