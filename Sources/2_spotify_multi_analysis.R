#################################################
# DATASETS NAVIGATION:
#
# - clean_data: contains all 20 variables, all types, outlier cleaned
# {SUBSET OF clean_data}
#   - dataset: numerical values ('year' maintained for grouping purposes, even if categorical)
# {SUBSET OF dataset}
#     - n_dataset: numerical values (popularity included)     --> .sd --> n_dataset.sd (scaled version)
#     - n_dataset_NP: numerical values (without popularity)   --> .sd --> n_dataset_NP.sd (scaled version)

#################################################

dataset = clean_data[c('year', "acousticness", "danceability", "duration_s", "energy", 'instrumentalness', 'popularity', "liveness", "loudness", "speechiness", "tempo", "valence")]
n_dataset = dataset[c("acousticness", "danceability", "duration_s", "energy", 'instrumentalness', 'popularity', "liveness", "loudness", "speechiness", "tempo", "valence")]
n_dataset_NP = dataset[c("acousticness", "danceability", "duration_s", "energy", 'instrumentalness', "liveness", "loudness", "speechiness", "tempo", "valence")]


# Multivariate Analysis

# variance and covariance
round(var(n_dataset), 2); View(round(var(n_dataset), 2))
round(var(scale(n_dataset)), 2); View(round(var(scale(n_dataset)), 2))
round(cor(n_dataset_NP), 2); View(round(cor(n_dataset_NP), 2))

round(var(n_dataset_NP), 2); View(round(var(n_dataset_NP), 2))
round(var(scale(n_dataset_NP)), 2); View(round(var(scale(n_dataset_NP)), 2))
round(cor(n_dataset_NP), 2); View(round(cor(n_dataset_NP), 2))

# correlation table vith values
cor(n_dataset)
corrplot(cor(n_dataset), method="number", type="upper")

# PCA
n_dataset.sd <- scale(n_dataset)
n_dataset.sd <- data.frame(n_dataset.sd)

pc.n_dataset <- princomp(n_dataset.sd, scores=T)
pc.n_dataset
summary(pc.n_dataset)

layout(matrix(c(2,3,1,3),2,byrow=T))
plot(pc.n_dataset, las=2, main='Principal components', ylim=c(0,6))
abline(h=1, col='blue')
barplot(sapply(n_dataset.sd,sd)^2, las=2, main='Original variables', ylim=c(0,6), ylab='Variances')
plot(cumsum(pc.n_dataset$sde^2)/sum(pc.n_dataset$sde^2), type='b', axes=F, xlab='Number of components', ylab='Contribution to the total variance', ylim=c(0,1))
box()
axis(2,at=0:10/10,labels=0:10/10)
axis(1,at=1:ncol(n_dataset.sd),labels=1:ncol(n_dataset.sd),las=2)


# Cumulative Proportion  0.3117392 0.4581311 0.5639063 0.6582767 0.73789660 0.81577504 0.88034955 0.92994783 0.96287794 0.98886493

