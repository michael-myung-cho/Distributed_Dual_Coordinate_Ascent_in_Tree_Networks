
function Theta0 = thetapApprox(pp, K, C, T, K0, C0, T0, Thetap)
Theta0 = 0;


TempSum=0;
for rr=1:pp-1
    for ii=0:rr
        if ii==0
            TempProd=((K0 - C0)/K0)^T0;
        else
            TempProd=TempProd*((K(ii) - C(ii))/K(ii))^T(ii);
        end
    end
    for jj=0:rr-1
        if jj==0
            TempProd1=(C0*T0/(K0-C0));
        else
            TempProd1=TempProd1*(C(jj)*T(jj))/(K(jj)-C(jj));
        end
    end
    TempSum=TempSum+TempProd*TempProd1;
end
TempProd2=1;
for ii=0:pp-1
    if ii==0
        TempProd2=TempProd2*((K0 - C0)/K0)^T0*(C0*T0/(K0-C0));
    else
        TempProd2=TempProd2*(((K(ii) - C(ii))/K(ii))^T(ii))*(C(ii)*T(ii)/(K(ii)-C(ii)));
    end
end
TempSum=TempSum+TempProd2*Thetap;
Theta0=TempSum+((K0-C0)/K0)^T0

end