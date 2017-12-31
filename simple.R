library(datasets)
head(iris)

# After a little bit of exploration, I found that Petal.Length and Petal.Width 
# were similar among the same species but varied considerably between different 
# species

library(ggplot2)
ggplot(iris, aes(Petal.Length, Petal.Width, color = Species)) + geom_point()

# output in the /simple folder


# Clustering
set.seed(20)
irisCluster <- kmeans(iris[, 3:4], 3, nstart = 20)
irisCluster
# K-means clustering with 3 clusters of sizes 46, 54, 50


# Cluster means:
#   Petal.Length Petal.Width
# 1     5.626087    2.047826
# 2     4.292593    1.359259
# 3     1.462000    0.246000

# Within cluster sum of squares by cluster:
#   [1] 15.16348 14.22741  2.02200
# (between_SS / total_SS =  94.3 %)
# 
# Available components:
#   
#   [1] "cluster"      "centers"      "totss"        "withinss"    
# [5] "tot.withinss" "betweenss"    "size"         "iter"        
# [9] "ifault"



# Let us compare the clusters with the species.
# 
table(irisCluster$cluster, iris$Species)


# Lets plot the data to see the clusters:

irisCluster$cluster <- as.factor(irisCluster$cluster)
ggplot(iris, aes(Petal.Length, Petal.Width, color = irisCluster$cluster)) + geom_point()