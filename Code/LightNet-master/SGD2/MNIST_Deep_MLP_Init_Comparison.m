clear all;

mnist_opts={};


addpath(genpath('../../CoreModules'));
n_epoch=20; %training epochs
dataset_name='mnist'; %dataset name
network_name='mlp'; %network name
use_gpu=0 %use gpu or not 
%function handle to prepare your data
PrepareDataFunc=@PrepareData_MNIST_MLP;
%function handle to initialize the network
NetInit=@net_init_mlp_mnist;

%automatically select learning rates
use_selective_sgd=1; 
%select a new learning rate every n epochs
ssgd_search_freq=10; 



disp('SGD2 initialization tolerance tests.')


%%%%%%%%%%%%%%%%%%%%%
disp('Initialization with N(0,10000^{2})')

learning_method=@sgd2; %training method: @sgd,@rmsprop,@adagrad,@adam
opts.hidden_nodes=128;
opts.layers=10;
opts.parameters.batch_size=500;
opts.f=1e4;
opts.use_nntoolbox=0;
opts.parameters.mom=0.9;
opts.parameters.weightDecay=1e-3;%1e-3
opts.display_msg=0;
opts.use_bnorm=0;opts.use_rmsnorm=1;
opts.parameters.mom_bn=0.1;opts.parameters.mom_rmsnorm=0.1;
opts.parameters.pcd_lambda=1e-0;
opts.parameters.large_inv=0;
opts.parameters.max_inv_size=300;
rng('default');
rng(0) ;
Main_Template(); %call training template

opts=rmfield(opts,'train');
opts=rmfield(opts,'test');
opts=rmfield(opts,'train_labels');
opts=rmfield(opts,'test_labels');

mnist_opts{end+1}=opts;
clear opts;



%%%%%%%%%%%%%%%%%%%%%%


disp('Initialization with N(0,1000^{2})')
learning_method=@sgd2; %training method: @sgd,@rmsprop,@adagrad,@adam
opts.hidden_nodes=128;
opts.layers=10;
opts.parameters.batch_size=500;
opts.f=1e3;
opts.use_nntoolbox=0;
opts.parameters.mom=0.9;
opts.parameters.weightDecay=1e-3;
%opts.parameters.clip=1e1;
opts.display_msg=0;
opts.use_bnorm=0;opts.use_rmsnorm=1;
opts.parameters.mom_bn=0.1;
opts.parameters.mom_rmsnorm=0.1;
opts.parameters.eps_rmsnorm=1e-2;
opts.parameters.pcd_lambda=1e0;    
opts.parameters.large_inv=0;
opts.parameters.max_inv_size=300;
rng('default');
rng(0) ;
Main_Template(); %call training template

opts=rmfield(opts,'train');
opts=rmfield(opts,'test');
opts=rmfield(opts,'train_labels');
opts=rmfield(opts,'test_labels');

mnist_opts{end+1}=opts;
clear opts;




%%%%%%%%%%%%%%%%%%%%%

disp('Initialization with N(0,100^{2})')
learning_method=@sgd2; %training method: @sgd,@rmsprop,@adagrad,@adam
opts.hidden_nodes=128;
opts.layers=10;
opts.parameters.batch_size=500;
opts.f=1e2;
opts.use_nntoolbox=0;
opts.parameters.mom=0.9;
opts.parameters.weightDecay=1e-3;
opts.display_msg=0;
opts.use_bnorm=0;opts.use_rmsnorm=1;
opts.parameters.mom_bn=0.1;opts.parameters.mom_rmsnorm=0.1;
opts.parameters.pcd_lambda=1e-0;
opts.parameters.large_inv=0;
opts.parameters.max_inv_size=300;
rng('default');
rng(0) ;
Main_Template(); %call training template

opts=rmfield(opts,'train');
opts=rmfield(opts,'test');
opts=rmfield(opts,'train_labels');
opts=rmfield(opts,'test_labels');

mnist_opts{end+1}=opts;
clear opts;






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp('Initialization with N(0,10)')
learning_method=@sgd2; %training method: @sgd,@rmsprop,@adagrad,@adam
opts.hidden_nodes=128;
opts.layers=10;
opts.parameters.batch_size=500;
opts.f=1e1;
opts.use_nntoolbox=0;
opts.parameters.mom=0.9;
opts.parameters.weightDecay=5e-4;
opts.display_msg=0;
opts.use_bnorm=0;opts.use_rmsnorm=1;
opts.parameters.mom_bn=0.1;opts.parameters.mom_rmsnorm=0.1;
opts.parameters.pcd_lambda=1e-0;
opts.parameters.large_inv=0;
opts.parameters.max_inv_size=300;
rng('default');
rng(0) ;
Main_Template(); %call training template

opts=rmfield(opts,'train');
opts=rmfield(opts,'test');
opts=rmfield(opts,'train_labels');
opts=rmfield(opts,'test_labels');

mnist_opts{end+1}=opts;
clear opts;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp('Initialization with N(0,1^{2})')
learning_method=@sgd2; %training method: @sgd,@rmsprop,@adagrad,@adam
opts.hidden_nodes=128;
opts.layers=10;
opts.parameters.batch_size=500;
opts.f=1e0;
opts.use_nntoolbox=0;
opts.parameters.mom=0.9;
opts.parameters.weightDecay=5e-4;
opts.display_msg=0;
opts.use_bnorm=0;opts.use_rmsnorm=1;
opts.parameters.mom_bn=0.1;opts.parameters.mom_rmsnorm=0.1;
opts.parameters.pcd_lambda=1e-0;
opts.parameters.large_inv=0;
opts.parameters.max_inv_size=300;
rng('default');
rng(0) ;
Main_Template(); %call training template

opts=rmfield(opts,'train');
opts=rmfield(opts,'test');
opts=rmfield(opts,'train_labels');
opts=rmfield(opts,'test_labels');

mnist_opts{end+1}=opts;
clear opts;


%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp('Initialization with N(0,0.1^{2})')
learning_method=@sgd2; %training method: @sgd,@rmsprop,@adagrad,@adam
opts.hidden_nodes=128;
opts.layers=10;
opts.parameters.batch_size=500;
opts.f=1e-1;
opts.use_nntoolbox=0;
opts.parameters.mom=0.9;
%opts.parameters.weightDecay=1e-4;
opts.display_msg=0;
opts.use_bnorm=0;opts.use_rmsnorm=1;
opts.parameters.mom_bn=0.1;opts.parameters.mom_rmsnorm=0.1;
opts.parameters.pcd_lambda=1e-0;
opts.parameters.large_inv=0;
opts.parameters.max_inv_size=300;
rng('default');
rng(0) ;
Main_Template(); %call training template

opts=rmfield(opts,'train');
opts=rmfield(opts,'test');
opts=rmfield(opts,'train_labels');
opts=rmfield(opts,'test_labels');

mnist_opts{end+1}=opts;
clear opts;


%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('Initialization with N(0,0.01^{2})')
learning_method=@sgd2; %training method: @sgd,@rmsprop,@adagrad,@adam
opts.hidden_nodes=128;
opts.layers=10;
opts.parameters.batch_size=500;
opts.f=1e-2;
opts.use_nntoolbox=0;
opts.parameters.mom=0.9;
%opts.parameters.weightDecay=0;
opts.display_msg=0;
opts.use_bnorm=0;opts.use_rmsnorm=1;
opts.parameters.mom_bn=0.1;opts.parameters.mom_rmsnorm=0.1;
opts.parameters.pcd_lambda=1e-0;
opts.parameters.large_inv=0;
opts.parameters.max_inv_size=300;
rng('default');
rng(0) ;
Main_Template(); %call training template

opts=rmfield(opts,'train');
opts=rmfield(opts,'test');
opts=rmfield(opts,'train_labels');
opts=rmfield(opts,'test_labels');

mnist_opts{end+1}=opts;
clear opts;


%%%%%%%%%%%%%%%%%%%%%





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('Initialization with N(0,0.001^{2})')
learning_method=@sgd2; %training method: @sgd,@rmsprop,@adagrad,@adam
opts.hidden_nodes=128;
opts.layers=10;
opts.parameters.batch_size=500;
opts.f=1e-3;
opts.use_nntoolbox=0;
opts.parameters.mom=0.9;
%opts.parameters.weightDecay=1e-4;
opts.display_msg=0;
opts.use_bnorm=0;opts.use_rmsnorm=1;
opts.parameters.mom_bn=0.1;opts.parameters.mom_rmsnorm=0.1;
opts.parameters.pcd_lambda=1e-0;
opts.parameters.large_inv=0;
opts.parameters.max_inv_size=300;
rng('default');
rng(0) ;
Main_Template(); %call training template

opts=rmfield(opts,'train');
opts=rmfield(opts,'test');
opts=rmfield(opts,'train_labels');
opts=rmfield(opts,'test_labels');

mnist_opts{end+1}=opts;
clear opts;


%%%%%%%%%%%%%%%%%%%%%




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('Initialization with N(0,0.0001^{2})')

learning_method=@sgd2; %training method: @sgd,@rmsprop,@adagrad,@adam
opts.hidden_nodes=128;
opts.layers=10;
opts.parameters.batch_size=500;
opts.f=1e-4;
opts.use_nntoolbox=0;
opts.parameters.mom=0.9;
%opts.parameters.weightDecay=1e-4;
opts.display_msg=0;
opts.use_bnorm=0;opts.use_rmsnorm=1;
opts.parameters.mom_bn=0.1;opts.parameters.mom_rmsnorm=0.1;
opts.parameters.pcd_lambda=1e0;
opts.parameters.large_inv=0;
opts.parameters.max_inv_size=300;
rng('default');
rng(0) ;
Main_Template(); %call training template

opts=rmfield(opts,'train');
opts=rmfield(opts,'test');
opts=rmfield(opts,'train_labels');
opts=rmfield(opts,'test_labels');

mnist_opts{end+1}=opts;
clear opts;


%%%%%%%%%%%%%%%%%%%%%



save('mnist_init_mlp_opts.mat','mnist_opts');

%%%%%%%%%%%%%%%%%%%%%

figure1 = figure;

% Create axes
axes1 = axes('Parent',figure1);

data=[];
for i=1:length(mnist_opts)
data=[data,mnist_opts{i}.results.TestEpochError];
end
plot1 =plot(data);
%ylim(axes1,[0 3]);

set(plot1(1),'DisplayName','N(0,10000^{2})','LineWidth',1);
set(plot1(2),'DisplayName','N(0,1000^{2})','LineWidth',1);
set(plot1(3),'DisplayName','N(0,100^{2})','LineWidth',1);
set(plot1(4),'DisplayName','N(0,10^{2})','LineWidth',1);
set(plot1(5),'DisplayName','N(0,1^{2})','LineWidth',1);
set(plot1(6),'DisplayName','N(0,0.1^{2})','LineWidth',1);
set(plot1(7),'DisplayName','N(0,0.0.01^{2})','LineWidth',1);
set(plot1(8),'DisplayName','N(0,0.0001^{2})','LineWidth',1);
set(plot1(9),'DisplayName','N(0,0.00001^{2})','LineWidth',1);

% Uncomment the following line to preserve the Y-limits of the axes
% ylim(axes1,[0 3]);
box(axes1,'on');
% Create legend
legend(axes1,'show');


xlabel('Epoch');
title('Test Error under Different Initializations on the MNIST Dataset');
ylabel('Error Rate');






