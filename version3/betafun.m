function b = betafun(p,t_q,t)
    % Define parameters
    beta = p(1);
    eta = p(2);

    % Create a t_q vector
    t_q = t_q * ones(length(t),1);

    % Calculate beta at time t
    b = 1 - tanh(2 * (t - t_q));
    b = b / 2;
    b = (1 - eta) * b;
    b = eta + b;
    b = beta * b;
end