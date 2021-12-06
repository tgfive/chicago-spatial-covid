function [T,y] = computemodel(p,tq,trange,y0)
    % Compute the solution vector
    [T,y] = ode45(@(t,y)sir(t,y,p,tq),trange,y0);
end