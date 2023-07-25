function [alphaTriK,wTri,tavg] = local_SVM(w,alpha,m,lambda,A,y,MaxItr)
%LOCALSDCA: MaxItr(wei*tdelay)

nk=max(size(y));
nblk=1; %block coordinate
alphaTriK=zeros(nk,1);
%MaxItr=@(tdelay) wei*tdelay;
%MaxItr=100;
te1=0;
for h=1:MaxItr
    ts1=tic;
    ii=randperm(nk,nblk);
    x=A(:,ii)*lambda*m; %A(:,i)=y_i * x_i/(lambda*m)
    alphaTri=(lambda^4*m^2)/norm(x)^2*(1 - x'*w/(lambda*m));
    
    if (alpha(ii,1)+alphaTri) > 1/m
        alphaTri = 1/m - alpha(ii,1);
    end
    if (alpha(ii,1)+alphaTri) < 0
        alphaTri = -alpha(ii,1); 
    end
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

