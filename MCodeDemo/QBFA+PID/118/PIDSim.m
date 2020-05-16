%id=input('the function id you want to evaluate(1<id<=20)=');
clc,clear
id=20               % function id for AVR simulation
IterMax=1.5E4;      % The max iteration steps 
 beta=.5;            % AVR system PID
% beta=1;            % AVR system PID
% beta=1.5;            % AVR system PID
EvalNum=1;
Nb=50;Ncs=50;Ns=20;Nre=10;Ned=5;Ped=0.25;
VarNumber=[30*ones(1,13),2,4,2,2,2,2,3];
VarNumber=VarNumber(id);
% Run Quantum inspired bacterial Foraging algorithm to calculate the
% Kp,Ki,Kd
% [Pbest,f_value1]=QBFA(id,IterMax,beta,EvalNum,Nb,Ncs,Ns,Nre,Ned,Ped,VarNumber);
% Kp=Pbest(1);
% Ki=Pbest(2);
% Kd=Pbest(3);
delta=0.02;Maxt=6.9834;SimTime=2;
PID_AVR(Kp,Ki,Kd,beta,delta,Maxt,SimTime)
