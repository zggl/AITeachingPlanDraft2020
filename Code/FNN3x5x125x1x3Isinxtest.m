function FNN3_5_125_1()
% Initializaiton
clc;clear;
NumIn=3;NumDiv=5;Num=30;%data size
x1=linspace(-1,1,Num);
x2=linspace(0,3,Num);
x3=linspace(0,2*pi,Num);
X=[x1;x2;x3];
ym_fun=@(x)x(1,:).^2+x(2,:).^3.*sin(x(3,:));y= ym_fun(X);
m=[linspace(-1,1,NumDiv)',linspace(0,3,NumDiv)',linspace(0,2*pi,NumDiv)'];
theta=rand(1,NumDiv^NumIn);
Theta_ori=theta;
sigma=ones(NumDiv,NumIn);
Sigma_ori=sigma;
net1=zeros(NumIn,1);net2=zeros(NumDiv,NumIn);net3=zeros(NumDiv,NumDiv,NumDiv);
eta=[0.9;0.15;0.15];er=1.04;lr=0.01;im=1.05;dm=0.6;mc=0.8;eg=1e-5;
for Epoch=1:Num
    net1=X(:,Epoch);yd=y(Epoch);SSE=inf;
    for kk=1:5000 
        if SSE<eg,disp(sprintf('%g th dataset, Error:%e,  innne loop %g',Epoch,SSE,kk)),break,end
        for i=1:NumIn
            for j=1:NumDiv
                net2(j,i)=exp(-norm(net1-m(j,:)')^2/(sigma(j,i)^2)); 
            end
            %choose the most two high value
            %net2(:,i)=(net2(:,i)>mean(net2(:,i))).*net2(:,i);
        end
        for k=1:NumDiv
            for i=1:NumDiv
                for j=1:NumDiv
                    net3(j,i,k)=net2(j,1)*net2(i,2)*net2(k,3);   
                end
            end
        end
        net4=theta*net3(:);
        delta1_4=yd-net4;
        SSE=sumsqr(delta1_4);
        delta_theta=delta1_4*net3(:)';   
        delta3=delta1_4*theta(:)';
        delta_3dim=reshape(delta3,NumDiv,NumDiv,NumDiv);
        for j=1:NumDiv
            ind1=delta_3dim(:,:,j);
            ind2=delta_3dim(:,j,:);
            ind3=delta_3dim(j,:,:);
            delta2(j,1)=(ind1(:)'*kron(net2(:,2),net2(:,3)))*net2(j,1);
            delta2(j,2)=(ind2(:)'*kron(net2(:,1),net2(:,3)))*net2(j,2);
            delta2(j,3)=(ind3(:)'*kron(net2(:,1),net2(:,2)))*net2(j,3);
        end
        for i=1:NumIn
            for j=1:NumDiv
                delta_m(j,i)=delta2(j,i)*(2*(net1(i)-m(j,i))^2/sigma(j,i)^2);
                delta_sigma(j,i)=delta2(j,i)*(2*(net1(i)-m(j,i))^2/sigma(j,i)^3);
            end
        end
        %learning phase
        new_theta=theta+eta(1)*delta_theta;
        new_m=m+eta(2)*delta_m;
        new_sigma=sigma+eta(3)*delta_sigma;
        % presentation phase
        for i=1:NumIn
            for j=1:NumDiv
                new_net2(j,i)=exp(-norm(net1-new_m(j,:)')^2/(new_sigma(j,i)^2)); 
            end
            %choose the most two high value
            %net2(:,i)=(net2(:,i)>mean(net2(:,i))).*net2(:,i);
        end
        for k=1:NumDiv
            for i=1:NumDiv
                for j=1:NumDiv
                    new_net3(j,i,k)=new_net2(j,1)*new_net2(i,2)*new_net2(k,3);   
                end
            end
        end
        new_net4=new_theta*new_net3(:);
        new_e=yd-new_net4;
        new_SSE=sumsqr(new_e);
        if  new_SSE>SSE*er
            eta=eta*mc;
        else
            if new_SSE<SSE
                eta=eta+lr*eta*im;
            end
            m=new_m;sigma=new_sigma;theta=new_theta;delta1_4=new_e;
            net2=new_net2;net3=new_net3;
            SSE=new_SSE;
        end
    end
    %SSE
end
%simu


