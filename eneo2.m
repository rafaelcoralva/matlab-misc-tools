function[y] = eneo2(x) % Function to return the MTEO (with k=2) of an input signal x

xp = [x(3:end) x(end-1) x(end)];
xn = [x(1) x(2) x(1:end-2)];
y = x.^2 -xp.*xn;

end