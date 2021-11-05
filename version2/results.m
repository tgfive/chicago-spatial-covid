%% Results Program
%
%
%% Clear MATLAB
clear
close all
clc

%% Fixed Parameters

% Load fixed parameters
load('params.mat');

% Define fixed parameters
q = [mu, t_q];
pops = [n, i0, h0, d0];

%% Load Optimized parameters
load('optimfile.mat', 'pFin');

%% Load Observed Data
[time, Cobs, Dobs] = loadData("time_series.csv");

% Create y vector
Yobs = [Cobs(:); Dobs(:)];

% Define end of simulation time
t_f = length(time);

%% Compute solution

% Compute the solution vector
[T,y] = computemodel(pFin,q,time,pops);

% Convert to system vectors
s = y(:,1);
e = y(:,2);
ar = y(:,3);
a = y(:,4);
i = y(:,5);
h = y(:,6);
r = y(:,7);
d = y(:,8);

% Define model cases and deaths
Cnum = i + h + r + d;
Dnum = d;

%% Plot Results
% Total cases
cFig = figure(1);
semilogy(T,Cnum,'r-',time,Cobs,'k.')
legend('$C_{num}(t)$','$C_{obs}(t)$','Interpreter','latex','Location','southeast')
xlabel('$t$ (days from March 18)','interpreter','latex')
ylabel('$C(t)$','interpreter','latex')
set(gca,'TickLabelInterpreter','latex')

% Total deaths
dFig = figure(2);
semilogy(T,Dnum,'r-',time,Dobs,'k.')
legend('$D_{num}(t)$','$D_{obs}(t)$','Interpreter','latex','Location','southeast')
xlabel('$t$ (days from March 18)','interpreter','latex')
ylabel('$D(t)$','interpreter','latex')
set(gca,'TickLabelInterpreter','latex')

% Export cases plot
set(cFig,'Units','Inches');
pos = get(cFig,'Position');
set(cFig,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
print(cFig,'~/Documents/GitHub/chicago-spatial-covid/update-10-22/cases','-dpdf','-r0')

% Export deaths plot
set(dFig,'Units','Inches');
pos = get(dFig,'Position');
set(dFig,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
print(dFig,'~/Documents/GitHub/chicago-spatial-covid/update-10-22/deaths','-dpdf','-r0')