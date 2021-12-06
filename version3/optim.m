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
% Bounds are in the form:
% [omega0betaA, omega0betaI, eta, gammaA, gammaI, delta]

% Lower bounds
lb = zeros(1,6);

% Upper bounds
ub = 1 * ones(1,6);

%% Load Observed Data
[time, Cobs, Dobs] = loadData("time_series.csv");

% Define end of simulation time
t_f = length(time);

%% Optimum Solution

% Define number of iterations
iters = 1;
    
% Define initial populations
y0 = [s0, a0, i0, r0];

% Preallocate the estimate matrix
pEst = zeros(iters,length(lb));

% Perform optimization iterations
tic % Start timer
for iter=1:iters

    % Sample starting parameters
    %p0 = sampleparams(lb,ub,s0);
    p0 = (lb + ub) / 2;
    
    % Compute parameter estimate
    pEst(iter,:) = fmincon(@(p)objfun([1,t_f],Cobs,p,tq,y0,n),p0,[],[],[],[],lb,ub);

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