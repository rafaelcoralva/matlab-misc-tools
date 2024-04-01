function [x] = force_col(x)

%% Rafael Cordero - June 2020

% Force a 1D input x into a column vector

if size(x,2)>1
    x=x(:);
end


end

