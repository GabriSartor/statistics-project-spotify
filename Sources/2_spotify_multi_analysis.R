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
n_dataset = clean_data[c("acousticness", "danceability", "duration_s", "energy", 'instrumentalness', 'popularity', "liveness", "loudness", "speechiness", "tempo", "valence")]
n_dataset_NP = clean_data[c("acousticness", "danceability", "energy",  "liveness", "loudness", "speechiness", "tempo", "valence")]

library(FactoMineR)
library(factoextra)

pc<-prcomp(scale(n_dataset_NP)) #PCA
summary(pc)
pc$rotation
fviz_eig(pc)

#par("mar")
#par(mar=c(2.1,2.1,2.1,2.1))
fviz_pca_var(pc,
             col.var = "contrib", # Color by contributions to the PC
             gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"),
             repel = TRUE     # Avoid text overlapping
)



pca2_var<-colnames(n_dataset)

pca2<-PCA(scale(n_dataset_NP),graph=F)
plot(pca2,choix="var")
summary(pca2)

cluster2<-HCPC(pca2,nb.clust=4,graph=F)
plot(cluster2,choice="tree")
plot(cluster2,choice="map")

#CA
ca_data<-table(data$sesso_età, data$fumatore) #contingency table
ca<-CA(ca_data,graph=F)
plot(ca,choice="ind")

numerical_columns_names <- c("acousticness", "danceability", "energy", "liveness", "loudness", "speechiness", "tempo", "valence")

pca2_var<-colnames(data)[c(6,20:31)]

pca2<-PCA(clean_data[,numerical_columns_names],graph=F)
plot(pca2,choix="var")

cluster2<-HCPC(pca2,nb.clust=4,graph=F)
plot(cluster2,choice="tree")
plot(cluster2,choice="map")

#Correlation matrix
mcor<-cor(clean_data[numerical_columns_names],use="na.or.complete")
mcor[upper.tri(mcor)]<-""
cor_matrix2<-as.data.frame(mcor)
plot(cor_matrix2)

# Multivariate Analysis

# variance and covariance
round(var(n_dataset), 2); View(round(var(n_dataset), 2))
round(var(scale(n_dataset)), 2); View(round(var(scale(n_dataset)), 2))
round(cor(n_dataset_NP), 2); View(round(cor(n_dataset_NP), 2))

round(var(n_dataset_NP), 2); View(round(var(n_dataset_NP), 2))
round(var(scale(n_dataset_NP)), 2); View(round(var(scale(n_dataset_NP)), 2))
round(cor(n_dataset_NP), 2); View(round(cor(n_dataset_NP), 2))

# correlation table vith values
library(corrplot)
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

