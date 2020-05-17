
function fposition=Live_fn(x)

x=fix(100*rand(2,1));
    p=0;q=0;
    for k=1:5
    p=p+k*cos((k+1)*x(1)+k);
    q=q+k*cos((k+1)*x(2)+k);
    end

fposition=p*q+(x(1)+1.42513)^2+(x(2)+.80032)^2
% [R,L]=size(x);tp=zeros(R,1);
% for i=1:R
%     for j=1:L
%         temp=x(i,j)^2;
%     end
%     tp(i)=temp;
% end
% fposition=tp;
% return 