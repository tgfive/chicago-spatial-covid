function [time, cases, deceased] = loadData(file)
% LOADDATA   Imports time series data.
%   [time, cases, deceased] = loadData(file) imports the first two
%   columns from file.csv as cases and deceased, and calculates the
%   time steps.

    % Import the time series csv file
    series = load(file);

    % Define the caes
    cases = series(:,1)';
    deceased = series(:,2)';

    % Create time steps
    time =  1:length(cases);
end