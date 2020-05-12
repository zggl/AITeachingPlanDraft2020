clear all;

%%%%%%%%%%%%%This example will need to be reorganized


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%provide parameters and inputs below
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

addpath('../')

addpath(genpath('../CoreModules'));

addpath('./lm_data');

n_epoch=20;%20 %%training epochs
dataset_name='char'; % dataset name
network_name='qrnn';%'gru';'rnn','lstm'
use_gpu=0; %%use gpu or not 
opts.use_nntoolbox=0;

PrepareDataFunc=@PrepareData_Char_RNN; %%function handler to prepare your data

if strcmp(network_name,'lstm')
    NetInit=@net_init_char_lstm;%_bn  %% function to initialize the network
end
   
if strcmp(network_name,'gru')
    NetInit=@net_init_char_gru;  %% function to initialize the network
end

if strcmp(network_name,'rnn')
    NetInit=@net_init_char_rnn;  %% function to initialize the network
    opts.parameters.Id_w=1;%vanilla rnn:0, rnn with skip links: 1
end

if strcmp(network_name,'qrnn')
    NetInit=@net_init_char_qrnn;  %% function to initialize the network
end

use_selective_sgd=0; %automatically select learning rates
%%selective-sgd parameters
%ssgd_search_freq=10; %select new coarse-scale learning rates every n epochs


learning_method=@adam; %training method: @rmsprop;

%sgd parameter (unnecessary if selective-sgd is used)
sgd_lr=1e-2;




opts.parameters.batch_size=100;
opts.parameters.n_hidden_nodes=30;
opts.parameters.n_cell_nodes=30;
opts.parameters.n_input_nodes=67;
opts.parameters.n_output_nodes=67;
if strcmp(network_name,'lstm')
    opts.parameters.n_gates=3;
end
if strcmp(network_name,'gru')
    opts.parameters.n_gates=2;
end

if strcmp(network_name,'qrnn')
    opts.parameters.n_gates=1;
    use_gpu=(gpuDeviceCount>0);  
    opts.use_nntoolbox=license('test','neural_network_toolbox');
end

opts.parameters.n_frames=64;%%%%max sentence length

opts.parameters.lr =sgd_lr;
opts.parameters.mom =0.9;
opts.parameters.learning_method=learning_method;
opts.parameters.selective_sgd=use_selective_sgd;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%provide parameters and inputs above
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%








%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%stupid settings below (so please ignore)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

opts.n_epoch=n_epoch; %training epochs
opts.dataset_name=dataset_name; %dataset name
opts.network_name=network_name; %network name
opts.use_gpu=use_gpu; %use gpu or not 

opts.results=[];
opts.results.TrainEpochError=[];
opts.results.TestEpochError=[];
opts.results.TrainEpochLoss=[];
opts.results.TestEpochLoss=[];
opts.RecordStats=1;
opts.results.TrainLoss=[];
opts.results.TrainError=[];

opts.plot=1;

opts.dataDir=['./',opts.dataset_name,'/'];
opts=PrepareDataFunc(opts);

net=NetInit(opts);


opts=generate_output_filename(opts);

if(opts.use_gpu)       
    for i=1:length(net)
        net{i}=SwitchProcessor(net{i},'gpu');
    end
else
    for i=1:length(net)
        net{i}=SwitchProcessor(net{i},'cpu');
    end
end


opts.n_batch=floor(opts.n_train/opts.parameters.batch_size);
opts.n_test_batch=floor(opts.n_test/opts.parameters.batch_size);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%stupid settings above
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%training goes below
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


opts.parameters.current_ep=1;

start_ep=opts.parameters.current_ep;
if opts.plot
    figure1=figure;
end
for ep=start_ep:opts.n_epoch
    
    
    [net,opts]=train_rnn(net,opts);  
    [opts]=test_rnn(net,opts);
    opts.parameters.current_ep=opts.parameters.current_ep+1;
    disp(['Epoch ',num2str(ep),' testing error: ',num2str(opts.results.TestEpochError(end)), ' testing loss: ',num2str(opts.results.TestEpochLoss(end))])
    
    %
    if opts.plot
        subplot(1,2,1); plot(opts.results.TrainEpochError);hold on;plot(opts.results.TestEpochError);hold off;title('Error Rate per Epoch')
        subplot(1,2,2);plot(opts.results.TrainEpochLoss);hold on;plot(opts.results.TestEpochLoss);hold off;title('Loss per Epoch')
        drawnow;
    end
    %}
    parameters=opts.parameters;    
    results=opts.results;
    save([fullfile(opts.output_dir,[opts.output_name,num2str(ep),'.mat'])],'net','parameters','results');     
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%training goes above
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


