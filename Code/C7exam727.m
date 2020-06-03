clc
clear
input=[1,2,3;4,5,6;7,8,9]
CovKenel=[-1,-2,-1;0,0,0,;1,2,1]
conv2(input,CovKenel,'same')

