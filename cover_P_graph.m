N_values = 10:10:100;
m_max = 3 * max(N_values);
m_values = 1:m_max;

figure;
hold on;

for idx = 1:length(N_values)
    N = N_values(idx);
    
    % color interpolation: red (low N) to blue (high N)
    t = (idx - 1) / (length(N_values) - 1);   % goes from 0 to 1
    color = [1 - t, 0, t];                     % [R, G, B]
    
    % compute P_cover for this N across all m values
    P_cover = zeros(1, m_max);
    for m = m_values
        P_cover(m) = cover_P(m, N);
    end
    
    plot(m_values / N, P_cover, 'Color', color, 'LineWidth', 1.5, ...
        'DisplayName', sprintf('N = %d', N));
end

xline(2, 'k--', 'LineWidth', 1.5, 'DisplayName', '\alpha = 2');
xlabel('\alpha = m/N');
ylabel('P_{cover}');
title('Cover formula across increasing N');
legend('Location', 'southwest');
grid on;