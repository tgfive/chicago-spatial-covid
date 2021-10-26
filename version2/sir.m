function dydt = sir(t,y,p1)
% SIR   SIR model function.

    % Derivatives with respect to time
    s = y(1);
    e = y(2);
    a = y(3);
    i = y(5);
    h = y(6);
    
    % System parameters
    % Optimized parameters (p vector)
    sigma_a = p1(1);
    sigma_i = p1(2);
    m_ar = p1(3);
    m = p1(4);
    gamma = p1(5);
    omega = p1(6);
    chi = p1(7);
    psi = p1(8);
    beta_sa = p1(9);
    beta_si = p1(10);
    eta_sa = p1(11);
    eta_si = p1(12);
    % Fixed parameters (q vector)
    mu = p1(13);
    t_q = p1(14);
    
    % Define system
    dydt = [
        -beta_asfun([beta_as,eta_as],t_q,t) .* s * a - beta_
    
    
    
    
    
    