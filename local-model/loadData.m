function [time, cases, removed] = loadData()
  %import the time series csv file
  series = load('time_series.csv');

  %redefine variables for ease
  cases = series(:,2)';
  removed = series(:,3)';

  %create even timesteps
  time = linspace(0,1,length(cases));
end