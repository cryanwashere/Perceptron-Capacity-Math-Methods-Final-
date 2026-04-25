N = 100;
alpha_values = 0.1:0.01:2;
n_trials = 10;
k_max_values = zeros(1, length(alpha_values));

options = optimoptions('quadprog', 'Display', 'none');

for idx = 1:length(alpha_values)
    alpha = alpha_values(idx);
    m = round(alpha * N);

    k_sum = 0;
    valid_trials = 0;

    for trial = 1:n_trials
        [X, y] = generate_dichotomy(N, m);
        A = -(X .* y);
        b = -1 * ones(m, 1);
        H = 2 * eye(N);
        f = zeros(N, 1);

        J_prime = quadprog(H, f, A, b, [], [], [], [], [], options);

        % only include solved trials
        if ~isempty(J_prime)
            k = sqrt(N / dot(J_prime, J_prime));
            k_sum = k_sum + k;
            valid_trials = valid_trials + 1;
        end
    end

    % average over valid trials only
    if valid_trials > 0
        k_max_values(idx) = k_sum / valid_trials;
    else
        k_max_values(idx) = NaN;
    end

    fprintf('alpha = %.2f  valid trials: %d/%d\n', alpha, valid_trials, n_trials);
end

% compute theoretical curve
kappa_values = linspace(0, 32, 1000);
alpha_theory = zeros(1, length(kappa_values));

for i = 1:length(kappa_values)
    kappa = kappa_values(i);
    u = kappa / sqrt(N);
    alpha_theory(i) = 1 / ( ...
        0.5 * (u^2 + 1) * (1 + erf(u / sqrt(2))) + ...
        exp(-u^2 / 2) * u / sqrt(2 * pi) ...
    );
end

figure;
plot(alpha_values, k_max_values, 'b-o', 'MarkerSize', 4, 'DisplayName', 'Empirical');
hold on;
plot(alpha_theory, kappa_values, 'r-', 'LineWidth', 1.5, 'DisplayName', 'Theoretical');
xlabel('\alpha = m/N');
ylabel('k_{max}');
title('k_{max} as a function of \alpha');
legend('Location', 'northeast');
grid on;