function obj = objfun(trange,Cobs,Dobs,p,q,pops)
% OBJFUN   Compute objective function.
%   obj = objfun(trange,Yobs,p,q,y0) compute norm2(Ynum - Yobs)
%   where Ynum is the solution to sir(t,y,p1) over trange with
%   initial conditions y0 and p1 = [p,q].

    % Compute the solution vector
    [~,y] = computemodel(p,q,trange,pops);
    
    % Convert to system vectors
    i = y(:,5);
    h = y(:,6);
    r = y(:,7);
    d = y(:,8);
    
    % Define model cases and deaths
    Cnum = i + h + r + d;
    Dnum = d;
    
    % Compute the objective function
    obj = sum(vecnorm(log(Cnum) - log(Cobs)) + vecnorm(log(Dnum) - log(Dobs)));
end