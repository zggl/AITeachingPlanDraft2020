clc
total_point=input('输入图的结点数:')
l=inf*ones(total_point);
%给图赋权图
l(1,2)=4;l(1,3)=6;
l(2,4)=5;l(2,5)=4;
l(3,4)=4;l(3,5)=7;
l(4,6)=9;l(4,7)=7;
l(5,6)=5;l(5,7)=6;
l(6,7)=5;l(6,8)=4;
l(7,8)=1;
startp=input('输入起始点的标号startp:')
endp=input('输入终点的标号endp:')
T=inf*ones(1,total_point);
P=T;
P(startp)=0;
%算法初始化
i=startp;
count=1;
while count<=total_point-1%遍历每一个结点
    for jj=1:total_point
        if l(i,jj)<inf
            T(jj)=min(T(jj),P(i)+l(i,jj));
        end
    end
%在T中取最小值
[minT,posT]=min(T);
P(1,posT)=minT;
%标记T,标记为永久记号的点为无穷
T(1,posT)=inf;
count=count+1;
i=posT;
end
P

    
