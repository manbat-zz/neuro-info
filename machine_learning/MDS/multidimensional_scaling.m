% Multidimensional scaling (MDS) Example

% Load matlab cities data
load cities

% This data has cities in rows, and different categories for ratings in
% columns.  We will implement MDS to assess city similarity based on
% ratings.

% Step 1: Set up our proximity matrix
% First let's create our similarity (proximity) matrix by calculating the
% euclidian distance between pairwise cities
proximities = zeros(size(ratings,1));

for i=1:size(ratings,1)
    for j =1:size(ratings,1)
        proximities(i,j) = pdist2(ratings(i,:),ratings(j,:),'euclidean');
    end
end

% Step 2: Create our centering matrix
% Now we need to perform double centering.  I'm going to define these
% matrices explicitly so it's clear

% This is an identity matrix of size n, where n is the size of our nxn
% proximity matrix that we just made
n = size(proximities,1);

identity = eye(n);

% This is an equally sized matrix of 1s
one = ones(n);

% Here is our centering matrix, commonly referred to as "J"
centering_matrix = identity - (1/n) * one;

J = centering_matrix;

% Step 3: Apply double centering, meaning we square our proximity matrix,
% and multiply it by J on each side with a -.5 coefficient
B = -.5*J*(proximities).*(proximities)*J;

% Step 4: Extract some M eigen values and vectors, where M is the dimension
% we are projecting down to:
M = 2; % so we can plot in 2D
[eigvec,eigval] = eig(B);

% We want to get the top M...
[eigval, order] = sort(max(eigval)','descend');
eigvec = eigvec(order,:);
eigvec = eigvec(:,1:M); % Note that eigenvectors are in columns
eigval = eigval(1:M);

% Plop them back into the diagonal of a matrix
A = zeros(2);
A(1:3:end) = eigval;

% If we multiply eigenvectors by eigenvalues, we get our new representation
% of the data, X:
X = eigvec*A;

% We can now look at our cities in 2D:
plot(X(:,1),X(:,2),'o')
title('Example of Classical MDS with M=2 for City Ratings');

% Grab just the state names
% NOTE: doesn't work perfectly for all, but it's good enough!
cities = cell(size(names,1),1);
for c=1:size(names,1)
    cities{c} = deblank(names(c,regexp(names(c,:),', ')+2:end));
end

% Select a random subset of 20 labels
y = randsample(size(cities,1),20);

% Throw on some labels!
text(X(y,1), X(y,2), cities(y), 'VerticalAlignment','bottom', ...
                             'HorizontalAlignment','right')



