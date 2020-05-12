function net = net_init_cifar_cnn(opts)
% CNN_MNIST_LENET Initialize a CNN similar for MNIST


rng('default');
rng(0) ;

f=1/100 ;
net.layers = {} ;
% Block 1    
net.layers{end+1} = struct('type', 'conv', ...
                           'weights', {{f*randn(5,5,3,32, 'single'), zeros(1, 32, 'single') }}, ...
                           'stride', 1, ...
                           'pad', 2) ;
net.layers{end+1} = struct('type', 'relu') ;

net.layers{end+1} = struct('type', 'pool','pool', 3, 'stride', 2,'pad', [1,1,1,1]) ;
% Block 2

net.layers{end+1} = struct('type', 'conv', ...
                           'weights', {{f*randn(5,5,32,32, 'single'), zeros(1,32, 'single')}}, ...
                           'stride', 1, ...
                           'pad', 2) ;
net.layers{end+1} = struct('type', 'relu') ;

net.layers{end+1} = struct('type', 'pool','pool', 3, 'stride', 2,'pad', [1,1,1,1]) ;

% Block 3

net.layers{end+1} = struct('type', 'conv', ...
                           'weights', {{f*randn(5,5,32,64, 'single'), zeros(1,64, 'single')}}, ...
                           'stride', 1, ...
                           'pad', 2) ;
net.layers{end+1} = struct('type', 'relu') ;

net.layers{end+1} = struct('type', 'pool','pool', 3, 'stride', 2,'pad', [1,1,1,1]) ;

% Block 4
net.layers{end+1} = struct('type', 'conv', ...
                           'weights', {{f*randn(4,4,64,64, 'single'), zeros(1,64, 'single')}}, ...
                           'stride', 1, ...
                           'pad', 0) ;
net.layers{end+1} = struct('type', 'relu') ;

% Block 5

net.layers{end+1} = struct('type', 'conv', ...
                           'weights', {{f*randn(1,1,64,10, 'single'), zeros(1, 10, 'single')}}, ...
                           'stride', 1, ...
                           'pad', 0) ;

net.layers{end+1} = struct('type', 'softmaxloss') ;


