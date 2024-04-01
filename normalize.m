function [ norm_x ] = normalize( x )
% Function to normalize a input vector x from 0-1
   norm_x=(x-min(x))/(max(x)-min(x));
   
end

