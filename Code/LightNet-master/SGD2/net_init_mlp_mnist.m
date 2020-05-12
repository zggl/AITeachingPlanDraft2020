function net = net_init(opts)


%rng('default');
%rng(0) ;

hidden_nodes=opts.hidden_nodes;
layers=opts.layers;

if ~isfield(opts,'f')
    opts.f=1/100;
end 

f=opts.f;

net.layers = {} ;

if ~isfield(opts,'use_rmsnorm')
    opts.use_rmsnorm=0;
end 

if ~isfield(opts,'act')
    opts.act='relu';
end 

if ~isfield(opts,'use_dropout')
    opts.use_dropout=0;
end 

net.layers{end+1} = struct('type', 'linear', ...
                           'weights', {{f*randn(hidden_nodes,28*28*1, 'single'), zeros(hidden_nodes,1,'single')}}) ;
if opts.use_bnorm
    net.layers{end+1} = struct('type', 'bnorm') ;
end
net.layers{end+1} = struct('type', opts.act) ;



for i=1:layers

    if opts.use_rmsnorm
        net.layers{end+1} = struct('type', 'rmsnorm' ) ;
    end
    net.layers{end+1} = struct('type', 'linear', ...
                               'weights', {{f*randn(hidden_nodes,hidden_nodes, 'single'),  zeros(hidden_nodes,1,'single')}}) ;
    if opts.use_bnorm
        net.layers{end+1} = struct('type', 'bnorm') ;
    end
    net.layers{end+1} = struct('type', opts.act) ;
    if opts.use_dropout
        net.layers{end+1} = struct('type', 'dropout','rate',opts.dropout_rate) ;
    end
end

if opts.use_rmsnorm 
    net.layers{end+1} = struct('type', 'rmsnorm' ) ;
end
net.layers{end+1} = struct('type', 'linear', ...
                           'weights', {{f*randn(10,hidden_nodes, 'single'), zeros(10,1,'single')}}) ;

net.layers{end+1} = struct('type', 'softmaxloss') ;

end
