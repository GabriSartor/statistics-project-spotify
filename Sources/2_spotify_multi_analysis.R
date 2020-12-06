###################################
######## Statistics project #######
## 100 Years of Music on Spotify ##
##### Part 2 - Multivariate analysis #####
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

n_dataset_NP = clean_data[c("acousticness", "danceability", "energy",  "liveness", "loudness", "speechiness", "tempo", "valence")]

# Multivariate Analysis

#Correlation matrix
mcor<-cor(n_dataset_NP,use="na.or.complete")
mcor[upper.tri(mcor)]<-""
cor_matrix2<-as.data.frame(mcor)
plot(cor_matrix2)

# correlation table vith values
library(corrplot)
cor(n_dataset_NP)
corrplot(cor(n_dataset_NP), method="number", type="upper")
corrplot(cor(n_dataset_NP), method="circle", type="upper")


#####
#PCA#
#####
## COLORS:
# Spotify green #1DB954
# Petrol #398488
# Red #BE1111
# Dark grey #313131

library(FactoMineR)
library(factoextra)

pc<-prcomp(scale(n_dataset_NP)) #PCA
summary(pc)
pc$rotation
#Components and variability explained
#TO update graphics
fviz_eig(pc, barfill = "#1DB954",
         barcolor = "#1DB954",
         linecolor = "black")

#Nice graphic for PC1 and PC2
fviz_pca_var(pc,
             col.var = "contrib", # Color by contributions to the PC
             gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"),
             repel = TRUE     # Avoid text overlapping
)

pca2_var<-colnames(n_dataset_NP)

pca2<-PCA(scale(n_dataset_NP),graph=F)
plot(pca2,choix="var")
summary(pca2)

# PCA GRAPHIC 2
n_dataset.sd <- scale(n_dataset_NP)
n_dataset.sd <- data.frame(n_dataset.sd)

pc.n_dataset <- princomp(n_dataset.sd, scores=T)
pc.n_dataset
summary(pc.n_dataset)

layout(matrix(c(2,3,1,3),2,byrow=T))
plot(pc.n_dataset, las=2, main='Principal components', ylim=c(0,4))
abline(h=1, col='blue')
barplot(sapply(n_dataset.sd,sd)^2, las=2, main='Original variables', ylim=c(0,2), ylab='Variances')
plot(cumsum(pc.n_dataset$sde^2)/sum(pc.n_dataset$sde^2), 
     type='b', 
     axes=F, 
     xlab='Number of components', 
     ylab='Contribution to the total variance', 
     ylim=c(0,1))
box()
axis(2,at=0:10/10,labels=0:10/10)
axis(1,at=1:ncol(n_dataset.sd),labels=1:ncol(n_dataset.sd),las=2)

