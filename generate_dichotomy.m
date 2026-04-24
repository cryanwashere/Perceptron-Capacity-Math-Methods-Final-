% Generate the input and output associations for a perceptron to learn
function [X,y] = generate_dichotomy(N, m)
    % Initialize the random input vectors as an Nxm matrix
    % each column is one input pattern, and the entries are +1 or -1
    X = 2 * randi([0,1], m, N) - 1;
    % the labels are a 1xm vector
    y = 2 * randi([0,1], m, 1) - 1;
end