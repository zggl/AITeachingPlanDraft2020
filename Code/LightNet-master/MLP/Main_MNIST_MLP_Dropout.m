clear all;
addpath(genpath('../CoreModules'));
n_epoch=20; %training epochs
dataset_name='mnist'; %dataset name
network_name='mlp'; %network name
use_gpu=(gpuDeviceCount>0) %use gpu or not 
if use_gpu
    %Requires Neural Network Toolbox to use it.
    opts.use_nntoolbox=license('test','neural_network_toolbox')
end
%function handle to prepare your data
PrepareDataFunc=@PrepareData_MNIST_MLP;
%function handle to initialize the network
NetInit=@net_init_mlp_mnist_dropout;

%automatically select learning rates
use_selective_sgd=1; 
%select a new learning rate every n epochs
ssgd_search_freq=10; 
learning_method=@sgd; %training method: @sgd,@rmsprop,@adagrad,@adam
opts.parameters.mom=0.9;
opts.parameters.clip=1e1;
%sgd parameter 
%(unnecessary if selective-sgd is used)
sgd_lr=5e-2;

%opts.parameters.clip=1e-2;
opts.parameters.weightDecay=0;
opts.parameters.batch_size=500;


Main_Template(); %call training template