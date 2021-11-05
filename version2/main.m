%% Main Program
%
%
%% 
clear
close all
clc

%% Fixed Parameters

% Population parameters
n = 2695598; % Total population
i0 = 160; % Initial infected
h0 = 38; % Initial hospitalized
d0 = 3; % Initial deceased

% Non-COVID deaths
mu = 1.8997e-5;

% Lockdown start
t_q = 4;

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
iters = 1;
    
% Define fixed parameters
q = [mu, t_q];
pops = [n, i0, h0, d0];

% Linear constraints
A = [];
b = [];
Aeq = [];
beq = [];

% Perform optimization iterations
for iter=1:iters
    tic % Start timer

    % Sample starting parameters
    p0 = sampleparams(lb,ub,n);
    
    % Compute parameter estimate
    pEst(iter,:) = fminsearch(@(p)objfun(time,Yobs,p,q,pops),p0);

    toc % End timer

    disp("Iteration: " + num2str(iter))
end

% Compute the final solution vector from the median of the estimates
pFin = median(pEst,1);

% Compute the interquartile range
iqrange = iqr(pEst,1);

% Save the results to a file
save('optimfile.mat','pFin','iqrange')

% Compute the solution vector
[T,y] = computemodel(pFin,q,time,pops);

% Convert to system vectors
i = y(:,5);
h = y(:,6);
r = y(:,7);
d = y(:,8);

% Define model cases and deaths
Cnum = i + h + r + d;
Dnum = d;

% Convert to a single vector
Ynum = [Cnum(:); Dnum(:)];

%% Plot Results
% Total cases
cFig = figure(1);
semilogy(T,Cnum,time,Cobs)
legend('$C_{num}(t)$','$C_{obs}(t)$','Interpreter','latex','Location','southeast')
xlabel('$t$ (days from March 18)','interpreter','latex')
ylabel('$C(t)$','interpreter','latex')
set(gca,'TickLabelInterpreter','latex')

% Total deaths
dFig = figure(2);
semilogy(T,Dnum,time,Dobs)
legend('$D_{num}(t)$','$D_{obs}(t)$','Interpreter','latex','Location','southeast')
xlabel('$t$ (days from March 18)','interpreter','latex')
ylabel('$D(t)$','interpreter','latex')
set(gca,'TickLabelInterpreter','latex')

% Export cases plot
set(cFig,'Units','Inches');
pos = get(cFig,'Position');
set(cFig,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
print(cFig,'cases','-dpdf','-r0')

% Export deaths plot
set(dFig,'Units','Inches');
pos = get(dFig,'Position');
set(dFig,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
print(dFig,'deaths','-dpdf','-r0')