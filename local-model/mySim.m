function [] = sim(p0)
  
  %load data
  [time, cases, removed] = loadData();
  
  %initial conditions
  y0 = [8413809,431]
  
  %predicted values
  [t,y] = ode45(@(t,y)odefcn(t,y,p0), time, y0);
  
  disp(num2str(length(t)));
  
  % Calculate total cases and total removed
  casesNum = y(2);
  removedNum = y0(1)*ones(1,length(casesNum)) - y(1) - y(2);
  
  %plot values
  hold on
  plot(t,casesNum,t,removedNum)
  hold off
end