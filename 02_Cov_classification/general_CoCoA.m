function [dualGap,tOP,T]= general_CoCoA(Dataset, MaxItrOut, MaxItrIn, weight_Cen_Sub,H)
%% Synchronous distributed SDCA for a tree network
% 4 local workers (K=4), 2 sub-centers, and 1 center network model
% number of local iterations = tdelay*weight
% MaxItrOut: # of communication between center and subcenter
% MaxItrIn: # of communications between local workers and subcenter
%---------------------

lambda=1;
y0=Dataset(:,end); % cov label
X=Dataset(:,1:end-1)'; % cov attributions
[n,m]=size(X); % m: # of instances, n: # of attributions
A=(1/(lambda*m))*X; % A_i = 1/(labmda*m)*y_i*x_i
for ii=1:m
   A(:,ii)=y0(ii)*A(:,ii); 
end
K=8;

%% Initialization
dualGap=[];
tOP=[];
w=zeros(n,1);

w_sub1=zeros(n,1);
w_sub2=zeros(n,1);
w_sub1_pre = zeros(n,1);
w_sub2_pre = zeros(n,1);

alpha11=zeros(m/K,1);
alpha12=zeros(m/K,1);
alpha13=zeros(m/K,1);
alpha14=zeros(m/K,1);

alpha21=zeros(m/K,1);
alpha22=zeros(m/K,1);
alpha23=zeros(m/K,1);
alpha24=zeros(m/K,1);

%% function value
D=@(alpha) sum(alpha)-1/(2*lambda)*norm(A*alpha)^2;
P=@(w) (lambda/2)*(w'*w)+1/m*sum(max(0,1-(A'*w))); % l_i(w^T x_i) = max(0,1 - y_i*(w^T*x_i - b))

%% general CoCoA
tOPtot=0;
tCOMMtot=0;
tCOMM_L2SubC_Tot=0;
for T=1:MaxItrOut
    for L=1:MaxItrIn
        tOPs=tic;
        %% Cluster 1
        %% local worker #1
        kset11=[1:round(m/K)];
        [alphaTri11,wTri11,tAvg11]=local_SVM(w_sub1,alpha11,m,lambda,A(:,kset11),y0(kset11,1),H);
        alpha11 = alpha11 + alphaTri11;        
        %% local worker #2
        kset12=[round(m/K)+1:2*round(m/K)];
        [alphaTri12,wTri12,tAvg12]=local_SVM(w_sub1,alpha12,m,lambda,A(:,kset12),y0(kset12,1),H);
        alpha12 = alpha12 + alphaTri12;           
        %% local worker #3
        kset13=[2*round(m/K)+1:3*round(m/K)];
        [alphaTri13,wTri13,tAvg13]=local_SVM(w_sub1,alpha13,m,lambda,A(:,kset13),y0(kset13,1),H);
        alpha13 = alpha13 + alphaTri13;            
        %% local worker #4
        kset14=[3*round(m/K)+1:4*round(m/K)];
        [alphaTri14,wTri14,tAvg14]=local_SVM(w_sub1,alpha14,m,lambda,A(:,kset14),y0(kset14,1),H);
        alpha14 = alpha14 + alphaTri14;         
        
        %% Cluster 2
        %% local worker #1
        kset21=[4*round(m/K)+1:5*round(m/K)];
        [alphaTri21,wTri21,tAvg21]=local_SVM(w_sub2,alpha21,m,lambda,A(:,kset21),y0(kset21,1),H);
        alpha21 = alpha21 + alphaTri21;        
        %% local worker #2
        kset22=[5*round(m/K)+1:6*round(m/K)];
        [alphaTri22,wTri22,tAvg22]=local_SVM(w_sub2,alpha22,m,lambda,A(:,kset22),y0(kset22,1),H);
        alpha22 = alpha22 + alphaTri22;           
        %% local worker #3
        kset23=[6*round(m/K)+1:7*round(m/K)];
        [alphaTri23,wTri23,tAvg23]=local_SVM(w_sub2,alpha23,m,lambda,A(:,kset23),y0(kset23,1),H);
        alpha23 = alpha23 + alphaTri23;            
        %% local worker #4
        kset24=[7*round(m/K)+1:m];
        [alphaTri24,wTri24,tAvg24]=local_SVM(w_sub2,alpha24,m,lambda,A(:,kset24),y0(kset24,1),H);
        alpha24 = alpha24 + alphaTri24;         
        
        tOPtot=tOPtot+toc(tOPs)/K;
        tAvg_local=(tAvg11+tAvg12+tAvg13+tAvg14+tAvg21+tAvg22+tAvg23+tAvg24)/K;
        
        %% delay between worker and subcenter
        tCOMM_L2SubC=tic;
        % pause(weight_wor_sub*tAvg_local);  

        %% subcenter updating
        % subcenter 1 updating
        w_sub1_tri=(wTri11+wTri12+wTri13+wTri14)/4;
        w_sub1=w_sub1+w_sub1_tri;
        
        % subcenter 2 updating        
        w_sub2_tri=(wTri21+wTri22+wTri23+wTri24)/4;
        w_sub2=w_sub2+w_sub2_tri;
                
        tCOMM_L2SubC_Tot=tCOMM_L2SubC_Tot+toc(tCOMM_L2SubC);
    end
    
    %% center updating
    tCOMM_SubC2C=tic;
    % delay between center and sub-center
    pause(weight_Cen_Sub*tAvg_local); % % communication delay severity compared to local processing time
    w_sub1_tri_all = w_sub1 - w_sub1_pre;
    w_sub2_tri_all = w_sub2 - w_sub2_pre;

    w_sub1_pre = w_sub1;
    w_sub2_pre = w_sub2;    
    
    w=w+(w_sub1_tri_all+w_sub2_tri_all)/2;
    
    alpha = [alpha11;alpha12;alpha13;alpha14;alpha21;alpha22;alpha23;alpha24]; % for duality gap check purpose
    dualGap=[dualGap;P(w)-D(alpha)];

    tCOMMtot=tCOMMtot+toc(tCOMM_SubC2C); 
    ts= tCOMMtot+tOPtot+tCOMM_L2SubC_Tot;
    tOP=[tOP;ts];
    
    %fprintf('Outer Itr:%5d \t duality gap: %f\t time: %f \n',T,dualGap(end,1),tOP(end,1));
    if dualGap(end,1) < 10^-7
        break;
    end
    
    %% distribute to subcenter
    w_sub1=w;
    w_sub2=w;   
end
%save('gen_matlab.mat');

end


