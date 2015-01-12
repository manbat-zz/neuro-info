% Section 3: Image Analysis Self Portrait Lab
% BMI 260 - Spring 2013
% Designed by TA Vanessa Sochat

% Step 1: Provide students with images, have them save to computer, open Matlab, and new .m file
% Make sure students have supplementary scripts in this folder
% Emphasize that we will be doing simple applications of functions, and
% students should use "help [function]" to learn more


%% Step 2: Instruct in how to read in image, and look at matrix of numbers
img = imread('vanessa.jpeg');   % semicolon suppreses output
size(img);                      % three color channels 
figure(1); imshow(img);         % Display the image

% EXTRA
figure(2);                      % Visualize the channels
subplot(1,3,1); imshow(img(:,:,1));
subplot(1,3,2); imshow(img(:,:,2));
subplot(1,3,3); imshow(img(:,:,3));

%% Convert to grayscale - emphasize that the value of the pixel represents
% scale from white to black, similar to many medical imaging modalities
% where color based on tissue composition.
gray = rgb2gray(img);
size(gray);                    % Now we have one channel
imshow(gray);

% Step 3: Crop to a particular size
crop = imcrop(gray);

% Step 4: How to save a new image
imwrite(crop,'vanessa_cropped.jpg','jpg');

%% Image properties (histogram)
imhist(crop); title('Intensity distribution of my image');
enhanced = imadjust(crop);
figure(3); subplot(1,2,1); imshow(enhanced); title('Contrast Enchanced');  % Contrast enchanced
subplot(1,2,2); imshow(crop); title('original');                           % Original

% Now use graythresh (Otsu's method) to calculate threshold
thresh = graythresh(enhanced);
img = im2bw(enhanced,thresh);

% Look at thresholded image - pixel values are 0 (black) and 1(white)
figure(4); imshow(img);
imhist(img)

% SAVE IMAGE

%% Region growing (Remind students about the idea of connectivity – that we grow our region based on a certain number / pattern of neighboring pixels, and it can be done in 2D or 3D).

% Remember that enhanced is our current image data

% Image data is first, then x,y of seedpoint, then threshold of difference
% between region mean and pixel mean (we stop when greater than this
% threshold)
[P,J] = regiongrowing(enhanced);

% Generate a random color
color = rand(1,3);
figure, 
I = imoverlay(enhanced, J, color);
imshow(I);

% Perform region growing with at least three things in the picture, and
% three colors (write in a loop!)

for i=1:3
    [P,J] = regiongrowing(enhanced);
    color = rand(1,3);
    I = imoverlay(I, J, color);
end

figure; imshow(I);

% You can also do in 3D, and it works the same way but with
% more neighbors

% SAVE IMAGE

%% Convolution

% Set our sobel filter to find horizontal edges
s = [1 2 1; 0 0 0; -1 -2 -1];

% Do the convolution
H = conv2(enhanced,s);
mesh(H)

% Invert the filter to get vertical edges
V = conv2(enhanced,s');
mesh(H);

% Combine the two!
figure
both = sqrt(H.^2 + V.^2);
mesh(both)

% Look at histogram of image values
hist(both);

% Threshold the data to create an edge mask
imshow(both > 150);

% SAVE IMAGE


%% Canny Edge Detection

canny(enhanced,5,.2,.2)

%% Median Filtering

% First let's add some salt and pepper noise
% last argument is noise intensity
salt_pepper_img = imnoise(enhanced,'salt & pepper',.05);

% Perform median filtering with default 3x3 neighborhood
fixed_img = medfilt2(salt_pepper_img);

% Visualize noise
figure; 
subplot(1,3,1); imshow(enhanced);
title('Original Image');
subplot(1,3,2); imshow(salt_pepper_img);
title('Image with Added Noise');
subplot(1,3,3); imshow(fixed_img);
title('Median Filtered Image');

% SAVE IMAGE
%% Meyer Watershed

% First calculate gradient in x and y direction, and combine (sobel filter)
hy = fspecial('sobel');
hx = hy';
Iy = imfilter(double(crop), hy, 'replicate');
Ix = imfilter(double(crop), hx, 'replicate');
gradmag = sqrt(Ix.^2 + Iy.^2);

% Threshold the gradient magnitude to get a cleaner map
gradmag2 = gradmag > 100;

% Compare the original and thresholded gradients
figure, subplot(1,2,1); imshow(gradmag,[]), title('Gradient Magnitude'); 
subplot(1,2,2); imshow(gradmag2,[]); title('Thresholded');

% Perform watershed segmentation
L = watershed(gradmag2,8);
Lrgb = label2rgb(L);

% Look at results
figure, subplot(1,3,1); imshow(gradmag,[]), title('Gradient Magnitude'); 
subplot(1,3,2); imshow(gradmag2,[]); title('Thresholded');
subplot(1,3,3); imshow(Lrgb), title('Watershed transform of gradient magnitude (Lrgb)')

% SAVE IMAGE
