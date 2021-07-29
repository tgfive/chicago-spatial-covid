clear
clc

%% 1D Diffusion Equation
%u_t = kappa * u_xx

%% Problem Definition
% Step sizes
dx = 0.5;

% Space interval
xspan = [0 2*pi];

% Time interval
tspan = [0 50];

% Contants
kappa = 0.1;

% Boundary conditions
bc = [0 0];

% Initial conditions
ic = sin(xspan(1):dx:xspan(2)); % sine wave over the interval, satisfies bc's

%% Matrix Equations
% Size of system
N = length(ic);

% Boundary condition vector
b = zeros(N,1);
b(2) = bc(1);
b(end-1) = bc(2);
b = kappa*b/dx;

% Operator matrix
A = zeros(N);
A(1:1+N:N*N) = -2;
A(N+1:1+N:N*N) = 1;
A(2:1+N:N*N-N) = 1;
A(1,:) = 0;
A(:,1) = 0;
A(end,:) = 0;
A(:,end) = 0;
A = kappa*A/dx;

% Initial conditions vector
u0 = ic(2:end-1)';

%% Solve System
[t,u] = ode45(@(t,y) A*y + b, tspan, ic');

%% Plot results
[X,Y] = meshgrid(1:N,t);
surf(X,Y,u)
xlabel('$x$','interpreter','latex')
ylabel('$t$','interpreter','latex')
zlabel('$u(x,t)$','interpreter','latex')
set(gca, 'TickLabelInterpreter','latex')