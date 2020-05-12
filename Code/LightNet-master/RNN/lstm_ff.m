function [ net,res,opts ] = lstm_ff( net,opts )
%NET_FF Summary of this function goes here
%   Detailed explanation goes here

    n_frames=opts.parameters.n_frames;
    n_cell_nodes=opts.parameters.n_hidden_nodes;
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
        end
        if isfield(opts,'input_labels')
            res.Fit{f}(1).class=opts.input_labels(:,f);
        end        
    end
    
    %%%%%%%%%%%%%%%%%%%
    
    res.Hidden{1}=zeros(n_hidden_nodes,batch_size,'like',opts.input_data);
    res.Cell{1}(1).x=zeros(n_cell_nodes,batch_size,'like',opts.input_data);
    
    
    for f=1:n_frames
        
        %Process inputs
        res.Gates{f}(1).x=[res.Hidden{f};opts.input_data(:,:,f)];%inputs
        res.Input{f}(1).x=res.Gates{f}(1).x;
        
        %Gates
        [ net{1},res.Gates{f},opts ] = net_ff( net{1},res.Gates{f},opts );
        
        %Input transform
        [ net{2},res.Input{f},opts ] = net_ff( net{2},res.Input{f},opts ); 
        
        %Update cells
        res.Cell{f+1}(1).x=res.Gates{f}(end).x(1:n_cell_nodes,:).*res.Input{f}(end).x+res.Gates{f}(end).x(n_cell_nodes+1:2*n_cell_nodes,:).*res.Cell{f}(1).x;

        %Output transform
        [ net{3},res.Cell{f+1},opts ] = net_ff( net{3},res.Cell{f+1},opts ); 
        res.Hidden{f+1}=res.Gates{f}(end).x(2*n_cell_nodes+1:3*n_cell_nodes,:).*res.Cell{f+1}(end).x;
        
        %Data fitting transform
        res.Fit{f}(1).x=res.Hidden{f+1};        
        [ net{4},res.Fit{f},opts ] = net_ff( net{4},res.Fit{f},opts ); 
        
    end
    
    %%%stats
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

