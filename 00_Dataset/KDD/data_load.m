
clear
clc


A = readtable('cup98LRN_num.csv');
A=A{:,:};
A(find(isnan(A)==1))=0;


A(:,end-1)=[];  % TargetC in KDD is donation amount, we get rid of TargetB
A(end-1:end,:)=[];

%% normalize
KddData=[];
for ii=1:size(A,2)
    if ii==size(A,2)
        %KddData=[KddData,KddData(:,ii)]; % label y info.
        KddData=[KddData,A(:,ii)/norm(A(:,ii))]; % normalize for y info as well
    else
        KddData=[KddData,A(:,ii)/norm(A(:,ii))]; % normalize for machine learning performance
    end
end

for ii=1:size(KddData,1)
    KddData(ii,1:end-1) = KddData(ii,1:end-1)/norm(KddData(ii,1:end-1)); % normalize for || x_i || <= 1
end

save('KddData_normalized.mat');