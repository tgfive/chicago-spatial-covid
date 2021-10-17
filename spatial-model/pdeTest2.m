%% PDE Test 2
% u_t = u_xx + u for 0 < x < pi, t > 0
% u = 0          at x = 0, pi
% u(x,0) = phi(x)

clear
clc

%% Step parameters
J = 20; % Number of discrete steps
delta_x = pi/20; % Space mesh
s = 5/11; % s = delta_t / (delta_x)^2 < 1/2

%% Define matrix

% Identity matrix
I = eye(J+1);

% Tridiagonal matrix
D = diag(-2*s*ones(1,J+1)) + diag(0.5*s*delta_x^2*ones(1,J+1)) + diag(s*ones(1,J),1) + diag(s*ones(1,J),-1);
D(1,:) = 0;
D(J+1,:) = 0;

% Full scheme matrix
A = I + D;

%% Define initial values

for j=0:J
    u(j+1,1) = phi(j*delta_x);
end

%% Define time steps

% Define end time
T = 3;

% Calculate required time steps
delta_t = s*delta_x^2; % calculate delta_t
N = ceil(T/delta_t); % calculate required steps

%% Iteration

for n=2:N
    u(:,n) = A*u(:,n-1);
end

%% Plot results
[Y,X] = meshgrid(1:N,0:delta_x:pi);
surf(X,Y,u)
xlabel('$x$','interpreter','latex')
ylabel('$t$','interpreter','latex')
zlabel('$u(x,t)$','interpreter','latex')
set(gca, 'TickLabelInterpreter','latex')

%% Extra functions

% Initial value function
function u0 = phi(x)
    if x >= 0 && x <= pi/2
        u0 = x;
    elseif x > pi/2 && x <= pi
        u0 = pi - x;
    end
end