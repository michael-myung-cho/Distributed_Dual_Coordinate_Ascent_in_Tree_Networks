%% Simulation for convergence (Fig. 11(a))
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


K0=5;
C0=0.9;
T0=5;

for p=5:-1:1 % 3 layers
    Xaxis=[Xaxis;p];  % due to the index starting from 1 in matlab, substracted the layer number by 1
    Theta=zeros(p,1);
    K=5*ones(p,1); % 10 computers each
    C=0.9*ones(p,1);
    T=5*ones(p,1);
    
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
    %% Approx. convergence bound
    ThetaApprox0=thetapApprox(p, K, C, T, K0, C0, T0, Thetap);     % Theta0
    ConvBound4WholeApprox=[ConvBound4WholeApprox;ThetaApprox0];
    
end

plot(Xaxis,ConvBound4Whole,'r-x',Xaxis,ConvBound4WholeApprox,'b--o');

abs(T0*C0*Thetap/(K0-C0))

C0*T0/(K0-C0)*Thetap

K0/C0

(((K0-C0)/K0)^T0)*((C0*T0)/(K0-C0))






