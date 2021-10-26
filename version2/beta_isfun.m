function beta = beta_isfun(p,t_q,t)
    % Define parameters
    beta_is = p(1);
    eta_is = p(2);
    
    % Create a t_q vector
    t_q = t_q * ones(1, length(t));
    
    % Calculate beta_is at time t
    beta = beta_is * (eta_is + (1 - eta_is) * (1 - tanh(2 * (t -  t_q))) / 2);
end