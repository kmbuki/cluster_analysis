# CLuster Analysis using Iris flower data set – set of three related species 
# of Iris flowers.
# The data contains 50 items for each of the three species of Iris flowers.
# The length and width of the sepals and petals of the flowers are included 
# for each item (4 variables).

# Tutorial here 
# https://cran.r-project.org/web/packages/dendextend/vignettes/Cluster_Analysis.html

library(dplyr)

# Get data from here
iris_data <- read.csv(
  "https://archive.ics.uci.edu/ml/machine-learning-databases/iris/iris.data", header = TRUE)

# Or get it this way
iris <- datasets::iris

# Dimensions of the dataset
summary(iris)
nrow(iris)
ncol(iris)
dim(iris)

# Exclude rows/columns by negative indexing  - exclude column 5 -
# Removes species column
iris2 <- iris[,-5]

# Select column number 5
species_labels <- iris[,5]
library(colorspace) # get nice colors

# rev gives a reversed version of its arguments
# rainbow creates a vector of n colors
species_col <- rev(rainbow(3))[as.numeric(species_labels)]

# Plot a splom:
# A splot is a scatter plot matrix
pairs(iris2, col = species_col,
      lower.panel = NULL,
      cex.labels=2, pch=19, cex = 1.2)

# Formating
# Add a legend for the flower soecies
par(xpd = TRUE)
legend(x = 0.1, y = 0.4, cex = 1,
       legend = as.character(levels(species_labels)),
       fill = unique(species_col))
par(xpd = NA)

# parallel coordinates plot 
# read more here -> 
# http://blog.safaribooksonline.com/2014/03/31/mastering-parallel-coordinate-charts-r/
par(las = 1, mar = c(4.5, 3, 3, 2) + 0.1, cex = .8)
MASS::parcoord(iris2, col = species_col, var.label = TRUE, lwd = 2)

# Add Title
title("Parallel coordinates plot of the Iris data")

# Add a legend
par(xpd = TRUE)
legend(x = 1.85, y = -.19, cex = 1,
       legend = as.character(levels(species_labels)),
       fill = unique(species_col), horiz = TRUE)


# Make clusters using complete method
# dist --> Distance matrix computation
  # --> This function computes and returns the distance matrix computed by using
  # the specified distance measure to compute the distances between the rows of 
  # a data matrix using the 
  # eclidean method. (Usual distance between the two vectors (2 norm aka L_2), 
  # sqrt(sum((x_i - y_i)^2)).)
d_clust <- dist(iris2)
h_clust <- hclust(d_clust, method = "complete")
iris_species <- rev(levels(iris[,5]))

library(dendextend)
dend <- as.dendrogram(h_clust)
# order it the closest we can to the order of the observations:
dend <- rotate(dend, 1:150)

# Color the branches based on the clusters:
dend <- color_branches(dend, k=3) #, groupLabels=iris_species)

# Manually match the labels, as much as possible, to the real 
# classification of the flowers:
labels_colors(dend) <-
  rainbow(3)[sort_levels_values(
    as.numeric(iris[,5])[order.dendrogram(dend)]
  )]

# We shall add the flower type to the labels:
labels(dend) <- paste(as.character(iris[,5])[order.dendrogram(dend)],
                      "(",labels(dend),")", 
                      sep = "")

# We hang the dendrogram a bit:
dend <- hang.dendrogram(dend,hang_height=0.1)
# reduce the size of the labels:
# dend <- assign_values_to_leaves_nodePar(dend, 0.5, "lab.cex")
dend <- set(dend, "labels_cex", 0.5)
# And plot:
par(mar = c(3,3,3,7))
plot(dend, 
     main = "Clustered Iris data set
     (the labels give the true flower species)", 
     horiz =  TRUE,  nodePar = list(cex = .007))
legend("topleft", legend = iris_species, fill = rainbow(3))


#### BTW, notice that:
# labels(hc_iris) # no labels, because "iris" has no row names
# is.integer(labels(dend)) # this could cause problems...
# is.character(labels(dend)) # labels are no longer "integer"

# the same could be represented ina circular layout
# Requires that the circlize package will be installed
par(mar = rep(0,4))
circlize_dendrogram(dend)


#Heat map for iris data set
some_col_func <- function(n) rev(colorspace::heat_hcl(
    n, c = c(80, 30), l = c(30, 90), power = c(1/5, 1.5)))

# scaled_iris2 <- iris2 %>% as.matrix %>% scale
# library(gplots)
gplots::heatmap.2(as.matrix(iris2), 
                  main = "Heatmap for the Iris data set",
                  srtCol = 20,
                  dendrogram = "row",
                  Rowv = dend,
                  Colv = "NA", # this to make sure the columns are not ordered
                  trace="none",          
                  margins =c(5,0.1),      
                  key.xlab = "Cm",
                  denscol = "grey",
                  density.info = "density",
                  RowSideColors = rev(labels_colors(dend)), 
                  # to add nice colored strips        
                  col = some_col_func
)

# Interactive heat map
d3heatmap::d3heatmap(as.matrix(iris2),
                     dendrogram = "row",
                     Rowv = dend,
                     colors = "Greens",
                     # scale = "row",
                     width = 900,
                     height = 600,
                     show_grid = FALSE)



# Clustering methods diff and similarities
# ?hclust 
  # --> Hierarchical cluster analysis on a set of 
  #  dissimilarities and methods for analyzing it.

  # --> hclust(d, method = "complete", members = NULL)

hclust_methods <- c("ward.D", "single", "complete", "average", "mcquitty", 
                    "median", "centroid", "ward.D2")

iris_dendlist <- dendlist()
for(i in seq_along(hclust_methods)) {
  hc_iris <- hclust(d_clust, method = hclust_methods[i])   
  iris_dendlist <- dendlist(iris_dendlist, as.dendrogram(hc_iris))
}
names(iris_dendlist) <- hclust_methods
iris_dendlist


# cophenetic correlation between each clustering result using cor.dendlist. 
iris_dendlist_cor <- cor.dendlist(iris_dendlist)
iris_dendlist_cor

# load package corrplot
corrplot::corrplot(iris_dendlist_cor, "pie", "lower")


# what if we use spearmans coefficient of relation
iris_dendlist_cor_spearman <- cor.dendlist(
  iris_dendlist, method_coef = "spearman")
corrplot::corrplot(iris_dendlist_cor_spearman, "pie", "lower")


# The `which` parameter allows us to pick the elements in the list to compare
iris_dendlist %>% dendlist(which = c(1,8)) %>% ladderize %>% 
set("branches_k_color", k=3) %>% 
untangle(method = "step1side", k_seq = 3:20) %>%
set("clear_branches") %>% #otherwise the single lines are not black, 
# since they retain the previous color from the branches_k_color.
tanglegram(faster = TRUE) # (common_subtrees_color_branches = TRUE)



# The `which` parameter allows us to pick the elements in the list to compare
iris_dendlist %>% dendlist(which = c(1,4)) %>% ladderize %>% 
# untangle(method = "step1side", k_seq = 3:20) %>%
set("rank_branches") %>%
tanglegram(common_subtrees_color_branches = TRUE)



We # So we have 39 sub-trees that are identical between the two dendrograms:
  
length(unique(common_subtrees_clusters(
  iris_dendlist[[1]], iris_dendlist[[4]]))[-1])
## [1] 39
# -1 at the end is because we are ignoring the "0" subtree, which indicates 
# leaves that are singletons.

iris_dendlist %>% dendlist(which = c(3,4)) %>% ladderize %>% 
  untangle(method = "step1side", k_seq = 2:6) %>%
  set("branches_k_color", k=2) %>% 
  tanglegram(faster = TRUE) # (common_subtrees_color_branches = TRUE)


# To plot all 8 methods to see this phenomenon 
# (i.e.: that “complete” has its smaller cluster larger than it is in all the 
# other clustering methods):

par(mfrow = c(4,2))
for(i in 1:8) {
  iris_dendlist[[i]] %>% set("branches_k_color", k=2) %>% plot(axes = FALSE, horiz = TRUE)
  title(names(iris_dendlist)[i])
}


iris_dendlist_cor2 <- cor.dendlist(iris_dendlist, method = "common")
iris_dendlist_cor2


# Plotting it:

corrplot::corrplot(iris_dendlist_cor2, "pie", "lower")

# Clustering prediction of the 3 species classes
get_ordered_3_clusters <- function(dend) {
  cutree(dend, k = 3)[order.dendrogram(dend)]
}

dend_3_clusters <- lapply(iris_dendlist, get_ordered_3_clusters)

compare_clusters_to_iris <- function(clus) {FM_index(clus, rep(1:3, each = 50), assume_sorted_vectors = TRUE)}

clusters_performance <- sapply(dend_3_clusters, compare_clusters_to_iris)
dotchart(sort(clusters_performance), xlim = c(0.7,1),
         xlab = "Fowlkes-Mallows Index (from 0 to 1)",
         main = "Perormance of clustering algorithms \n in detecting the 3 species",
         pch = 19)


## Conclusion
#The Iris data set is only 4-dimensional, making it possible to explore using 
# pairs plot (SPLOM) or parallel coordinates plot. It is clear from these that 
# two main clusters are visible, while the separation of the third cluster is 
# difficult.

# In the above analysis, we learned that the complete method fails to do the 
# proper separation of the two main clusters when cut in k=2 (but succeeds in 
# doing it, if moving to k=3 clusters). This is different from all the other 
# 7 methods available in hclust, which do succeed in separating the 2 main 
# clusters from the beginning (i.e.: for k=2).

# We also noticed that all clustering algorithms share a relatively high 
# proportion of common nodes (between 75% to 90%).