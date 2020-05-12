function [net,opts]=train_rnn(net,opts)

    opts.training=1;
    
    if ~isfield(opts.parameters,'learning_method')
        opts.parameters.learning_method='sgd';
    end
    
    if ~isfield(opts,'display_msg')
        opts.display_msg=1; 
    end
    opts.MiniBatchError=[];
    opts.MiniBatchLoss=[];

    
    tic
    
    opts.order=randperm(opts.n_train);
    for mini_b=1:opts.n_batch
        
        idx=opts.order(1+(mini_b-1)*opts.parameters.batch_size:mini_b*opts.parameters.batch_size);
        
        %%get your input here
        opts.input_data=opts.train(:,idx,:);
        opts.input_labels=opts.train_labels(idx,:);

        %forward
        if strcmp(opts.network_name,'lstm')
            [ net,res,opts ] = lstm_ff( net,opts );
        end
        if strcmp(opts.network_name,'gru')
            [ net,res,opts ] = gru_ff( net,opts );
        end
        
        if strcmp(opts.network_name,'rnn')
            [ net,res,opts ] = rnn_ff( net,opts );
        end
        if strcmp(opts.network_name,'qrnn')
            [ net,res,opts ] = qrnn_ff( net,opts );
        end
        
        %%The following lines are to facilitate using customized loss functions
        if ~strcmp(opts.network_name,'qrnn')
            for t=1:opts.parameters.n_frames   
                res.Fit{t}(numel(net{end}.layers)+1).dzdx=1.0;
            end
        else
            res.Fit(numel(net{end}.layers)+1).dzdx=1.0;
        end
        %%%%%%%%%%%%%%%%%%%%%%%%
        
        
        %%backward
        if strcmp(opts.network_name,'lstm')
            [ net,res,opts ] = lstm_bp( net,res,opts );
        end
        if strcmp(opts.network_name,'gru')
            [ net,res,opts ] = gru_bp( net,res,opts );
        end
        
        if strcmp(opts.network_name,'rnn')
            [ net,res,opts ] = rnn_bp( net,res,opts );
        end
        
        if strcmp(opts.network_name,'qrnn')
            [ net,res,opts ] = qrnn_bp( net,res,opts );
        end
        %%summarize
        if opts.display_msg==1 && isfield(opts,'input_labels')
            disp([' Minibatch error: ', num2str(opts.err(1)), ' Minibatch loss: ', num2str(opts.loss(1))])
        end
        if opts.display_msg==1 && ~isfield(opts,'input_labels')
            disp([' Minibatch loss: ', num2str(opts.loss(1))])
        end
        
        if isfield(opts,'err')
            opts.MiniBatchError=[opts.MiniBatchError;gather( opts.err(1))];
        end
        opts.MiniBatchLoss=[opts.MiniBatchLoss;gather( opts.loss)];
        
       
         %%%%%%%%%%%%%%%%%%%% here comes to the updating part;
         if (~isfield(opts.parameters,'iterations'))
            opts.parameters.iterations=0; 
        end
        opts.parameters.iterations=opts.parameters.iterations+1;
        
        
        %apply gradients
        
        for i=1:length(net)
            if (~isfield(net{i},'iterations')||isempty(net{i}.iterations))
                net{i}.iterations=0;
            end
        end
        
        if strcmp(opts.network_name,'lstm')
            [  net{1},res.Gates,opts ] =feval( opts.parameters.learning_method, net{1},res.Gates,opts );
            [  net{2},res.Input,opts ] = feval( opts.parameters.learning_method, net{2},res.Input,opts );
            [  net{3},res.Cell,opts ] = feval( opts.parameters.learning_method, net{3},res.Cell,opts );  
            [  net{4},res.Fit,opts ] = feval( opts.parameters.learning_method, net{4},res.Fit,opts );
        end
        
        if strcmp(opts.network_name,'gru')
            [  net{1},res.Gates,opts ] = feval( opts.parameters.learning_method, net{1},res.Gates,opts );
            [  net{2},res.Input,opts ] = feval( opts.parameters.learning_method, net{2},res.Input,opts );
            [  net{3},res.Fit,opts ] = feval( opts.parameters.learning_method, net{3},res.Fit,opts );
        end
        
        if strcmp(opts.network_name,'rnn')
            [  net{1},res.Input,opts ] = feval( opts.parameters.learning_method, net{1},res.Input,opts );
            [  net{2},res.Fit,opts ] = feval( opts.parameters.learning_method, net{2},res.Fit,opts );
        end
        if strcmp(opts.network_name,'qrnn')
            [  net{1},res.Gates,opts ] = feval( opts.parameters.learning_method, net{1},res.Gates,opts );
            [  net{2},res.Input,opts ] = feval( opts.parameters.learning_method, net{2},res.Input,opts );
            [  net{3},res.Fit,opts ] = feval( opts.parameters.learning_method, net{3},res.Fit,opts );
        end
    end
    
    opts.results.TrainEpochError=[opts.results.TrainEpochError;mean(opts.MiniBatchError(:))];
    opts.results.TrainEpochLoss=[opts.results.TrainEpochLoss;mean(opts.MiniBatchLoss(:))];
    
    if opts.RecordStats==1
        opts.results.TrainLoss=[opts.results.TrainLoss;opts.MiniBatchLoss];
        opts.results.TrainError=[opts.results.TrainError;opts.MiniBatchError]; 
    end
    
    toc;

end




