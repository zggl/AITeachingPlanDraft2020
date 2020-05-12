function [x,y] = plotcircle(xo,yo,thetao,d)
theta = 0:0.1:2*pi+pi/32;
x = xo + d.*cos(theta+thetao);
y = yo + d.*sin(theta+thetao);