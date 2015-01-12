# Self Organizing Maps TUtorial
# vsochat@stanford.edu

## When to make one?
# Load the kohonen package and mtcars data
library(kohonen)
data(mtcars)

# We need a data matrix (not a data frame)
data = as.matrix(mtcars)

# Create the SOM - grid must be smaller than N training samples
# if we aren't going to resample
som = som(data, grid = somgrid(5, 6, "hexagonal"))
summary(som)

# Plot the SOM
plot(som)

# Get comfortable with the SOM object
# Here are node coordinates
head(som$grid$pts)

#  Here are the nodes ("meta cars")
head(som$codes)

# Here are assignments of training to nodes in SOM
som$unit.classif

# Do our own plot - SOM centers as organge circles, add text corresponding
# to matched cars
assignedCars = som$unit.classif
labels = rownames(data)[assignedCars]
plot(som$grid$pts,main="SOM Car Lattice", 
     col="orange",xlab="Nodes", 
     ylab="Nodes",pch=19,cex=6)
text(som$grid$pts,labels,cex=.6)

# Useful?

# Instead, take random car, match to all nodes, color map based on similarity
euc.dist <- function(x1, x2) sqrt(sum((x1 - x2) ^ 2))
car = data[sample(seq(1,nrow(data)),1),]
similarity = array(dim=length(car))
for (r in 1:nrow(som$codes)){
  similarity[r] = euc.dist(car,som$codes[r,])
}

# We need a color palette
library(RColorBrewer)
rbPal <- colorRampPalette(brewer.pal(9,"YlOrRd"))
color = rbPal(10)[as.numeric(cut(similarity,breaks = 10))]


# Plot again, color by match score
plot(som$grid$pts,main="SOM Car Lattice", 
     col=color,xlab="Nodes", 
     ylab="Nodes",pch=22,cex=round(similarity)/20)
text(som$grid$pts,labels,cex=.6)
