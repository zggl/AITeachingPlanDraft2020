function f_value=PID_AVR(Kp,Ki,Kd,beta,delta,Maxt,SimTime)
% function [yopen,topen,y,t,Mo,Ts,Tr,Tp]=PID_AVR(Kp,Ki,Kd,beta,delta)
% GA
% Kp=0.8282;Ki=0.7143;Kd=0.3010;
% PSO
% Kp=0.6445;Ki=0.5043;Kd=0.2348;
% GA-PSO
% Kp=0.6794;Ki=0.6167;Kd=0.2681;
% BF-GA
%beta=1.5; Kp=0.68233;Ki=0.6138;Kd=0.26782;
%beta=1.5; Kp=0.68002;Ki=0.52212;Kd=0.24401;
%BF-GA
%beta=1;Kp=0.67278;Ki=0.47869;Kd=0.22987;
%QBFA 
%beta=1;Kp=0.8007;Ki=0.6670;Kd=0.3276;
%beta=1;Kp=0.7622;Ki=0.6824;Kd=0.2679;
% beta=1; Kp=0.6476;Ki=0.5216;Kd=0.2375;
% beta=1; Kp=0.8935;Ki=0.6458;Kd=0.4014;
disp(sprintf('Beta=%g\nKp=%g\n Ki=%g\n Kd=%g',beta,Kp,Ki,Kd));
Gc_PID=tf([Kd Kp Ki],[1 0]);
num=10;
den=conv([1,1],conv([0.1,1],[0.4,1]));
G=tf(num,den);
Gcl_PID=feedback(series(Gc_PID,G),tf([1],[0.01,1]))
% step response of terminal voltage in an AVR system whthout controller
[yopen,topen]=step(feedback(G,tf([1],[0.01,1])),10);
plot(topen,yopen),grid
xlabel('time(sec)');
ylabel('termmal voltage');
title('Terminal voltage step response')
% Calculate overshoot
figure
t=0:1E-3:SimTime;
[y,t]=step(Gcl_PID,t);
plot(t,y),grid
xlabel('time(sec)');
ylabel('termmal voltage');
title('Terminal voltage step response');
[MaxVal,MaxVal_ind]=max(y);
FinalVal=1;
Mo=(abs(MaxVal)-abs(FinalVal))/abs(FinalVal);
disp(sprintf('Max %% overshoot Mo= %g%%',100*Mo));
% Calculate steady state error
Ess=abs(1-y(end));
disp(sprintf('steady state error Ess= %g',Ess));
% Calculate settling time (to 2%)
for i=1:length(y)
     if abs(y(i)-1)<delta
         Ts=t(i);
         break;
     end
end
disp(sprintf('Settling time Ts= %g',Ts));
% Calculate the rise time;
index1=find(y>0.1*y(end));  %Find the index where >0.1h(infity)% 
index2=find(y<0.9*y(end));  %Find the index where >0.1h(infity)%
Tr=t(max(index2))-t(min(index1));
disp(sprintf('rise time Tr = %g',t(max(index2))-t(min(index1))));
% Calculate peak time
Tp=t(MaxVal_ind);
disp(sprintf('peak time Tp= %g',t(MaxVal_ind)))
%Calculate the evaluation value
alpha=(1-exp(-beta))*abs(1-Tr/Maxt);
if Mo>0.1|Ess>0.0909| Tr>0.2693|Ki<2*Kd
    f_value=inf;
else
f_value=exp(-beta)*(Ts/Maxt+alpha*Mo)/alpha+Ess
end
