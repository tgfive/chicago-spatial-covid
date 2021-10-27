clear
clc
close all

n = 8414240;

i0 = 297;
h0 = 134;
d0 = 6;

mu = 5.79e-7;
beta_is = 0.32 / n;
beta_as = 0.28 / n;
eta_is = 0.39;
eta_as = 0.38;
sigma_a = 1 / 2.97;
sigma_i = 1 / 3.77;
m = 1 / 5.97;
m_ar = 1 / 6.85;
chi = 1 / 6.74;
psi = 1 / 8.33;
gamma = 0.55;
omega = 0.25;

t_q = 16;

e0i0 = 2.69;
a0i0 = 2.93;

e0 = e0i0 * i0;
a0 = a0i0 * i0;

ar0 = 0;
r0 = 0;

s0 = n - (e0 + a0 + ar0 + i0 + h0 + r0 + d0);

p = [sigma_a, sigma_i, m_ar, m, gamma, omega, chi, psi, beta_as, beta_is, eta_as, eta_is];
q = [mu, t_q];

y0 = [s0, e0, a0, ar0, i0, h0, r0, d0];

tspan = [1, 60];

[T,Y] = ode45(@(t,y)sir(t,y,p,q),tspan,y0);

s = Y(:,1);
e = Y(:,2);
a = Y(:,3);
ar = Y(:,4);
i = Y(:,5);
h = Y(:,6);
r = Y(:,7);
d = Y(:,8);

Cnum = i + h + r + d;

figure()
semilogy(T,Cnum)