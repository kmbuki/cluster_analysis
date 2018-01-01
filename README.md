# Cluster Analysis
Clustering can be considered the most important unsupervised learning problem; so, as every other problem of this kind, it deals with finding a structure in a collection of unlabeled data. A loose definition of clustering could be “the process of organizing objects into groups whose members are similar in some way”. 
> A cluster is therefore a collection of objects which are “similar” between them and are “dissimilar” to the objects belonging to other clusters.


## Goals of Clustering
So, the goal of clustering is to determine the intrinsic grouping in a set of unlabeled data. But how to decide what constitutes a good clustering? 
It can be shown that there is no absolute “best” criterion which would be independent of the final aim of the clustering. Consequently, it is the user which must supply this criterion, in such a way that the result of the clustering will suit their needs.

### Hierarchical agglomerative clustering
Hierarchical clustering (also called hierarchical cluster analysis or HCA) is a method of cluster analysis which seeks to build a hierarchy of clusters. Strategies for hierarchical clustering generally fall into two types:

1. __Agglomerative__: This is a "bottom up" approach: each observation starts in its own cluster, and pairs of clusters are merged as one moves up the hierarchy. Bottom-up algorithms treat each document as a singleton cluster at the outset and then successively merge (or agglomerate) pairs of clusters until all clusters have been merged into a single cluster that contains all documents.

2. __Divisive__: This is a "top down" approach: all observations start in one cluster, and splits are performed recursively as one moves down the hierarchy. Top-down clustering requires a method for splitting a cluster.

The tutorial covers how the dendextend R package can be used to enhance Hierarchical Cluster Analysis (through better visualization and sensitivity analysis).


### K-Means Clustering
An effective, widely used, all-around clustering algorithm. Before actually running it, we have to define a distance function between data points (for example, Euclidean distance if we want to cluster points in space), and we have to set the number of clusters we want (k).

The pseudo-python code shows how we can run k-means on a dataset. 


### Affinity propagation
To be done...

 
