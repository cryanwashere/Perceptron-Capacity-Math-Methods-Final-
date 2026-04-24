N = 100;
alpha_values = 0.1:0.01:2;

% preallocate k_max_values
k_max_values = zeros(1,length(alpha_values));

for idx = 1:length(alpha_values)

    % get the number of patterns from alpha
    alpha = alpha_values(idx);
    m = round (alpha * N); 

    % generate a dichotomy
    [X,y] = generate_dichotomy(N,m);
    
    % generate our A matrix in the same way as before
    A = -(X .* y);
    b = -1 * ones(m,1);
    
    % In this section, we are instead trying to optimize J_prime = J/k. 
    H = 2 * eye(N);
    f = zeros(N,1);
    
    
    J_prime = quadprog(H, f, A, b);
    
    % we can use our derived formula for k:
    k = sqrt(N / dot(J_prime, J_prime));
    
    % Store the computed k value for the current alpha
    k_max_values(idx) = k; 
end

figure;
plot(alpha_values, k_max_values, 'b-o', 'MarkerSize', 4);
xlabel('\alpha = m/N');
ylabel('k_{max}');
title('k_{max} as a function of \alpha');
grid on;