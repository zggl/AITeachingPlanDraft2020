function [net] = net_init_char_qrnn(opts)

rng('default');
rng(0) ;

f=1/100 ;

n_hidden_nodes=opts.parameters.n_hidden_nodes;
n_input_nodes=opts.parameters.n_input_nodes;
n_output_nodes=opts.parameters.n_output_nodes;
n_gates=opts.parameters.n_gates;

net{1}.type='Gates';% update gates
net{1}.layers = {} ;
net{1}.layers{end+1} = struct('type', 'mlp', ...
                           'weights', {{f*randn(n_gates*n_hidden_nodes,n_input_nodes, 'single'), zeros(n_gates*n_hidden_nodes,1,'single')}}) ;
net{1}.layers{end+1} = struct('type', 'sigmoid') ;

%generate the adjustments of the hidden nodes for the current time frame
net{2}.type='InputTransform';
net{2}.layers = {} ;
net{2}.layers{end+1} = struct('type', 'mlp', ...
                           'weights', {{f*randn(n_hidden_nodes,n_input_nodes, 'single'), zeros(n_hidden_nodes,1,'single')}}) ;
net{2}.layers{end+1} = struct('type', 'relu') ;


net{3}.type='Fit';
net{3}.layers = {};
net{3}.layers{end+1} = struct('type', 'mlp', ...
                           'weights', {{f*randn(n_output_nodes,n_hidden_nodes, 'single'), zeros(n_output_nodes,1,'single')}}) ;
net{3}.layers{end+1} = struct('type', 'softmaxloss');                       

