%% *遗传算法主程序*
function  GAMain()
    clc,clear,tic
    % 参数初始化
    maxgen=100; %进化代数，即迭代次数，初始预定值选为100
    popsize=200; %种群规模，初始预定值选为100
    pcross=0.9; %交叉概率选择，0和1之间，一般取0.9
    pmutation=0.01; %变异概率选择，0和1之间，一般取0.01
    individuals=struct('fitness',zeros(1,popsize),'chrom',[]);
    %种群，种群由popsize条染色体(chrom)及每条染色体的适应度(fitness)组成
    avgfitness=[];
    %记录每一代种群的平均适应度，首先赋给一个空数组
    bestfitness=[];
    %记录每一代种群的最佳适应度，首先赋给一个空数组
    bestchrom=[];
    %记录适应度最好的染色体，首先赋给一个空数组
    %初始化种群
    %%聚类点数据
    dataa
    for i=1:popsize
        %随机产生一个种群
        individuals.chrom(i,:)=4000*rand(1,12);
        %把12个0~4000的随机数赋给种群中的一条染色体，代表K=4个聚类中心
        x=individuals.chrom(i,:);
        %计算每条染色体的适应度
        individuals.fitness(i)=fitness(x,dataf);
    end
    %%找最好的染色体
    [bestfitness bestindex]=max(individuals.fitness);
    %找出适应度最大的染色体，并记录其适应度的值(bestfitness)和染色体所在的位置(bestindex)
    bestchrom=individuals.chrom(bestindex,:);
    %把最好的染色体赋给变量bestchrom
    avgfitness=sum(individuals.fitness)/popsize;
    %计算群体中染色体的平均适应度

    trace=[avgfitness bestfitness];
    %记录每一代进化中最好的适应度和平均适应度

    for i=1:maxgen
        sprintf('%d',i)
        %输出进化代数
        individuals=Select(individuals,popsize);
        avgfitness=sum(individuals.fitness)/popsize;
        %对种群进行选择操作，并计算出种群的平均适应度
        individuals.chrom=Cross(pcross,individuals.chrom,popsize);
        %对种群中的染色体进行交叉操作
        individuals.chrom=Mutation(pmutation,individuals.chrom,popsize);
        %对种群中的染色体进行变异操作
            for j=1:popsize
                x=individuals.chrom(j,:);%解码
                [individuals.fitness(j)]=fitness(x,dataf);
            end
        %计算进化种群中每条染色体的适应度
        [newbestfitness,newbestindex]=max(individuals.fitness);
        [worestfitness,worestindex]=min(individuals.fitness);
        %找到最小和最大适应度的染色体及它们在种群中的位置
        if bestfitness<newbestfitness
            bestfitness=newbestfitness;
            bestchrom=individuals.chrom(newbestindex,:);
        end
        %代替上一次进化中最好的染色体
        individuals.chrom(worestindex,:)=bestchrom;
        individuals.fitness(worestindex)=bestfitness;
        %淘汰适应度最差的个体
        avgfitness=sum(individuals.fitness)/popsize;
        trace=[trace;avgfitness bestfitness];
        %记录每一代进化中最好的适应度和平均适应度
    end
    figure(1)
    plot(trace(:,1),'-*r');
    title('适应度函数曲线(100*100)')
    hold on
    plot(trace(:,2),'-ob');
    legend('平均适应度曲线','最佳适应度曲线','location','southeast')
    %%画出适应度变化曲线
    clc
    %待分类的数据
    kernal=[bestchrom(1:3);bestchrom(4:6);bestchrom(7:9);bestchrom(10:12)];
    %解码出最佳聚类中心
    [n,m]=size(data1);
    %求出待聚类数据的行数和列数
    index=cell(4,1);
    %用来保存聚类类别
    dist=0;
    %用来计算准则函数
    for i=1:n
        dis(1)=norm(kernal(1,:)-data1(i,:));
        dis(2)=norm(kernal(2,:)-data1(i,:));
        dis(3)=norm(kernal(3,:)-data1(i,:));
        dis(4)=norm(kernal(4,:)-data1(i,:));
        %计算出待聚类数据中的一点到各个聚类中心的距离
        [value,index1]=min(dis);
        %找出最短距离和其聚类中心的种类
        cid(i)=index1;
        %用来记录数据被划分到的类别
        index{index1,1}=[index{index1,1} i];
        dist=dist+value;
        %计算准则函数
    end
    % %作图
    hold off
    figure(2)
    plot3(bestchrom(1),bestchrom(2),bestchrom(3),'ro');
    title('result100*100') 
    hold on
    %画出聚类中心
    colstr={'bo', 'go','ko','k*'};
    for ii=2:4
        index1=index{ii,1};
        for i=1:length(index1)
            plot3(data1(index1(i),1),data1(index1(i),2),data1(index1(i),3),'ro')
            hold on
        end
        plot3(bestchrom(2*(ii-1)+1),bestchrom(2*(ii-1)+2),bestchrom(2*(ii-1)+3),colstr{ii});
        hold on
    end   
    toc
    pause(10)
    close all
 end
%%
%% *计算个体适应度值
function fit=fitness(x,dataf)
    %x    input   个体
    %fit  output  适应度值
     
    kernel=[x(1:3);x(4:6);x(7:9);x(10:12)];
    fit1=0;
    [n,m]=size(dataf);
    for i=1:n
    
        dist1=norm(dataf(i,1:3)-kernel(1,:)); 
         dist2=norm(dataf(i,1:3)-kernel(2,:));  
          dist3=norm(dataf(i,1:3)-kernel(3,:));  
           dist4=norm(dataf(i,1:3)-kernel(4,:));  
    
        a=[dist1 dist2 dist3 dist4];
        mindist=min(a);
        fit1=mindist+fit1;
    end
    fit=1/fit1;
end

%%
%% *选择操作*
function ret=Select(individuals,popsize)
% 对每一代种群中的染色体进行选择，以进行后面的交叉和变异
% individuals input  : 种群信息
% popsize     input  : 种群规模
% ret         output : 经过选择后的种群



sumfitness=sum(individuals.fitness);
sumf=(individuals.fitness)./sumfitness;
index=[];

for i=1:popsize   %转popsize次轮盘
    pick=rand;
    while pick==0    
        pick=rand;        
    end
    for i=1:popsize    
        pick=pick-sumf(i);        
        if pick<0        
            index=[index i];            
            break;  
        end
    end
end
individuals.chrom=individuals.chrom(index,:);
individuals.fitness=individuals.fitness(index);
ret=individuals;
end

%%
%% *变异操作*
function ret=Mutation(pmutation,chrom,popsize)
    % 变异操作
    % pcorss                input  : 变异概率
    % lenchrom              input  : 染色体长度
    % chrom                 input  : 染色体群
    % popsize               input  : 种群规模
    % bound                 input  : 每个个体的上届和下届
    % ret                   output : 变异后的染色体

    for i=1:popsize

        % 变异概率决定该轮循环是否进行变异
        pick=rand;
        if pick>pmutation
            continue;
        end

        pick=rand;
        while pick==0
            pick=rand;
        end
        index=ceil(pick*popsize);    

        % 变异位置
        pick=rand;
        while pick==0
            pick=rand;
        end
        pos=ceil(pick*3); 

        chrom(index,pos)=rand*4000;    
    end
    ret=chrom;
end

%%
%% *交叉操作*
function ret=Cross(pcross,chrom,popsize)
    %交叉操作
    % pcorss                input  : 交叉概率
    % lenchrom              input  : 染色体的长度
    % chrom     input  : 染色体群
    % popsize               input  : 种群规模
    % ret                   output : 交叉后的染色体
    for i=1:popsize

        % 交叉概率决定是否进行交叉
        pick=rand;
        while pick==0
            pick=rand;
        end
        if pick>pcross
            continue;
        end

        % 随机选择交叉个体
        index=ceil(rand(1,2).*popsize);
        while (index(1)==index(2)) | index(1)*index(2)==0
            index=ceil(rand(1,2).*popsize);
        end

        % 随机选择交叉位置
        pos=ceil(rand*3);
        while pos==0
            pos=ceil(rand*3);
        end

        temp=chrom(index(1),pos);
        chrom(index(1),pos)=chrom(index(2),pos);
        chrom(index(2),pos)=temp;
    end
    ret=chrom;
end
