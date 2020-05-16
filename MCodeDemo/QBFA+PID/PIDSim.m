%id=input('the function id you want to evaluate(1<id<=20)=');
clc,clear
id=8               % function id for AVR simulation
IterMax=1E6;      % The max iteration steps 
 beta=1;            % AVR system PID
% beta=1;            % AVR system PID
% beta=1.5;            % AVR system PID
EvalNum=1;
Nb=50;Ncs=50;Ns=20;Nre=10;Ned=5;Ped=0.25;
VarNumber=[30*ones(1,13),2,4,2,2,2,2,3];
VarNumber=VarNumber(id);
% Run Quantum inspired bacterial Foraging algorithm to calculate the
% Kp,Ki,Kd
%[Pbest,f_value1]=QBFA(id,IterMax,beta,EvalNum,Nb,Ncs,Ns,Nre,Ned,Ped,VarNumber);
% Kp=Pbest(1);
% Ki=Pbest(2);
% Kd=Pbest(3);
% beta=1.5;Kp=0.817531;Ki=0.625271;Kd=0.30253   %   Mo<6%
% beta=0.5;Kp=0.771297;Ki=0.738418; Kd=0.324263
% beta=0.5;Kp=0.771297;Ki=0.738418;Kd=0.324263 %   Mo<2%
 beta=1.5;Kp=0.669828;Ki=0.582401;Kd=0.280438;f_value =0.0349
% beta=1;Kp=0.705179;Ki=0.593131;Kd=0.293957;f_value =0.0497
delta=0.02;Maxt=6.9834;SimTime=2;
PID_AVR(Kp,Ki,Kd,beta,delta,Maxt,SimTime)
