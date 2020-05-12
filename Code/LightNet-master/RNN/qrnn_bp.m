function [ net,res,opts ] = qrnn_bp( net,res,opts )
%QRNN_BP Summary of this function goes here
%   Detailed explanation goes here

    n_frames=opts.parameters.n_frames;    
    n_hidden_nodes=opts.parameters.n_hidden_nodes;
    batch_size=opts.parameters.batch_size;
     
    %1: calculate the gradients of the data fitting transform
    opts.dzdy=res.Fit(numel(net{end}.layers)+1).dzdx; 
    [net{3},res.Fit,opts] = net_bp(net{3},res.Fit,opts);    

    %2: BPTT: calculate the gradient wrt the hidden nodes 
    res.Fit(1).dzdx=reshape(res.Fit(1).dzdx,n_hidden_nodes,batch_size,n_frames);
    for f=n_frames-1:-1:1
        res.Fit(1).dzdx(:,:,f)=res.Fit(1).dzdx(:,:,f)+(1-res.Gates(end).x(:,:,f+1)).*res.Fit(1).dzdx(:,:,f+1);
    end

    res.Gates(end).x=reshape(res.Gates(end).x,n_hidden_nodes,[]);
    res.Input(end).x=reshape(res.Input(end).x,n_hidden_nodes,[]);
    res.Fit(1).dzdx=reshape(res.Fit(1).dzdx,n_hidden_nodes,[]);    
    res.Hidden_diff=reshape(res.Hidden_diff,n_hidden_nodes,[]);        
    %3: calculate the gradients of the input transform
    opts.dzdy=res.Fit(1).dzdx.*res.Gates(end).x;
    [ net{1},res.Input,opts ] = net_bp( net{1},res.Input,opts );

    %4: calculate the gradients of the gates
    opts.dzdy=res.Fit(1).dzdx.*res.Hidden_diff;
    [ net{1},res.Gates,opts ] = net_bp( net{1},res.Gates,opts );
    
end

