%function Main_CNN_ImageNet_minimal()
% Minimalistic demonstration of how to run an ImageNet CNN model

% setup toolbox
addpath(genpath('../CoreModules'))
% download a pre-trained CNN from the web
if ~exist('imagenet-vgg-f.mat', 'file')
  fprintf('Downloading a model ... this may take a while\n') ;
  urlwrite('http://www.vlfeat.org/matconvnet/models/imagenet-vgg-f.mat', ...
    'imagenet-vgg-f.mat') ;
end
net = load('imagenet-vgg-f.mat') ;

% obtain and preprocess an image
im = imread('test_im.JPG') ;
im_ = single(im) ; % note: 255 range
im_ = imresize(im_, net.meta.normalization.imageSize(1:2)) ;
im_ = im_ - net.meta.normalization.averageImage ;

% run the CNN
opts=[];
opts.use_gpu=0;%unless you have a good gpu
opts.use_nntoolbox=0; %Requires Neural Network Toolbox to use it.

opts.training=0;
opts.use_corr=1;
res(1).x=im_;

if opts.use_gpu
    net=SwitchProcessor(net,'gpu');
end
tic;
[ net,res,opts ] = net_ff( net,res,opts );
toc;
% show the classification result
scores = squeeze(gather(res(end).x)) ;
[bestScore, best] = max(scores) ;
figure(1) ; clf ; imagesc(im) ;
title(sprintf('%s (%d), score %.3f',...
   net.meta.classes.description{best}, best, bestScore)) ;
drawnow;

