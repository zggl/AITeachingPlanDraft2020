function [ net,res,opts ] = qrnn_ff( net,opts )
%NET_FF Summary of this function goes here
%   Detailed explanation goes here
    
    n_frames=opts.parameters.n_frames;
    n_hidden_nodes=opts.parameters.n_hidden_nodes;
    n_input_nodes=size(opts.input_data,1);
    batch_size=opts.parameters.batch_size;
    
    %classification
    if isfield(opts,'input_labels')
        res.Fit(1).class=opts.input_labels(:);%vectorize all outputs
    end
    
    %Process inputs, clarity is more important here
    res.Gates(1).x=reshape(opts.input_data,n_input_nodes,[]);%inputs
    res.Input(1).x=res.Gates(1).x;%inputs
    
    [ net{1},res.Gates,opts ] = net_ff( net{1},res.Gates,opts );
    [ net{2},res.Input,opts ] = net_ff( net{2},res.Input,opts ); 

    res.Gates(end).x=reshape(res.Gates(end).x,n_hidden_nodes,batch_size,n_frames);
    res.Input(end).x=reshape(res.Input(end).x,n_hidden_nodes,batch_size,n_frames);
    res.Hidden=zeros(n_hidden_nodes,batch_size,n_frames,'like',res.Input(end).x);
    %Hidden_diff is used in bp.
    res.Hidden_diff=zeros(n_hidden_nodes,batch_size,n_frames,'like',res.Input(end).x);
   
    res.Hidden_diff(:,:,1)=res.Input(end).x(:,:,1);
    res.Hidden(:,:,1)=res.Gates(end).x(:,:,1).*res.Hidden_diff(:,:,1);
    for f=2:n_frames
        %Update hidden nodes;        
        res.Hidden_diff(:,:,f)=res.Input(end).x(:,:,f)-res.Hidden(:,:,f-1);
        res.Hidden(:,:,f)=res.Hidden(:,:,f-1) + res.Gates(end).x(:,:,f).*res.Hidden_diff(:,:,f);        
    end
    
    res.Fit(1).x=res.Hidden;
    
    %Data fitting transform
    res.Fit(1).x=reshape(res.Fit(1).x,n_hidden_nodes,[]);
    [ net{3},res.Fit,opts ] = net_ff( net{3},res.Fit,opts ); 
        
    %%%summarize    
    if isfield(opts,'input_labels')
        opts.err=error_multiclass(res.Fit(1).class,res.Fit)./numel(res.Fit(1).class);
    end
    opts.loss=mean(res.Fit(end).x(:));
end

