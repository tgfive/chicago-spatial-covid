%% Optimization Program
%
%
%% 
clear
close all
clc

%% Fixed Parameters

% Load fixed parameters
load('params.mat');

%% Optimization Parameter Bounds

% Lower bounds
lb = [0, 0, 0, 0, 2, 2, 5, 5, 5, 5, 0.25, 0.1, 1, 1];

% Upper bounds
ub = [1, 1, 1, 1, 7, 7, 12, 12, 20, 20, 0.75, 0.5, 5, 5];

%% Load Observed Data
[time, Cobs, Dobs] = loadData("time_series.csv");

% Create y vector
Yobs = [Cobs(:); Dobs(:)];

% Define end of simulation time
t_f = length(time);

%% Optimum Solution

% Define number of iterations
iters = 3;
    
% Define fixed parameters
q = [mu, t_q];
pops = [n, i0, h0, d0];

% Perform optimization iterations
tic % Start timer
for iter=1:iters

    % Sample starting parameters
    p0 = sampleparams(lb,ub,n);
    
    % Compute parameter estimate
    pEst(iter,:) = fminsearch(@(p)objfun(time,Yobs,p,q,pops),p0);

    disp("Iteration: " + num2str(iter))
end
toc % End timer

%% Export Results
% Compute the final solution vector from the median of the estimates
pFin = median(pEst,1);

% Compute the interquartile range
iqrange = iqr(pEst,1);

% Save the results to a file
save('optimfile.mat','pFin','iqrange')