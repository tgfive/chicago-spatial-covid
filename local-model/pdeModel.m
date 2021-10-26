%% Simple SIR in two spacial dimensions.

clear;
clc;
close all;

%% Initialize a two equation PDE model.

model = createpde(2);

%% Establish a model for the polygonal domain
poly1 = [2 % 2 specifies we are forming a polygon
    6 % Number of edges
    1 % x1
    1 % x2
    2 % x3
    2 % x4
    0 % x5
    0 % x6
    1 % y1
    0 % y2
    0 % y3
    2 % y4
    2 % y5
    1 % y6
    ];

gd = [poly1];

ns = char('poly1');
ns = ns';
sf = 'poly1';
[dl,bt] = decsg(gd,sf,ns);

% Plot the computational domain
fig1 = figure(1);
pdegplot(dl,'EdgeLabels','on','FaceLabels','on')
axis equal

% Attach the computational domain to the PDE model
geometryFromEdges(model,dl);
% geometryFromEdges(model,@squareg);
% 
% pdegplot(model,'EdgeLabels','on')
% ylim([-1.5,1.5])
% axis equal

%% Boundary Conditions
%applyBoundaryCondition(model,'neumann','edge',1:6,'g',[0,0],'q',[0,0]);

%% Specify coefficients for the PDE model
% Define the parameters of the system
Ds = 0.001;
Di = 0.01;
beta = 0.38206;
gamma = 0.39656;

% Based on these parameters, specify the PDE coefficients in the toolbox
% format
d = [1;1];
c = [Ds;Di];
f = @(location,state) [-beta * state.u(1,:) .* state.u(2,:);
                       beta * state.u(1,:) .* state.u(2,:) - gamma * state.u(2,:)];

specifyCoefficients(model,'m',0,'d',d,'c',c,'a',0,'f',f);

%% Generate the mesh
% Spacial domain
generateMesh(model,'Hmax',0.1);
% Plot the mesh
fig2 = figure(2);
pdeplot(model)
axis equal

% Time domain
tlist = 0:0.1:200;

%% Initial conditions
setInitialConditions(model,@u0fun2);

%% Solve the PDE
model.SolverOptions.ReportStatistics='on';
result = solvepde(model,tlist);

%% Display the results
u = result.NodalSolution;

% Convert to the compartments
S = squeeze(u(:,1,:));
I = squeeze(u(:,2,:));
R = gamma*I;

%% Function Declarations

function u0 = u0fun(location)
    M = length(location.x);
    disp(M)
    u0 = zeros(2,M);
    if (location.x==1.5 & location.y==0.5)
        u0(2,:) = 64;
    elseif (location.x==0.5 & location.y==1.5)
        u0(2,:) = 64;
    else
        u0(2,:) = 0;
    end
    u0(1,:) = 5;
end

function u0 = u0fun2(location)
    M = length(location.x);
    u0 = zeros(2,M);
    u0(1,:) = rand(1);
    u0(2,:) = rand(1);
end
