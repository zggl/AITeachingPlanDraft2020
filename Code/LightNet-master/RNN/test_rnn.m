function [opts]=test_rnn(net,opts)

    opts.training=0;


    opts.MiniBatchError=[];
    opts.MiniBatchLoss=[];
    
 
    
    for mini_b=1:opts.n_test_batch
        idx=1+(mini_b-1)*opts.parameters.batch_size:mini_b*opts.parameters.batch_size;
        opts.input_data=opts.test(:,idx,:);
        opts.input_labels=opts.test_labels(idx,:);

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
       
        if isfield(opts,'err')
            opts.MiniBatchError=[opts.MiniBatchError;gather( opts.err(1))];
        end
        opts.MiniBatchLoss=[opts.MiniBatchLoss;gather( opts.loss)];
        
        
    end
    
    opts.results.TestEpochError=[opts.results.TestEpochError;mean(opts.MiniBatchError(:))];
    opts.results.TestEpochLoss=[opts.results.TestEpochLoss;mean(opts.MiniBatchLoss(:))];
      
end


