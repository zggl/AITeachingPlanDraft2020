clear all;
addpath(genpath('../CoreModules'));
n_epoch=25;
dataset_name='cifar';
network_name='cnn';
use_gpu=(gpuDeviceCount>0) %use gpu or not 
if use_gpu
    %Requires Neural Network Toolbox to use it.
    opts.use_nntoolbox=license('test','neural_network_toolbox')
end
%function handle to prepare your data
PrepareDataFunc=@PrepareData_CIFAR_CNN;
%function handle to initialize the network
NetInit=@net_init_cifar_cnn;

%automatically select learning rates
use_selective_sgd=1;
%select a new learning rate every n epochs
ssgd_search_freq=10;
learning_method=@sgd2;%training method: @sgd,@adagrad,@rmsprop,@adam,@sgd2
opts.parameters.weightDecay=5e-4;
sgd_lr=1.0;%This is unnecessary as lr is automatically determined. 

Main_Template(); %call training template
