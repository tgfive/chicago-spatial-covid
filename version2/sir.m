function dydt = sir(t,y,p,q)
% SIR   SIR model function.

    % Derivatives with respect to time
    s = y(1);
    e = y(2);
    a = y(3);
    i = y(5);
    h = y(6);
    
    % System parameters
    % Optimized parameters (p vector)
    sigma_a = p(1);
    sigma_i = p(2);
    m_ar = p(3);
    m = p(4);
    gamma = p(5);
    omega = p(6);
    chi = p(7);
    psi = p(8);
    beta_sa = p(9);
    beta_si = p(10);
    eta_sa = p(11);
    eta_si = p(12);
    
    % Fixed parameters (q vector)
    mu = q(1);
    t_q = q(2);
    
    % Calculate time dependent betas
    beta_si_t = betafun([beta_si,eta_si],t_q,t);
    beta_sa_t = betafun([beta_sa,eta_sa],t_q,t);

    % Define system
    dydt = [
        -beta_sa_t .* (s * a) - beta_si_t .* (s * i) - mu * s; % S_t
        beta_sa_t .* (s * a) + beta_si_t .* (s * i) - (sigma_a + sigma_i) * e; % E_t
        sigma_a * e - m_ar * a; % A_t
        m_ar * a; % AR_t
        sigma_i * e - m * i; % I_t
        gamma * m * i - (1 - omega) * chi * h - omega * psi * h; % H_t
        (1 - gamma) * m * i + (1 - omega) * chi * h; % R_t
        omega * psi * h; % D_t
        ];
end