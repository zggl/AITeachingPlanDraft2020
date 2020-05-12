function net = net_init(opts)
% CNN_MNIST_LENET Initialize a CNN similar for MNIST


rng('default');
rng(0) ;

f=1/100 ;
net.layers = {} ;
net.layers{end+1} = struct('type', 'dropout','rate',0.2) ;
net.layers{end+1} = struct('type', 'mlp', ...
                           'weights', {{f*randn(512,28*28*1, 'single'), zeros(512,1,'single')}}) ;
net.layers{end+1} = struct('type', 'relu') ;
net.layers{end+1} = struct('type', 'dropout','rate',0.2) ;
net.layers{end+1} = struct('type', 'mlp', ...
                           'weights', {{f*randn(1024,512, 'single'),  zeros(1024,1,'single')}}) ;
net.layers{end+1} = struct('type', 'relu') ;
net.layers{end+1} = struct('type', 'dropout','rate',0.2) ;
net.layers{end+1} = struct('type', 'mlp', ...
                           'weights', {{f*randn(512,1024, 'single'),  zeros(512,1,'single')}}) ;
net.layers{end+1} = struct('type', 'relu') ;
net.layers{end+1} = struct('type', 'dropout','rate',0.2) ;
net.layers{end+1} = struct('type', 'mlp', ...
                           'weights', {{f*randn(512,512, 'single'),  zeros(512,1,'single')}}) ;
net.layers{end+1} = struct('type', 'relu') ;

net.layers{end+1} = struct('type', 'dropout','rate',0.2) ;

net.layers{end+1} = struct('type', 'mlp', ...
                           'weights', {{f*randn(10,512, 'single'), zeros(10,1,'single')}}) ;

%net.layers{end+1} = struct('type', 'relu') ;

net.layers{end+1} = struct('type', 'softmaxloss') ;

for i=1:numel(net.layers)
    if strcmp(net.layers{i}.type,'mlp')
        net.layers{1,i}.momentum{1}=zeros(size(net.layers{1,i}.weights{1}));
        net.layers{1,i}.momentum{2}=zeros(size(net.layers{1,i}.weights{2}));
    end
end



%}
