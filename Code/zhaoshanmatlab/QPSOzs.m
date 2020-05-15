clc
clear
mu=30;         %�ͷ�����
popsize=50;     %Ⱥ���ģ
MAXITER=5000;   %����������
dimension=10;   %����ά��
irange_l=0;  %λ�ó�ʼ���½�
irange_r=1;   %λ�ó�ʼ���Ͻ�
xmax=1;       %������Χ�Ͻ�
xmin=0;         %������Χ�½�
M=(xmax-xmin)/2;   %������Χ����ֵ
sum1=0;
st=0;
runno=50;        %�㷨����50��
data1=zeros(runno,MAXITER);    %��¼ÿһ����ÿһ�����������Ӧֵ
for run=1:runno       %���� runno=50 �ֿ�ʼ
    T=cputime;        %��¼CPUʱ��
    x=(irange_r-irange_l)*rand(popsize,dimension,1)+irange_l; %��ʼ�����ӵ�ǰλ��
    pbest=x;          %�����Ӹ������λ�ó�ʼ��Ϊ��ǰ���λ��
    gbest=zeros(1,dimension);   %��ʼ��ȫ�����λ�ñ���
    for i=1:popsize   %���㵱ǰλ�ú͸������λ�õ���Ӧֵ
        f_x(i)=F4(x(i,:),mu);
        f_pbest(i)=f_x(i);
    end
    g=min(find(f_pbest==min(f_pbest(1:popsize))));    %�ҵ�ȫ�����λ�õ����ӵ��±�
    gbest=pbest(g,:);      %�ҵ�ȫ�����λ��
    f_gbest=f_pbest(g);    %��¼ȫ�����λ�õ���Ӧֵ
    
    MINIMUM=f_pbest(g);    %��¼�㷨ÿ�ε����ҵ��������Ӧֵ
    
    for t=1:MAXITER
        alpha=(1.2-0.4)*(MAXITER-t)/MAXITER+0.4;   %����-����ϵ������
        mbest=sum(pbest)/popsize;    %����mbest
        
        for i=1:popsize
            for d=1:dimension
                fi=rand;
                p=fi*pbest(i,d)+(1-fi)*gbest(d);     %�ɼ��������p
                u=rand;
                b=alpha*abs(mbest(d)-x(i,d));
                v=-log(u);
                if rand>0.5
                   x(i,d)=p+b*v;       %����λ�õĸ���
                else 
                    x(i,d)=p-b*v;
                end
                %%%%%%����������λ��������������Χ��%%%%%%%%%%%
                if  x(i,d)>xmax
                    x(i,d)=xmax;
                end
                if  x(i,d)<xmin
                    x(i,d)=xmin;
                end
            end
            f_x(i)=F4(x(i,:),mu);   %�������ӵ�ǰλ�õ���Ӧֵ
            if f_x(i)<f_pbest(i)   %�������Ӹ������λ��
                pbest(i,:)=x(i,:);
                f_pbest(i)=f_x(i);
            end
            if f_pbest(i)<f_gbest %��������ȫ�����λ�� 
                gbest=pbest(i,:);
                f_gbest=f_pbest(i);
            end
            MINIMUM=f_gbest;   %��¼ȫ�����λ����Ӧֵ
        end      
        data1(run,t)=MINIMUM;   %��¼���ε����ҵ��������Ӧֵ
    end
    sum1=sum1+MINIMUM;
    time=cputime-T;      %�õ�һ�ּ����cpuʱ��
    st=st+time;
end
av=sum1/runno;        %����runno�ֵõ������Ӧֵ��ƽ��ֵ
st/runno;     %ÿ��ʹ�õ�ƽ��cpuʱ��

%%%%%%%%%%%%%%%%%���Ժ���F���б�д%%%%%%
% ���
gbest
F4(gbest,10)

x=gbest;
y1=0;y2=y1;y4=1;w=0.9;
YY=linspace(0,10,length(x));
ff=B2(x);
for i=1:length(x)
     y4=y4*ff(i);
end
for i=1:length(x)
    y1=y1+YY(i)*x(i);
    y2=y2+x(i);
end
y2
y3=y1/y2-w   
y=-y4+mu*(y3)
        
        
           
            
            
    