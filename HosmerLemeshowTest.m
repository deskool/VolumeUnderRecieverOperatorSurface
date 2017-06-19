function p=HosmerLemeshowTest(Yest,Ytrue)

% This function implements the HosmerLemeshow goodness-of-fit test. When
% the p-value is larger than a given significance level (e.g. 0.05), the
% model is calibrated.
%
% Inputs:
% Yest - 1D vector that contains model outputs. The values should be between 0 and 1.
% Ytrue - 1D vector of binary target values. The values should be either 0 or 1.
%
% Outputs:
% p - p-value
%
% Written by Joon Lee, August 2010.
% Updated By Mohammad Ghassemi, 2012


[Yest_sorted,idx]=sort(Yest);
Ytrue_sorted=Ytrue(idx);

decileSize=round(length(Yest)/10);
HLstat=0;
O=zeros(10,1);
E=zeros(10,1);

% first 9 bins
for i=1:9
    first=(i-1)*decileSize+1;
    last=i*decileSize;
    O(i)=sum(Ytrue_sorted(first:last));
    E(i)=sum(Yest_sorted(first:last));
    HLstat=HLstat+(O(i)-E(i))^2/E(i)/(1-E(i)/decileSize);
end

% 10th bin (possibly with a different size than the other bins)
first=9*decileSize+1;
O(10)=sum(Ytrue_sorted(first:end));
E(10)=sum(Yest_sorted(first:end));
n=length(Ytrue_sorted(first:end));
HLstat=HLstat+(O(10)-E(10))^2/E(10)/(1-E(10)/n);

p=1-cdf('chi2',HLstat,8);
