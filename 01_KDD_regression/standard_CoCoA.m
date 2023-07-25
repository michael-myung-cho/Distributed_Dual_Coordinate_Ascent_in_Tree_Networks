function [dualGap,tOP,T] = standard_CoCoA(dataset, MaxItrOut, weight_wor_sub, weight_Cen_Sub,H)
%% Standard CoCoA
% number of local iterations = tdelay*weight
% MaxItrOut: # of communication between center and subcenter
% MaxItrIn: # of communications between local workers and subcenter
%---------------------

lambda=1;
y0=dataset(:,end); % wine quality
X=dataset(:,1:end-1)'; % conditions (acid, alcohol, etc.)
[n,m]=size(X); % m: # of features (wines), n: # of variables
A=(1/(lambda*m))*X; % A_i = 1/(labmda*m)*x_i
K=10;

%% Initialization
dualGap=[];
tOP=[];
w=zeros(n,1);
alpha1=zeros(m/K,1);
alpha2=zeros(m/K,1);
alpha3=zeros(m/K,1);
alpha4=zeros(m/K,1);
alpha5=zeros(m/K,1);

alpha6=zeros(m/K,1);
alpha7=zeros(m/K,1);
alpha8=zeros(m/K,1);
alpha9=zeros(m/K,1);
alpha10=zeros(m/K,1);



%% function value
D=@(alpha) -lambda/2*(A*alpha)'*(A*alpha)-1/m*((alpha'*alpha)*(lambda^2*m^2)/4-y0'*alpha*lambda*m);
P=@(w) (lambda/2)*(w'*w)+1/m*(A'*w-y0)'*(A'*w-y0); % l_i(w^T x_i) = ||A'w-y0||^2_2

%% Standard CoCoA
tOPtot=0;
tCOMMtot=0;
ts=0;
dualGap=[dualGap;P(w)-D([alpha1;alpha2;alpha3;alpha4;alpha5;alpha6;alpha7;alpha8;alpha9;alpha10])];
tOP=[tOP;ts];
for T=1:MaxItrOut
    tOPs=tic;
    %% local worker #1
    kset1=[1:m/K];
    [alphaTri1,wTri1,tAvg1]=localSDCA(w,alpha1,m,lambda,A(:,kset1),y0(kset1,1),H);
    alpha1 = alpha1 + alphaTri1;
    %% local worker #2
    kset2=[m/K+1:2*m/K];
    [alphaTri2,wTri2,tAvg2]=localSDCA(w,alpha2,m,lambda,A(:,kset2),y0(kset2,1),H);
    alpha2 = alpha2 + alphaTri2;
    %% local worker #3
    kset3=[2*m/K+1:3*m/K];
    [alphaTri3,wTri3,tAvg3]=localSDCA(w,alpha3,m,lambda,A(:,kset3),y0(kset3,1),H);
    alpha3 = alpha3 + alphaTri3;
    %% local worker #4
    kset4=[3*round(m/K)+1:4*round(m/K)];
    [alphaTri4,wTri4,tAvg4]=localSDCA(w,alpha4,m,lambda,A(:,kset4),y0(kset4,1),H);
    alpha4 = alpha4 + alphaTri4;
    %% local worker #5
    kset5=[4*round(m/K)+1:5*round(m/K)];
    [alphaTri5,wTri5,tAvg5]=localSDCA(w,alpha5,m,lambda,A(:,kset5),y0(kset5,1),H);
    alpha5 = alpha5 + alphaTri5;
    
    
    %% local worker #6
    kset6=[5*round(m/K)+1:6*round(m/K)];
    [alphaTri6,wTri6,tAvg6]=localSDCA(w,alpha6,m,lambda,A(:,kset6),y0(kset6,1),H);
    alpha6 = alpha6 + alphaTri6;
    %% local worker #7
    kset7=[6*round(m/K)+1:7*round(m/K)];
    [alphaTri7,wTri7,tAvg7]=localSDCA(w,alpha7,m,lambda,A(:,kset7),y0(kset7,1),H);
    alpha7 = alpha7 + alphaTri7;
    %% local worker #8
    kset8=[7*round(m/K)+1:8*round(m/K)];
    [alphaTri8,wTri8,tAvg8]=localSDCA(w,alpha8,m,lambda,A(:,kset8),y0(kset8,1),H);
    alpha8 = alpha8 + alphaTri8;
    %% local worker #9
    kset9=[8*round(m/K)+1:9*round(m/K)];
    [alphaTri9,wTri9,tAvg9]=localSDCA(w,alpha9,m,lambda,A(:,kset9),y0(kset9,1),H);
    alpha9 = alpha9 + alphaTri9;
    %% local worker #10
    kset10=[9*round(m/K)+1:10*round(m/K)];
    [alphaTri10,wTri10,tAvg10]=localSDCA(w,alpha10,m,lambda,A(:,kset10),y0(kset10,1),H);
    alpha10 = alpha10 + alphaTri10;
    
    
    tOPtot=tOPtot+toc(tOPs)/K;
    
    
    %% center updating
    tCOMM_L2C=tic;
    % delay between worker and center
    tAvg_local=(tAvg1+tAvg2+tAvg3+tAvg4+tAvg5+tAvg6+tAvg7+tAvg8+tAvg9+tAvg10)/K;
    pause(weight_Cen_Sub*tAvg_local); % communication delay severity compared to local processing time
    w=w+(wTri1+wTri2+wTri3+wTri4+wTri5+wTri6+wTri7+wTri8+wTri9+wTri10)/K;
    
    
    alpha = [alpha1;alpha2;alpha3;alpha4;alpha5;alpha6;alpha7;alpha8;alpha9;alpha10]; % for duality gap display purpose
    dualGap=[dualGap;P(w)-D(alpha)];
    
    tCOMMtot=tCOMMtot+toc(tCOMM_L2C);
    ts=tCOMMtot+tOPtot;
    tOP=[tOP;ts];
    
    %fprintf('Outer Itr: %5d \t duality gap: %f\t time: %f \n',T,dualGap(end,1),tOP(end,1));
    if dualGap(end,1) < 10^-6
        break;
    end
    
end
%save('stn_matlab.mat');
end

