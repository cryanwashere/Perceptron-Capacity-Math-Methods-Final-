% Calculate the probablity of a random m point dichotomy of N dimensional
% vectors being storable by a perceptron
function p = cover_P(m,N)
    C = 0;
    for k = 0:(N-1)
        if k <= m-1
            C = C + nchoosek(m - 1, k);
        end
    end
    C = 2*C;
    % C is the number of linearly seperable (solvable) m point dichotomies
    % of dimension N 
    
    % there are a total of 2^m possible m point dichotomies
    p = C / (2^m);
end