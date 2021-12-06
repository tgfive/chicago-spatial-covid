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

% Define initial populations
y0 = [s0, a0, i0, r0];

%% Load Optimized parameters
load('optimfile.mat', 'pFin');

%% Load Observed Data
[time, Cobs, Dobs] = loadData("time_series.csv");

% Define end of simulation time
t_f = length(time);

%% Compute solution

% Compute the solution vector
[T,y] = computemodel(pFin,tq,[1,t_f],y0);

% Convert to system vectors
s = y(:,1);
a = y(:,2);
i = y(:,3);
r = y(:,4);

% Define model cases and deaths
Cnum = i;

%% Plot Results
% Total cases
cFig = figure(1);
semilogy(T,Cnum,'r-',time,Cobs / n,'k.')
legend('$C_\mathrm{num}(t)$','$C_\mathrm{obs}(t)$','Interpreter','latex','Location','southeast')
xlabel('$t$ (days from March 18)','interpreter','latex')
ylabel('$C(t)$','interpreter','latex')
set(gca,'TickLabelInterpreter','latex')

% Export cases plot
set(cFig,'Units','Inches');
pos = get(cFig,'Position');
set(cFig,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
print(cFig,'~/Documents/GitHub/chicago-spatial-covid/update-10-22/cases','-dpdf','-r0')
