function [ net,res,opts ] = gru_ff( net,opts )
%NET_FF Summary of this function goes here
%   Detailed explanation goes here
    

    n_frames=opts.parameters.n_frames;
    n_hidden_nodes=opts.parameters.n_hidden_nodes;
    batch_size=opts.parameters.batch_size;
    
    
    if opts.use_gpu
        opts.input_data=gpuArray(single(opts.input_data));
        if isfield(opts,'input_labels')
            opts.input_labels=gpuArray(single(opts.input_labels));            
            opts.err=zeros(2,n_frames,'like',opts.input_data);
        end
        if isfield(opts,'input_predicts')
            opts.input_predicts=gpuArray(single(opts.input_predicts));
        end
    end
    
    opts.loss=zeros(1,n_frames,'like',opts.input_data);
    
    
    for f=1:n_frames
        if isfield(opts,'input_predicts')
            res.Fit{f}(1).predicts=opts.input_predicts(:,:,f);
        elseif isfield(opts,'input_labels')
            res.Fit{f}(1).class=opts.input_labels(:,f);
        end
    end
    
    res.Hidden{1}(1).x=zeros(n_hidden_nodes,batch_size,'like',opts.input_data);
 
    for f=1:n_frames
        
        %Process inputs
        res.Gates{f}(1).x=[res.Hidden{f}(1).x;opts.input_data(:,:,f)];%inputs
        
        %Gates
        [ net{1},res.Gates{f},opts ] = net_ff( net{1},res.Gates{f},opts );
        
        %Input transform
        ResetGate=res.Gates{f}(end).x(1:n_hidden_nodes,:);
        res.Input{f}(1).x=[ResetGate.*res.Hidden{f}(1).x;opts.input_data(:,:,f)];       
        [ net{2},res.Input{f},opts ] = net_ff( net{2},res.Input{f},opts ); 
        
        %Update hidden nodes;
        UpdateGate=res.Gates{f}(end).x(n_hidden_nodes+1:end,:);
        res.Hidden{f+1}(1).x=res.Hidden{f}(1).x  +  UpdateGate.*(res.Input{f}(end).x-res.Hidden{f}(1).x);
        
        %Data fitting transform
        res.Fit{f}(1).x=res.Hidden{f+1}(1).x;
        
        [ net{3},res.Fit{f},opts ] = net_ff( net{3},res.Fit{f},opts ); 
        

    end
    
    %%%summarize
    for f=1:n_frames
        if isfield(opts,'input_labels')
            opts.err(:,f)=error_multiclass(res.Fit{f}(1).class,res.Fit{f});
        end
        opts.loss(:,f)=mean(res.Fit{f}(end).x(:));
    end
    
    if isfield(opts,'input_labels')
        opts.err=mean(opts.err,2)./opts.parameters.batch_size;
    end
    opts.loss=mean(opts.loss(:));
end

