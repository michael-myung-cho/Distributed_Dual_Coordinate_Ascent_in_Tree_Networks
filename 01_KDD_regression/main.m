%% Generalized Distributed Dual Coordinate Ascent algorthm Simulation Against (Standard) CoCoA
% Linear regression
% Dataset: KDD cup 98' donation regression
%
% general_CoCoA: Distributed Dual Coordinate Ascent in Tree-network [1]
% standard_CoCoA: Distributed Dual Coordinate Ascent in Star-network [2]
% 
% Myung (Michael) Cho
% Email: mxc6077@psu.edu
% Aug. 03, 2021
%
% [1] M. Cho, L. Lai, and W. Xu, 
% "Distributed dual coordinate ascent in general tree networks and communication network effect on synchronous machine learning,”
% IEEE Journal on Selected Areas in Communication (JSAC), 2021
% [2] M. Jaggi, V. Smith, M. Takác, J. Terhorst, S. Krishnan, T. Hofmann, and M. I. Jordan, 
% "Communication-efficient distributed dual coordinate ascent,” 
% in Advances in Neural Information Processing Systems, 2014, pp. 3068–3076.
%----------------
close all
clear
clc



%% Loading Dataset 
addpath('../00_Dataset/KDD');
load('KddData_normalized.mat'); %KddData: 95410x406 last column is label info.



%% Simulation for comparison
MaxTri=1;
sumItr_Gen=0;
sumItr_Stn=0;
for iTri=1:MaxTri
    for ii=0:2:5
        weight_Cen_Sub=10^ii;   % Communication delay Severity level (weight) between the central node and its direct child-nodes
        weight_wor_sub=0;       % Assumed that communication delay can be ignored between local workers and sub-central node 
        MaxItrIn=2;             % Max. number of iteration for inner loop
        MaxItrOut=100;          % Max. number of iteration for outer loop
        H=1000;                 % Number of local iteration
        
        %% Distributed Dual Coordinate Ascent in Tree-network (General CoCoA)
        fprintf('Delay severity r:%d \n',weight_Cen_Sub);
        [dualGap_Gen,tOP_Gen,Itr_Gen]=general_CoCoA(KddData(:,:), MaxItrOut, MaxItrIn, weight_wor_sub, weight_Cen_Sub,H);
        fprintf('Tree CoCoA time: %f (Itr: %d) \n', tOP_Gen(end), Itr_Gen);
        
        %% Distributed Dual Coordinate Ascent in Star-network (Standard CoCoA)
        [dualGap_Stn,tOP_Stn,Itr_Stn]=standard_CoCoA(KddData(:,:), MaxItrOut, weight_wor_sub, weight_Cen_Sub,H);
        fprintf('Star CoCoA time: %f (Itr: %d)\n\n', tOP_Stn(end), Itr_Stn);
        
        sumItr_Gen=sumItr_Gen+Itr_Gen;
        sumItr_Stn=sumItr_Stn+Itr_Stn;
        
        %% display
        hold off
        figure; box on; grid on;
        set(gca,'FontSize',45);
        set(gcf,'color','w');
        set(gca, 'YScale', 'log')
        hold on
        plot(tOP_Gen,dualGap_Gen,'-+r','LineWidth',6,'MarkerSize',15);
        plot(tOP_Stn,dualGap_Stn,'-sb','LineWidth',6,'MarkerSize',15);
        legend('Tree network','Star network');
        xlabel('Time (Seconds)');
        ylabel('Duality gap (log scale)'); 
    end
end
sumItr_Gen
sumItr_Stn
