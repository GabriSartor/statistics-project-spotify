###################################
######## Statistics project #######
## 100 Years of Music on Spotify ##
# Part 2 - Multivariate analysis ##
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

#################################################

# Multivariate Analysis

# variance and covariance
round(cor(n_dataset), 2)

# correlation table vith values
corrplot(cor(n_dataset), method="number", type="upper")
