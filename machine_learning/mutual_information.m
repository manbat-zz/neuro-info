% Mutual Information
% This shows why mutual information is important for registration, more-so
% than another metric like the least sum of squares.

% First, let's read in two pickle images that we want to register
pickle1 = imread('pickle1.png');
pickle2 = imread('pickle2.png');

% Let's look at our lovely pickles, pre registration
figure(1); subplot(1,2,1); imshow(pickle1); title('Pre-registration')           
           subplot(1,2,2); imshow(pickle2);

% Matlab has a nice function, imregister, that we can configure to do the heavy lifting
template = pickle1; % fixed image
input = pickle2;    % We will register pickle2 to pickle1
transformType = 'affine'; % Move it anyhow you please, Matlab.

% Matlab has a function to help us specify how we will optimize the
% registration.  We actually are going to tell it to do 'monomodal' because
% this should give us the least sum of squared distances...
[optimizer, metric] = imregconfig('monomodal');

% Now let's look at what "metric" is:
metric = 

  registration.metric.MeanSquares

% Now let's look at the documentation in the script itself:
% A MeanSquares object describes a mean square error metric configuration
% that can be passed to the function imregister to solve image
% registration problems. The metric is an element-wise difference between
% two input images. The ideal value of the metric is zero.

% This is what we want! Let's do the registration:
moving_reg = imregister(input,template,transformType,optimizer,metric);

% And take a look at our output, compared to the image that we wanted to
% register to:
figure(2); subplot(1,2,1); imshow(template); title('Registration by Min. Mean Squared Error')
           subplot(1,2,2); imshow(moving_reg);

% Where did my pickle go?!

% Now let's select "multimodal" and retry the registration.  This will use
% mutual information.
[optimizer, metric] = imregconfig('multimodal');

MattesMutualInformation Mutual information metric configuration object
 
    A MutualInformation object describes a mutual information metric
    configuration that can be passed to the function imregister to solve
    image registration problems.

% Now the metric is mutual information! Matlab, you are so smart!
moving_reg = imregister(input,template,transformType,optimizer,metric);

% Let's take one last look... 
figure(3); subplot(1,2,1); imshow(template); title('Registration by Max. Mutual Information')
           subplot(1,2,2); imshow(moving_reg);
           
% Hooray! Success!
