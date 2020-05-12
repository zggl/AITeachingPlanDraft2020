function [ net,res,opts ] = gru_bp( net,res,opts )
%GRU_BP Summary of this function goes here
%   Detailed explanation goes here

    n_frames=opts.parameters.n_frames;    
    n_hidden_nodes=opts.parameters.n_hidden_nodes;
    
    %1: calculate the gradients of the data fitting transform
    for f=1:n_frames
        opts.dzdy=res.Fit{f}(numel(net{end}.layers)+1).dzdx; 
        [net{3},res.Fit{f},opts] = net_bp(net{3},res.Fit{f},opts);    
    end 
        
    %2: BPTT: calculate the gradient wrt the hidden nodes 
    %good luck in reading the following code
    dzdh=0;%accumulated gradient in later time frames
    for f=n_frames:-1:1
        
        dzdh=dzdh+res.Fit{f}(1).dzdx;
        ResetGate=res.Gates{f}(end).x(1:n_hidden_nodes,:);
        UpdateGate=res.Gates{f}(end).x(n_hidden_nodes+1:end,:);
        
        %3: calculate the gradients of the input transform
        opts.dzdy=dzdh.*UpdateGate;
        [net{2},res.Input{f},opts] = net_bp(net{2},res.Input{f},opts);
        
        dzdy_UpdateGate=dzdh.*(res.Input{f}(end).x-res.Hidden{f}(1).x);        
        %%%a bit tricky to read
        dzdx_hidden_input=res.Input{f}(1).dzdx(1:n_hidden_nodes,:);
        dzdy_ResetGate=dzdx_hidden_input.*res.Hidden{f}(1).x;
        opts.dzdy=[dzdy_ResetGate;dzdy_UpdateGate];        
        %3: calculate the gradients of the gates
        [ net{1},res.Gates{f},opts ] = net_bp( net{1},res.Gates{f},opts );
        dzdh=dzdh.*(1-UpdateGate)+res.Gates{f}(1).dzdx(1:n_hidden_nodes,:) + dzdx_hidden_input.*ResetGate;
    end
    
    
    
    %%%accumulate gradients in all time frames
    
    res.Fit=average_gradients_in_frames(res.Fit);
    res.Input=average_gradients_in_frames(res.Input);
    res.Gates=average_gradients_in_frames(res.Gates);
    
    
end

