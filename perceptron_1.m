
N = 100;
trials = 30

m_values = 1:3*N;
P = zeros(1,length(m_values));
P_cover = zeros(1, length(m_values));

for m = m_values

    % for this value of m, estimate the probability that a perceptron can
    % store a random dichotomy
    satisfied = 0;
    for test = 1:trials
        [X,y] = generate_dichotomy(N, m);
        
        % create our A matrix to turn the problem into a set of linear
        % equations
        A = -(X .* y);
        
        f = zeros(N, 1);
        b = -1 * ones(m,1);
       
        J = linprog(f, A, b);
    
        if ~isempty(J)
            satisfied = satisfied + 1;
        end
    end
    P(m) = satisfied / trials;
    P_cover(m) = cover_P(m, N);
end

figure;
plot(m_values / N, P, 'b-o', 'MarkerSize',4);
hold on; 
plot(m_values / N, P_cover, 'r--', 'LineWidth',1.5);
ylim([0,1])
xline(2, 'k--');
xlabel("\alpha = m/N");
ylabel("P_m");
title('Fraction of solvable dichotomies vs m/M');
legend('Empirical', 'Cover formula', '\alpha = 2', 'Location', 'southwest');
grid on;