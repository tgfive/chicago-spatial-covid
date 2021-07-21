function dydt = odefcn(t,y,b,g)
  %sir system of ode's
  dydt = zeros(2,1);
  dydt(1) = - b * y(1) * y(2);
  dydt(2) = b * y(1) * y(2) - g * y(2);