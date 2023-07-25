%% Simulation for optimal local iteration (Fig. 8(b))
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


H=0:1:10000;
f=@(H,r) (1-(1-(1-delta).^H).*(C/K)).^((tTotal/tLP)./(H+r));
H_star =@(r) 1/log(1-delta)*lambertw(-1,log((K-C)/K)*(1-delta)^r)-r;


IBuf=[];
H_star_Buf=[];
for ii=0:5
    [M,I]=min(f(H,10^ii));
    IBuf=[IBuf;I];
    H_star_Buf=[H_star_Buf;H_star(10^ii)];
end


%% Display
set(gcf,'color','w');
set(gca,'FontSize',45)
set(gca, 'YScale', 'linear')
box on
grid on
hold on
xlabel('r');
ylabel('Optimal number of local iterations, H');

plot([0:5],IBuf,'-o','LineWidth',6,'MarkerSize',15)
plot([0:5],H_star_Buf,':x','LineWidth',6,'MarkerSize',15);
    

    




