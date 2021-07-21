%clear command window and workspace
clear
clc

%import the time series csv file
series = load('time_series.csv');

%redefine variables for ease
time = series(:,1);
cases = series(:,2);
removed = series(:,3);

