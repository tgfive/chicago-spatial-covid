function obj = objfun(trange,Cobs,p,tq,y0,n)
% OBJFUN   Compute objective function.
%   obj = objfun(trange,Yobs,p,tq,y0) compute norm2(Ynum - Yobs)
%   where Ynum is the solution to sir(t,y,p1) over trange with
%   initial conditions y0 and p1 = [p,tq].

    % Compute the solution vector
    [~,y] = computemodel(p,tq,trange,y0);
    
    % Convert to system vectors
    s = y(:,1);
    a = y(:,2);
    i = y(:,3);
    r = y(:,4);
    
    % Define model cases
    Cnum = i;
    
    % Compute the objective function
    %obj = sum(vecnorm(Cnum - Cobs' / n));
    obj = sum((Cnum - Cobs' / n).^2);
    %disp(obj)
end