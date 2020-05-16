% Beta=0.5;Kp=0.771297;Ki=0.738418;Kd=0.324263 %   Mo<2%
% Beta=1;Kp=0.705179;Ki=0.593131;Kd=0.293957;f_value =0.0497
% Beta=1.5;Kp=0.669828;Ki=0.582401;Kd=0.280438;f_value =0.0349
PID_data=[0.771297,0.738418,0.324263;
          0.705179,0.593131,0.293957;
          0.669828,0.582401,0.280438];
style={'-r','-.m','--b'}
for i=1:3
Kp=PID_data(i,1);Ki=PID_data(i,2);Kd=PID_data(i,3);
Gc_PID=tf([Kd Kp Ki],[1 0]);
num=10;
den=conv([1,1],conv([0.1,1],[0.4,1]));
G=tf(num,den);
Gcl_PID=feedback(series(Gc_PID,G),tf([1],[0.01,1]))
% step response of terminal voltage in an AVR system whthout controller
[yopen,topen]=step(feedback(G,tf([1],[0.01,1])),10);
% plot(topen,yopen),grid
% xlabel('time(sec)');
% ylabel('termmal voltage');
% title('Teminal voltage step response')
% Calculate overshoot
t=0:1E-3:SimTime;
[y,t]=step(Gcl_PID,t);
plot(t,y,style{i},'LineWidth',1),grid
hold on
end
legend('\beta=0.5','\beta=1','\beta=1.5')
xlabel('time(sec)');
ylabel('termmal voltage');
title('Teminal voltage step response');