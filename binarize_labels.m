function y_binary = binarize_labels(y, target)
    y_binary = ones(size(y));
    y_binary(y ~= target) = -1;
end
