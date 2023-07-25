function [alphaTriK,wTri,tavg] = localSDCA(w,alpha,m,lambda,A,y,MaxItr)
%LOCALSDCA: MaxItr(wei*tdelay)

nk=max(size(y));
nblk=1; %block coordinate
alphaTriK=zeros(nk,1);
%MaxItr=@(tdelay) wei*tdelay;
%MaxItr=100;
te1=0;
for h=1:MaxItr
    ts1=tic;
    ii=sort(randperm(nk,nblk));
    x=A(:,ii)*lambda*m; %A(:,ii)=x_ii/(lambda*m)
    alphaTri=-inv(x'*x/(lambda*m)+lambda^2*m^2/2)*(x'*w + lambda^2*m^2/2*alpha(ii,1)-y(ii,1)*lambda*m);
    alpha(ii,1)=alpha(ii,1)+alphaTri;
    alphaTriK(ii,1)=alphaTriK(ii,1)+alphaTri;
    wTri=x*alphaTri/(lambda*m);
    w=w+wTri;
    if h <= 100
       te1=te1+toc(ts1);
    end
%     if norm(alphaTri,2) < 10^-6
%         break;
%     end
end

wTri=A*alphaTriK;
tavg=te1/100;

end

