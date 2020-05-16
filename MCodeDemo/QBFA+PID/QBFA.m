function [Pbest,Jbest]=QBFA(id,IterMax,beta1,EvalNum,Nb,Ncs,Ns,Nre,Ned,Ped,VarNumber)
% DispFlag  display the information if DispFlag=1;
%disp('input the benchmark function id number:default is id=1')
%EvalNum=1;
%id=input('the function id you want to evaluate=');
%default arguments
% id                %function id;(for details ,read READ ME)
% IterMax=1.5E4;    % The max iteration steps 
% beta1=1;          % AVR PID 1<beta<1.5
% EvalNum=1;        %times myqbfa runs
% Nb=50;         % The number of bacteria
% Ncs=50;        % Number of chemotactic steps
% Ns=20;         % Limits the length of a swim
% Nre=10;        % The number of reproduction steps
% Ned=5;
% Ped=0.25;      % The number of elimination-dispersal events
% VarNumber      % number of function is variables
if nargin<1    
    id=input('the function id you want to evaluate(1<id<=20)=');
    IterMax=1.5E4;      % The max iteration steps 
    beta1=1;EvalNum=1;
    Nb=50;Ncs=50;Ns=20;Nre=10;Ned=5;Ped=0.25;
elseif nargin==1
    IterMax=1.5E4;      % The max iteration steps 
    beta1=1;EvalNum=1;
    Nb=50;Ncs=50;Ns=20;Nre=10;Ned=5;Ped=0.25;
elseif nargin==2
    beta1=1;EvalNum=1;
    Nb=50;Ncs=50;Ns=20;Nre=10;Ned=5;Ped=0.25;
elseif nargin==3
    EvalNum=1;Nb=50;Ncs=50;Ns=20;Nre=10;Ned=5;Ped=0.25;
elseif nargin==4
    Nb=50;Ncs=50;Ns=20;Nre=10;Ned=5;Ped=0.25;
elseif nargin==5
    Ncs=50;Ns=20;Nre=10;Ned=5;Ped=0.25;            
elseif nargin==6
    Ns=20;Nre=10;Ned=5;Ped=0.25;                 
elseif nargin==7
    Nre=10;Ned=5;Ped=0.25;              
elseif nargin==8
    Ned=5;Ped=0.25;                 
elseif nargin==9
    Ped=0.25;                  
else
end
 for i=1:EvalNum        % eval it EvalNum(default is 50) times
    DispFlag=1;Iter=1;
    filename=strcat(num2str(id),'th Function','.txt');
    if DispFlag==1
       fprintf(1,'This is the  %d th run the function ( function id is:  %d ) \n',i,id);
    end
    tic
     [Iter,Jbest,Pbest]=qbfa(Nb,Ncs,Ns,Nre,Ned,Ped,VarNumber,DispFlag,Iter,IterMax,id,beta1);
    time=toc;
    dlmwrite(filename, [Jbest,Iter,time,Pbest],'delimiter','\t','precision','%.20f','-append');
    dlmwrite(filename, [],'delimiter', '\n','-append');
    clc;
    pause(2);
end
%load gong
%sound(y,Fs);
try
    type(filename);
catch
    disp('The file you want to find does not exist');
end
function [Iter,Jbest,Pbest]=qbfa(Nb,Ncs,Ns,Nre,Ned,Ped,VarNumber,DispFlag,Iter,IterMax,id,beta1)
C=rand(Nb,1);           % the run length
row=1:2:2*Nb;
bound=[[-[100,10,100,100,30,100,1.28,500,5.12,32,600,50,50,65.536,5,5,5,2,10],0.1];
        [100,10,100,100,30,100,1.28,500,5.12,32,600,50,50,65.536,5,5,15,2,10,1]];
bound=bound(:,id);
BoundFun=bound(2)-bound(1);
theta=linspace(0,pi/2,Nb);
J=zeros(Nb,Ncs+1);P=zeros(Nb,VarNumber,Ncs+1);
%Population     the quantum individual
Population(row,:)=repmat(cos(theta'),1,VarNumber);
Population(row+1,:)=repmat(sin(theta'),1,VarNumber);
P(:,:,1)=Population(row,:).^2*BoundFun+bound(1);
% Population
[Jbest,Jindex]=min(FN(P(:,:,1),id,beta1));
Pbest=P(Jindex,:,1);
Iter=Iter+Nb;
% U1----quantum rotate angle Eastern; U2----Clockwise
theta1=0.001*pi;theta2=-0.001*pi;
U1=[cos(theta1),-sin(theta1);sin(theta1),cos(theta1)];
U2=[cos(theta2),-sin(theta2);sin(theta2),cos(theta2)];
for eld=1:Ned
    for k=1:Nre
        for j=1:Ncs
            if Iter>IterMax
               break;break;break;
            end
            for i=1:Nb
%                 fprintf(1,'This is the  %d th bacteria''s %dth chemotaxis step  ( function id is:  %d ) \n',i,j,id);
%tumble
                J(i,j)=FN(P(i,:,j),id,beta1);Iter=Iter+1;
                rowIndex=2*i-1:2*i;  
                if J(i,j)>Jbest
                    xLBestInd=find(P(i,:,j)<=Pbest);
                    xGBestInd=find(P(i,:,j)>Pbest);
                     if ~isempty(xLBestInd) %rotate Clockwise
                        Population(rowIndex,xLBestInd)=U2*Population(rowIndex,xLBestInd);
                     end
                     if ~isempty(xGBestInd) %rotate Eastern
                        Population(rowIndex,xGBestInd)=U1*Population(rowIndex,xGBestInd);
                     end
                else
                    xLBestInd=find(P(i,:,j)<=Pbest);
                    xGBestInd=find(P(i,:,j)>Pbest);
                     if ~isempty(xLBestInd)  %rotate Clockwise
                        Population(rowIndex,xLBestInd)=U1*Population(rowIndex,xLBestInd);
                     end
                     if ~isempty(xGBestInd) %rotate Eastern
                        Population(rowIndex,xGBestInd)=U2*Population(rowIndex,xGBestInd);
                     end                
                end
               P(i,:,j+1)=Population(rowIndex(1),:).^2*BoundFun+bound(1);
               Pij=FN(P(i,:,j+1),id,beta1);
               if Pij<Jbest
                   Jbest=Pij;
                   Pbest=P(i,:,j+1);
                   fprintf(1,'the  most best is (Jbest(tumble):%d), ( function id is:  %d ) \n',Jbest,id);
%                    fprintf(1,'the %dth bacteria,%dth chemotaxis step,%dth reproduction and %dth elimination step',i,j,k,eld);
               end
 %swim
          counter=0;Jlast=Pij;         % Initialize counter for swim length
            while counter<Ns
                  counter=counter+1;
                  if J(i,j+1)<=Jlast
                     Jlast=J(i,j+1);
                     Delta=(2*rand(1,VarNumber)-1).*rand(1,VarNumber);
                     P(i,:,j+1)=P(i,:,j+1)+C(i)*Delta/norm(Delta) ;
                     J(i,j+1)=FN(P(i,:,j+1),id,beta1); Iter=Iter+1;
                     Jlast=J(i,j+1);Iter=Iter+1;
                     if Jlast<Jbest
                        Jbest=Jlast;
                        Pbest=P(i,:,j+1);
                        fprintf(1,'the  most best is (Jbest(tumble):%d), ( function id is:  %d ) \n',Jbest,id);
%                         fprintf(1,'the %dth bacteria,%dth chemotaxis step,%dth reproduction and %dth elimination step',i,j,k,eld);
                     end
                  else
                     counter=Ns ;
                  end
            end
          end
%           P(i,:,j)=Population(rowIndex(1),:).^2*BoundFun+bound(1);
%           [Jbest,Jindex]=min(FN(P(:,:,j),id));Iter=Iter+Nb;
%           Pbest=P(Jindex,:,j);
%           P(i,:,j+1)=P(i,:,j);
        end
        P(:,:,1)=P(:,:,Ncs+1);
    end
%   Reprodution
        Jhealth=sum(J,2);              % Set the health of each of the S bacteria
        C=C/2;   
end
% [Jbest,JIndex] =min(J(:))
% [rowsub,colsub]=ind2sub([Nb,Ncs+1],JIndex);
% Pbest=P(rowsub,:,colsub);
function f_value=FN(x,id,beta1)
persistent sizeRow sizeCol
sizeRow=size(x,1);sizeCol=size(x,2);
switch id
%--------------------------------------------------------------------------
%-------High  Dimensional Unimodal Benchmark Functions
%--------------------------------------------------------------------------
case 1
    %    Sphere Model:min(f(0,...,0))=0;time=;
    %   f_{1}(x)=\sum_{i=1}^{30}(x_i^2)%x_i\in [-100,100]
    f_value=sum(x.^2,2);% the number of row is determined by p
case 2
    %    schwefel's Problem 2.22:min(f(0,...,0))=0;time=;
    %   f_{2}(x)=\sum_{i=1}^{30}abs(x_i)+\prod_{i=1}^{30}abs(x_i)
    %   x_i\in [-10,10]
    s=1;
    for i=1:sizeCol
        s=s.*abs(x(:,i));
    end
    f_value=sum(abs(x),2)+s;
case 3
%   schwefel's Problem 1.2:x_i\in [-100,100],min(f(0,...,0))=0;y=0,pbest=[0,0]
%   f_{3}(x)=\sum_{i=1}^{30}(\sum_{j=1}^{i}(x_j))^2;time=;
    s=0;
    for i=1:sizeCol
        s=s+sum(x(:,1:i),2).^2;
    end
    f_value=s;
case 4
    %   schewfel's problem 2.21:x_i\in [-100,100],min(f(0,...,0))=0;time=;
    %   f_{4}(x)=\max(abs(x_i))
    f_value=max(abs(x),[],2);
case 5
    %   generalized Rosenbrock's Function
    %   :x_i\in [-30,30],min(f(1,...,1))=0;time=
    %   f_{5}(x)=\sum_{i=1}^{29}(100(x_{i+1}-x_i)+(x_i-1)^2)
    f_value=zeros(sizeRow,1);
    sizeCol=sizeCol-1;
    for i=1:sizeCol
         f_value=f_value+100*(x(:,i+1)-x(:,i).^2).^2+(x(:,i)-1).^2;
    end
case 6       
    %   Step function: $x_i\in (-100,100),min(f([-0.5,0.5],...,1-0.5,0.5]))=0;$
    f_value=sum(floor(x+0.5).^2,2);
case 7
    %   Quartic Function i.e. Noise:x_i\in [-1.28,1.28],min(f(0,...,0))=0;
    %   f_{7}(x)=\sum_{i=1}^{30}(i x_^4_i)+random[0,1]%
    f_value=zeros(size(x,1),1);
    for i=1:sizeCol
      f_value=f_value+i*x(:,i).^4;
    end
    f_value=f_value+rand;
%--------------------------------------------------------------------------
%-------High  Dimensional Multimodal Benchmark Functions
%--------------------------------------------------------------------------
case 8
    %   $f_8(x)=-\sum_{i=1}^{30}:x_i\in [-500,500],(x_i...
    %   \sin(\sqrt{|x_i|}));minf(x_i)=-12569.5,x_i=420.9687;time=;$
    %   minf =-418.9829n
    f_value=zeros(size(x,1),1);
    for i=1:sizeCol
        f_value=f_value-x(:,i).*sin(sqrt(abs(x(:,i))));
    end
case 9
    %   Generalized Rastrigin's Function
    %   x_i\in [-5.12,5.12],min(f(0,...,0))=0;ok
    %   f_{9}(x)=-\sum_{i=1}^{30}(x_i^2-10 cos(2*pi x_i+10);
    f_value=zeros(size(x,1),1);
    f_value=f_value+(x(:,i).^2-10.*cos(2*pi*x(:,i))+10);
case 10
    %   Ackley's Function:min(f(0,...,0))=0;time=;
    %   f_{10}(x)=-20 \exp(-0.2\sqrt{\frac{1}{30}\sum_{i=1}^{30}{x_i^2}}-\exp(\frac{1}{30}\sum_{i=1}^{30}\cos{2\pi x_i})+20+e
    f_value1=0;f_value2=0;
    for i=1:sizeCol
          f_value1=f_value1+x(:,i).^2;
          f_value2=f_value2+cos(2*pi*x(:,i));
    end
    f_value=-20*exp(-0.2* sqrt(f_value1/30))-exp(f_value2/30)+20+exp(1);
case 11
    %   Griewank function         
    %   $f_{11}(x)=\frac{1}{4000}\sum_{i=1}^{30}{x_i^2}-\prod_{i=1}^{30}\cos(\f
    %   rac{x_i}{\sqrt{i}})+1,min(f(0,...0))=0;$
    f_value1=0;f_value2=1;
    for i=1:sizeCol
          f_value1=f_value1+x(:,i).^2;
          f_value2=f_value2.*cos(x(:,i)/sqrt(i));
    end
    f_value=f_value1/4000-f_value2+1;
case 12
    %    Generalized Grewank function 1       
    %   $f_{12}(x)= \frac{\pi}{30}\sum_{i=1}^{29}(y_i-1)^2 [1+10\sin^2(\pi
    %   y_{i+1})]+(y_n-1)^2 \}\\+\frac{\pi}{3}\sin^2(\pi y_i)+ \sum_{i=1}^{30}u(x_i,10,100,4)$
    %   min(f(1,...,1))=0;$x_i\in [-50,50]$;
    y=(x+1)/4+1;
    f_value1=(10*sin(y(:,1)*pi).^2+(y(:,end)-1).^2);
    f_value2=0;
    for i=1:sizeCol-1
    f_value2=f_value2+((y(:,i)-1).^2.*(1+10*sin(y(:,i+1)*pi).^2));
    end
    f_value3=ui(x,10,100,4);
    f_value= pi*(f_value1+f_value2)/sizeCol+f_value3;
case 13
    %   Generalized Grewank function 2       
    %   $f_{13}(x)= 0.1(sin(3\pi x_1).^2+\sum_{i=1}^{29}(x_i-1)^2(1+sin(3\pi x_{i+1}).^2)+((x_n)^2)(1+sin(2\pi x_{30}).^2))+ \sum_{i=1}^{30}u(x_i,5,100,4)$
    %   min(f(1,...,1))=0;$x_i\in [-50,50]$;time=;
    f_value1=sin(3*pi*x(:,1)).^2+(x(:,end)-1).^2.*(1+sin(2*pi*x(:,end)).^2);
    f_value2=0;
    for i=1:sizeCol-1
    f_value2=f_value2+((x(:,i)-1).^2.*(1+sin(3*pi*x(:,i+1)).^2));
    end
    f_value3=ui(x,5,100,4);
    f_value= 0.1*(f_value1+f_value2)+f_value3;
%--------------------------------------------------------------------------
%   Low Dimensional Multimodal Benchmark Functions
%--------------------------------------------------------------------------
case 14
    %   Shekel's Foxholes function:$x_i\in -65.536,65.536,min(f(-32,-32))=0.998;$
    %   f_{14}(x)=1/500+\Sum_{j=1}^{2}{\frac{5}{j+\Sum_{i=1}^{2}(x_i-a_{ij})^6}};
    %   a=16*((mod(i,5))-2);b=16*(floor(mod(i,5))-2);
    f_value=0.002;i=0:30;a=16*((mod(i,5))-2);b=16*(floor(i/5)-2);f_value1=0;
    for j=1:2
        f_value1=f_value1+1./(j+(x(:,1)-a(j)).^6+(x(:,2)-b(j)).^6);
    end
    f_value=1./(f_value+f_value1);
case 15
    %   Kawalik's function
    %   f(0.1928,0.1928,0.1231,0.1358)=0.0003075;x_i\in [-5,5];
    a=[0.1957,0.1947,0.1735,0.16,0.0844,0.0627,0.0456,0.0342,0.0323,0.235,0.0246];
    b=1./[0.25,0.5,1,2:2:16];f_value=0;
    for i=1:11
        f_value=f_value+(a(i)-(x(:,1).*b(i).*(b(i)+x(:,2)))./(b(i).*(b(i)+x(:,3))+x(:,4))).^2;
    end
case 16
    %   Six-Hump Camel-Back function
    %   $f_{16}(x)= 4*x_1^2-2.1*x_1^4+x_1^6/3+x_1*x_2-4*x_2^2+4*x_2^4;
    %   dimension=2;min(f(0.08983,-0.7126))=-1.0316285;time=;$
    f_value=4*x(:,1).^2-2.1*x(:,1).^4+x(:,1).^6/3+x(:,1).*x(:,2)-4*x(:,2).^2.*(1-x(:,2).^2);
case 17
    %   $f_{17}(x)=\frac{x_2-5.1x_1^2}{4 \pi^2}+\frac{5 x_1^2}{\pi-6}+10(1-\frac{1}{8 \pi}cos(x_1))+10;
    %   x\in [-5,10]*[0,15];time=;$
    f_value=(x(:,2)-5.1*x(:,1).^2/(4*pi^2)+5*x(:,1)/pi-6).^2+10*(1-1/(8*pi)).*cos(x(:,1))+10;
case 18
    %   Goldstein-Price function        
    %   $f_{18}(x)= ;
    %   dimension=2;min(f(0,-1))=3$
    f_value=(1+(x(:,1)+x(:,2)+1).^2.*(19-14*x(:,1)+3*x(:,1).^2-14*x(:,2)+6*x(:,1).*x(:,2)+3*x(:,2).^2))...
    .*(30+(2*x(:,1)-3*x(:,2)).^2.*(18-32*x(:,1)+12*x(:,1).^2+48*x(:,2)-36*x(:,1).*x(:,2)+27*x(:,2).^2));
case 19
    f_value=(x(:,2)-x(:,1)).^2+100.0*(x(:,1)-1).^2;
case 20
    %AVR system, pid
    % beta=0.5;
    % beta=1;
    % beta=1.5;
    for i=1:sizeRow
        %[Kp,Ki,Kd]=x(i,:);
        f_value(i)=pid(beta1,x(i,1),x(i,2),x(i,3));
    end
end
function y=ui(x,a,k,m)
% ui is a subfun of function 11
x_tmp=x(:);
index=find(x_tmp>a);
if length(index)>0
    x_tmp(index)=k*(x_tmp(index)-a).^m;
end
index=find(x_tmp<-a);
if length(index)>0
    x_tmp(index)=k*(-x_tmp(index)-a).^m;
end
index=intersect(find(x_tmp>=-a),find(x_tmp<=a));
if length(index)>0
    x_tmp(index)=0;
end
x_tmp=reshape(x_tmp,size(x));
y=sum(x_tmp,2);

% AVR system with PID

function f_value=pid(beta,Kp,Ki,Kd)
%clc,clear
% beta=1.5;
% beta=1;
% beta=0.5;
Maxt=6.9834;delta=0.02;
%  GA
%  Kp=0.8282;Ki=0.7143;Kd=0.3010;
%  PSO
%  Kp=0.6445;Ki=0.5043;Kd=0.2348;
%  %GA-PSO
%  Kp=0.6794;Ki=0.6167;Kd=0.2681;
% % BF-GA
%beta=0.5;f_value=0.1154 
%beta=1; f_value=0.0569
%beta=1.5;f_value =0.0376
% Kp=0.68233;Ki=0.6138;Kd=0.26782;
%%%%%%%%%%%%%%%%%
%beta=0.5;f_value=0.1107 
%beta=1; f_value=0.0487
%beta=1.5;f_value= 0.0282
% Kp=0.68002;Ki=0.52212;Kd=0.24401;
% %%%%%%%%%%%%%%%%%
%beta=0.5;f_value=0.1095
%beta=1; f_value=0.0450
%beta=1.5;f_value=0.0237
% Kp=0.67278;Ki=0.47869;Kd=0.22987;
%%%%%%%%%%%%%%%%%

%beta=1.5;%f_value=0.0237
%beta=0.5;f_value=
%beta=1;
% Kp=0.6476;Ki=0.5216;Kd=0.2375;
% Kp=0.8935;Ki=0.6458;Kd=0.4014;
% function [yopen,topen,y,t,Mo,Ts,Tr,Tp]=pid_avr(Kp,Ki,Kd,beta,delta)
Gc_PID=tf([Kd Kp Ki],[1 0]);
num=10;
den=conv([1,1],conv([0.1,1],[0.4,1]));
G=tf(num,den);
Gcl_PID=feedback(series(Gc_PID,G),tf([1],[0.01,1]));
% step response of terminal voltage in an AVR system whthout controller
[yopen,topen]=step(feedback(G,tf([1],[0.01,1])),10);
% plot(topen,yopen),grid
% xlabel('time(sec)');
% ylabel('termmal voltage');
% title('Teminal voltage step response')
% Calculate overshoot
% figure
t=0:1E-3:2;
[y,t]=step(Gcl_PID,t);
% plot(t,y),grid
% xlabel('time(sec)');
% ylabel('termmal voltage');
% title('Teminal voltage step response');
[MaxVal,MaxVal_ind]=max(y);
FinalVal=1;
Mo=(abs(MaxVal)-abs(FinalVal))/abs(FinalVal);
% disp(sprintf('Max %% overshoot Mo= %g%%',100*Mo));
% Calculate steady state error
Ess=abs(1-y(end));
% disp(sprintf('steady state error Ess= %g',Ess));
% Calculate settling time (to 2%)
for i=1:length(y)
     if abs(y(i)-1)<delta
         Ts=t(i);
         break;
      else
         Ts=t(i);
     end
end
% disp(sprintf('Settling time Ts= %g',Ts));
% Calculate the rise time;
index1=find(y>0.1*y(end));  %Find the index where >0.1h(infity)% 
index2=find(y<0.9*y(end));  %Find the index where >0.1h(infity)%
Tr=t(max(index2))-t(min(index1));
%disp(sprintf('rise time Tr = %g',t(max(index2))-t(min(index1))));
% Calculate peak time
Tp=t(MaxVal_ind);
%disp(sprintf('peak time Tp= %g',t(MaxVal_ind)))
%Calculate the evaluation value
% The Performance criterion defined as(AVR)
if Mo>0.02|Ess>0.0909| Tr>0.2693|Ki<2*Kd
    f_value=inf;
else
alpha=(1-exp(-beta))*abs(1-Tr/Maxt);
f_value=exp(-beta)*(Ts/Maxt+alpha*Mo)/alpha+Ess;
end
