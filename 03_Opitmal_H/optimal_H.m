%% Simulation for optimal local iteration (Fig. 8(a))
% Myung Cho, Lifeng Lai, and Weiyu Xu, 
% "Distributed dual coordinate ascent in general tree networks and communication network effect on synchronous machine learning,”
% IEEE Journal on Selected Areas in Communication (JSAC), 2021
%-------------
clear all;
clc;
clf;

delta=1/300;
C=0.5;
K=3;
tTotal=1;
tLP=4*10^(-5);
tCP=3*10^(-5);


H=0:1:2000;

f=@(H,r) (1-(1-(1-delta).^H).*(C/K)).^((tTotal/tLP)./(H+r));

Buf=[f(H,1);f(H,10);f(H,10^2);f(H,10^3);f(H,10^4);f(H,10^5)];

for ii=1:6
    [M,I]=min(Buf(ii,:));
    I
end

set(gcf,'color','w');
set(gca,'FontSize',45)
set(gca, 'YScale', 'linear')
box on
grid on
hold on

plot(H,f(H,1),'-b','LineWidth',6,'MarkerSize',15);
plot(H,f(H,10),':r','LineWidth',6,'MarkerSize',15);
plot(H,f(H,10^2),'-.g','LineWidth',6,'MarkerSize',15);
plot(H,f(H,10^3),'-.b','LineWidth',6,'MarkerSize',15);
plot(H,f(H,10^4),'-c','LineWidth',6,'MarkerSize',15);
plot(H,f(H,10^5),'--m','LineWidth',6,'MarkerSize',15);

legend('r=1','r=10','r=10^2','r=10^3','r=10^4','r=10^5');
xlabel('Convergence bound');
ylabel('Number of local iterations, H');

    

    




