function [] = sim(p0)
  
  %predicted values
  [t,y] = ode45(@(t,y)odefcn(t,y,p0), [0 498], [8413809,431]);
  
  %actual values
  plot(t,y)
  %plot(t,removed)