function [ net,res,opts ] = lstm_bp( net,res,opts )
%LSTM_BP Summary of this function goes here
%   Detailed explanation goes here

    n_frames=opts.parameters.n_frames;    
    n_cell_nodes=opts.parameters.n_hidden_nodes;
    
    %1: calculate the gradients of the data fitting transform
    
    for f=1:n_frames
        opts.dzdy=res.Fit{f}(numel(net{end}.layers)+1).dzdx; 
        [net{4},res.Fit{f},opts] = net_bp(net{4},res.Fit{f},opts);    
    end 
    
    
    %2: BPTT: calculate the gradient wrt memory cell 

    dzdc=0;
    for f=n_frames:-1:1
        %gradient from the output gate
        opts.dzdy=res.Gates{f}(end).x(2*n_cell_nodes+1:3*n_cell_nodes,:).*res.Fit{f}(1).dzdx;
        [net{3},res.Cell{f+1},opts] = net_bp(net{3},res.Cell{f+1},opts);
        %
        res.Cell{f+1}(1).dzdx=dzdc+res.Cell{f+1}(1).dzdx;
        dzdc=res.Cell{f+1}(1).dzdx.*res.Gates{f}(end).x(n_cell_nodes+1:2*n_cell_nodes,:);
    end
       
    res.Cell{1}(end+1).x=0;%just some padding
        
    %3: calculate the gradients of the input transform
    for f=1:n_frames
        opts.dzdy= res.Gates{f}(end).x(1:n_cell_nodes,:).*res.Cell{f+1}(1).dzdx;
        [net{2},res.Input{f},opts] = net_bp(net{2},res.Input{f},opts);
    end
    
    %4: calculate the gradients of the input,forget,output gates:
    for f=1:n_frames
        %input gate gradient;forget gate gradient; output gate gradient;
        opts.dzdy=[ res.Input{f}(end).x .*res.Cell{f+1}(1).dzdx;...
            res.Cell{f}(1).x .*res.Cell{f+1}(1).dzdx;...
            res.Fit{f}(1).dzdx.*res.Cell{f+1}(end).x];
        [net{1},res.Gates{f},opts] = net_bp(net{1},res.Gates{f},opts);
    end
    
    
    
    %%%accumulate gradients in all time frames
    
    res.Fit=average_gradients_in_frames(res.Fit);
    res.Input=average_gradients_in_frames(res.Input);
    res.Gates=average_gradients_in_frames(res.Gates);
    res.Cell=average_gradients_in_frames(res.Cell);
    
    
end

