%% Simulation for convergence (Fig. 10)
% Myung Cho, Lifeng Lai, and Weiyu Xu, 
% "Distributed dual coordinate ascent in general tree networks and communication network effect on synchronous machine learning,”
% IEEE Journal on Selected Areas in Communication (JSAC), 2021
%-------------
clear all;
clc;
clf;

ConvBound4Whole=[];
ConvBound4WholeApprox=[];
ConvBound4WholeApprox2=[];
Thetap=0.5;
Xaxis=[];

for kv=5:1:10 % 3 layers
    Xaxis=[Xaxis;kv];  % due to the index starting from 1 in matlab, substracted the layer number by 1
    p=3;
    Theta=zeros(p,1);
    K=kv*ones(p,1); % 10 computers each
    C=0.9*ones(p,1);
    T=40*ones(p,1);
    
    K0=K(1);
    C0=C(1);
    T0=T(1);
    
    
    
    %% Exact convergence bound
    Theta(p,1) = Thetap;
    if p ~= 1
        for ii=p-1:-1:1
            Theta(ii,1) = (1 - ( 1 - Theta(ii+1,1))* C(ii)/K(ii))^T(ii);
        end
    end
    Theta0=(1 - (1 - Theta(1,1))*C0/K0)^T0;
    fprintf('Convergence bound for whole system: %f\n', Theta0);
    
    ConvBound4Whole=[ConvBound4Whole;Theta0];
    
    ThetaApprox2 = (((K0-C0)/K0)^T0) + (((K0-C0)/K0)^T0)* ( (((K0-C0)/K0)^T0)*((C0*T0)/(K0-C0)) - ((((K0-C0)/K0)^T0)*((C0*T0)/(K0-C0)))^p  )/(1-(((K0-C0)/K0)^T0)*((C0*T0)/(K0-C0))) + (((((K0-C0)/K0)^T0)*((C0*T0)/(K0-C0)))^p)*Thetap;
    ConvBound4WholeApprox2=[ConvBound4WholeApprox2;ThetaApprox2];
end

plot(Xaxis,ConvBound4Whole,'r-x',Xaxis,ConvBound4WholeApprox2,'b--o');

abs(T0*C0*Thetap/(K0-C0))

C0*T0/(K0-C0)*Thetap

K0/C0

(((K0-C0)/K0)^T0)*((C0*T0)/(K0-C0))






