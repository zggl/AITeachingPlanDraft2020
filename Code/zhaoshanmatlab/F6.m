function [y,y4]=F6(x,mu) 
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
    y3=y1/y2-w;   
y=-y4+mu*(y3);
