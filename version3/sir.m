function dydt = sir(t,y,p,tq,n)
% SIR   SIR model function.

    % Derivatives with respect to time
    s = y(1);
    a = y(2);
    i = y(3);
    r = y(4);
    
    % System parameters
    % Optimized parameters (p vector)
    omega0betaA = p(1);
    omega0betaI = p(2);
    eta = p(3);
    gammaA = p(4);
    gammaI = p(5);
    delta = p(6);
    
    % Calculate time dependent coefficients
    coeffA = betafun([omega0betaA,eta],tq,t);
    coeffI = betafun([omega0betaI,eta],tq,t);

    % Define system
    dydt = [
        - (coeffA .* a + coeffI .* i) .* s; % s_t
        (coeffA .* a + coeffI .* i) .* s - (gammaA - delta) * a; % a_t
        - gammaI * i + delta * a; % i_t
        gammaA * a + gammaI * i % r_t
        ];
end