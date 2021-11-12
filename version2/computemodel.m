function [T,y] = computemodel(p,q,trange,pops)
    % Separate the parameters from the population fractions
    p1 = p(1:end-2); % Parameters
    e0i0 = p(end-1); % Exposed/Infected
    a0i0 = p(end); % Asymptotic/Infected

    % Calculate the initial values
    n = pops(1);
    i0 = pops(2);
    h0 = pops(3);
    d0 = pops(4);
    e0 = e0i0 * i0;
    a0 = a0i0 * i0;
    ar0 = 0;
    r0 = 0;
    s0 = n - (e0 + a0 + ar0 + i0 + h0 + r0 + d0);
    
    % Define the initial population vector
    y0 = [s0, e0, a0, ar0, i0, h0, r0];

    % Compute the solution vector
    [T,y] = ode45(@(t,y)sir(t,y,p1,q),trange,y0);
end