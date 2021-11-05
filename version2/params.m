%% Define Fixed Parameters
% Set the known parmaeters here.
% These are exported to the other main programs.

%% Clear MATLAB
clear
close all
clc

%% Set Values

% Population parameters
n = 2695598; % Total population
i0 = 160; % Initial infected
h0 = 38; % Initial hospitalized
d0 = 3; % Initial deceased

% Non-COVID deaths
mu = 1.8997e-5;

% Lockdown start
t_q = 4;

% Export fixed parameters
save('params.mat')