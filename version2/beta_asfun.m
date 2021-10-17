function beta = beta_asfun(p,t_q,t)
    % Define parameters
    beta_as = p(1);
    eta_as = p(2);
    
    % Create a t_q vector
    t_q = t_q * ones(1, length(t));
    
    % Calculate beta_is at time t
    beta = beta_as * (eta_as + (1 - eta_as) * (1 - tanh(2 * (t -  t_q))) / 2);
end