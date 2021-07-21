function obj = myObj(p)
  
  %predicted values
  y0 = [100, 5];  %initial values [S_0, I_0]
  [t,y] = ode45(@(t,y)odefc(t,x,p), time, y0);
  
  casesNum = y(2);
  removedNum = y0(1)*ones(1,length(casesNum)) - y(1) - y(2);
  
  %measured values
  casesObs = cases;
  removedObs = removed;
  
  %compute the Euclidean norm
  obj = norm(casesNum - casesObs) + norm(removedNum - removedObs);
end