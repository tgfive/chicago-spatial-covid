%% Define Fixed Parameters
% Set the known parmaeters here.
% These are exported to the other main programs.

%% Clear MATLAB
clear
close all
clc

%% Set Values
% Start of simulation (t = 1) is 3/18/2020

% Initial populations
n = 2695598; % Total population
c0 = 160; % Initial cases
h0 = 38; % Initial hospitalized
d0 = 3; % Initial deceased

% Initial compartments
i0 = (c0 + h0) / n;
a0 = 3 * i0;
r0 = (d0 + 8) / n;
s0 = 1 - (a0 + i0 + r0);

% Lockdown times
tbol = 4; % beginning of lockdown
teol = 73; % end of lockdown
tq = (tbol + teol) / 5;

% Export fixed parameters
save('params.mat')