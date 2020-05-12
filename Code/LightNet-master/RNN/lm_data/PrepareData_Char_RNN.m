function [ opts ] = PrepareData_Char_RNN( opts )

max_char=67;

x = textread('train_x.txt');
x(:,end)=[];
opts.train = zeros(max_char, size(x,1),size(x,2));
Index=x(:)'+1+max_char*[(0:numel(x)-1)];
opts.train(Index)=1;

x = textread('train_y.txt');
opts.train_labels=x+1;

opts.n_train=size(opts.train_labels,1);

x = textread('test_x.txt');
x(:,end)=[];
opts.test = zeros(max_char, size(x ,1),size(x ,2));
Index=x (:)'+1+max_char*[(0:numel(x )-1)];
opts.test(Index)=1;

x = textread('test_y.txt');
opts.test_labels=x+1;


opts.n_test=size(opts.test_labels,1);
