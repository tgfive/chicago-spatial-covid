% Clear windows and workspace
clear
clc
close all

%% Problem Definition
% Population
n = 2695598; %total population

% Initial Conditions
i0 = 127; %infected
r0 = 2; %recovered
s0 = n - i0 - r0; %susceptible
y0 = [s0, i0, r0]; %initial conditions vector

% Time domain
%t = 1:61; %60 days

%% Observed Data
% Load time, total cases and total deaths
[t,Cobs,Dobs] = loadData();

% Convert to a single vector
Yobs = [Cobs(:); Dobs(:)];

%% Test Data (with noise)
% % Parameters
% p = [0.3/n, 0.3]; %[beta, gamma]
% 
% % Compute simulation
% [~,Y] = ode45(@(t,y)sir(t,y,p),t,y0);
% I = Y(:,2);
% R = Y(:,3);
% 
% % Define total cases and deaths, and add noise
% noise = 1000*sawtooth(t)';
% Cobs = I + R + noise;
% Dobs = R + noise;
% 
% % Convert to a single vector
% Yobs = [Cobs(:); Dobs(:)];

%% Model Solution
% Define optimization iterations
iters = 2000;

% Parameter samples
beta = rndSample([0,1],iters);
gamma = rndSample([0.25,0.75],iters);

% Initialize estimate vectors
betaEst = zeros(1,iters);
gammaEst = zeros(1,iters);

% Sample each initial condition
for i=1:iters
    p0 = [beta(i)/n,gamma(i)];
    % Generate parameter estimate
    pEst = fminsearch(@(p)objfun(t,Yobs,p,y0),p0);
    betaEst(i) = pEst(1);
    gammaEst(i) = pEst(2);
end

% Calculate median values
betaMed = median(betaEst);
gammaMed = median(gammaEst);

% Calculate IQR
betaIQR = iqr(betaEst);
gammaIQR = iqr(gammaEst);

%% Present Results
% Solve with median estimated parameters
[~,Y] = ode45(@(t,y)sir(t,y,[betaMed,gammaMed]),t,y0);

% Convert to SIR
I = Y(:,2);
R = Y(:,3);

% Define total cases and deaths
Cnum = I + R;
Dnum = R;

% Print parameters
disp(['beta = ' num2str(betaMed * n) '(' num2str(n*(betaMed - betaIQR)) '-' num2str(n*(betaMed + betaIQR)) ')'])
disp(['gamma = ' num2str(gammaMed) '(' num2str(gammaMed - gammaIQR) '-' num2str(gammaMed + gammaIQR) ')'])

%% Plot results
figure() %total cases plot
plot(t,Cobs,'k.',t,Cnum,'b-')
legend('$C_{obs}(t)$','$C_{num}(t)$','Interpreter','latex','Location','southeast')
xlabel('$t$ (days from March 17)','interpreter','latex')
ylabel('$C(t)$','interpreter','latex')
set(gca, 'TickLabelInterpreter','latex')

figure() %total deaths plot
plot(t,Dobs,'k.',t,Dnum,'b-') %total deaths plot
legend('$D_{obs}(t)$','$D_{num}(t)$','Interpreter','latex','Location','southeast')
xlabel('$t$ (days from March 17)','interpreter','latex')
ylabel('$D(t)$','interpreter','latex')
set(gca, 'TickLabelInterpreter','latex')

%% Functions
% Model
function dydt = sir(~,y,p)
    s = y(1);
    i = y(2);
       
    dydt = [-p(1) * s * i;
             p(1) * s * i - p(2) * i;
             p(2) * i];
end

% Objective function
function obj = objfun(trange,Yobs,p,y0)
    % Compute solution vector
    [~,y] = ode45(@(t,y)sir(t,y,p),trange,y0);
    % Convert to sir vectors
    i = y(:,2);
    r = y(:,3);
    % Define numerical cases and deaths
    Cnum = i + r;
    Dnum = r;
    % Convert to a single vector
    Ynum = [Cnum(:); Dnum(:)];
    % Compute objective function
    obj = norm(Ynum - Yobs);
end

% Initial values sampling
function r = rndSample(range,n)
    a = range(1);
    b = range(2);
    r = (b-a).*rand(n,1) + a;
end

% Import time series data
function [time, cases, removed] = loadData()
  % Import the time series csv file
  series = load('time_series.csv');

  % Redefine variables for ease
  cases = series(:,1)';
  removed = series(:,2)';

  % Create time steps
  time = 1:length(cases);
end