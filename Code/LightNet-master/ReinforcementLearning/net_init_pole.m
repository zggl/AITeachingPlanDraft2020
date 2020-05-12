function net = net_init()

rng('default');
rng(0) ;

f=1/100 ;
net.layers = {} ;

% 2-layer net
net.layers{end+1} = struct('type', 'mlp', ...
                           'weights', {{f*randn(16,4, 'single'), zeros(16,1,'single')}}) ;
net.layers{end+1} = struct('type', 'relu') ;

net.layers{end+1} = struct('type', 'mlp', ...
                           'weights', {{f*randn(2,16, 'single'), zeros(2,1,'single')}}) ;
%}


%%leave it like this, we will evaluate the cost and derivative in another function  :p


