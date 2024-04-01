function[y] = sam(data) % Function that performs the SAM of a data input and returns the processed data

y = zeros(size(data));
y(:, 2:end-2) = data(:, 1:end-3) .* data(:, 2:end-2) .* data(:, 3:end-1) .* data(:, 4:end);

end