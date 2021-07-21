function dydt = odefcn(t,y,p)
  %ODEFCN   SIR system of ode's.
  %   dydt = odefcn(t,y,p) where
  %   y(1) = S(t), y(2) = I(t),
  %   p(1) = beta, p(2) = gamma
  
  %initialize dydt array
  dydt = zeros(2,1);
  
  %dydt(1) = dSdt
  dydt(1) = - p(1) * y(1) * y(2);
  %dydt(2) = dIdt
  dydt(2) = p(1) * y(1) * y(2) - p(2) * y(2);
end