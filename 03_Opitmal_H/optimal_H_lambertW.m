%% Simulation for optimal local iteration (Fig. 12)
% Myung Cho, Lifeng Lai, and Weiyu Xu, 
% "Distributed dual coordinate ascent in general tree networks and communication network effect on synchronous machine learning,”
% IEEE Journal on Selected Areas in Communication (JSAC), 2021
%-------------
clear all;
clc;
clf;


%% r varies
delta=1/300;
C=0.5;
K=3;
r=1:10:10^5;

opt_H = 1/log(1-delta).*lambertw(-1, ((1-delta).^r).*log((K-C)/K)) - r;

% Figure parameters
figure; box on; grid on;
set(gca,'FontSize',45);
set(gcf,'color','w');

plot(r,opt_H,'-','LineWidth',6,'MarkerSize',20);

xlabel('r','FontSize',45); 
ylabel('Optimal number of local iterations, H','FontSize',45);
    

    
%% C varies
delta=1/300;
C=0.1:0.1:1;
K=3;
r=100;

opt_H = 1/log(1-delta).*lambertw(-1, ((1-delta).^r).*log((K-C)./K)) - r;

%% Figure parameters
figure; box on; grid on;
set(gca,'FontSize',45);
set(gcf,'color','w');

plot(C,opt_H,'-','LineWidth',6,'MarkerSize',20);

xlabel('C','FontSize',45); 
ylabel('Optimal number of local iterations, H','FontSize',45);

%% K varies
delta=1/300;
C=0.5;
K=2:1:1000;
r=100;

opt_H = 1/log(1-delta).*lambertw(-1, ((1-delta).^r).*log((K-C)./K)) - r;

%% Figure parameters
figure; box on; grid on;
set(gca,'FontSize',45);
set(gcf,'color','w');

plot(K,opt_H,'-','LineWidth',6,'MarkerSize',20);

xlabel('K','FontSize',45); 
ylabel('Optimal number of local iterations, H','FontSize',45);
    
%% delta varies
delta=10^-3:10^-5:0.1;
C=0.5;
K=3;
r=100;

opt_H = 1./log(1-delta).*lambertw(-1, ((1-delta).^r).*log((K-C)./K)) - r;

%% Figure parameters
figure; box on; grid on;
set(gca,'FontSize',45);
set(gcf,'color','w');

plot(delta,opt_H,'-','LineWidth',6,'MarkerSize',20);

xlabel('\delta','FontSize',45); 
ylabel('Optimal number of local iterations, H','FontSize',45);
    

