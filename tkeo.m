function[y] = tkeo(x)  % Function to return the Teager Kaiser Energy Operator of an input signal.

x = x(:); % Vectorize.

xp = [x(2:end); x(end)];
xn = [x(1); x(1:end-1)];
y = x.^2 -xp.*xn;

end

