function [ costheta ] = norminnerprod( x,y )
% Function to calculate the normalised inner product between two vectors
% (i.e. signals). This returns a value cos(theta) which lies between -1 and
% 1. If the value is 0 it means two signals are perfectly orthogonal to
% each other (i.e completely different).

costheta=sum(x.*y)/sqrt(sum(x.^2)*sum(y.^2));

end

