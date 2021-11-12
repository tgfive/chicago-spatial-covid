function smoothTest

n=100;          % number of intervals (i.e. parametric curve would be evaluted n+1 times)

p =[0.5887    0.9819
0.5887    0.9819
0.5597    1.3551
0.5565    1.7749
0.4081    1.8274
0.4500    1.4834
0.3016    1.5300
0.2210    1.3901
0.2242    1.2152
0.2790    1.0169
0.4500    0.9295
0.5790    0.9236
0.5887    0.9819];
Px = p(:,1); Py = p(:,2);
% Note first and last points are repeated so that spline curve passes
% through all points

% when Tension=0 the class of Cardinal spline is known as Catmull-Rom spline
Tension=0; 
figure
set1x=[];
set1y=[];
for k=1:length(Px)-3
    [xvec,yvec]=EvaluateCardinal2DAtNplusOneValues([Px(k),Py(k)],[Px(k+1),Py(k+1)],[Px(k+2),Py(k+2)],[Px(k+3),Py(k+3)],Tension,n);
    set1x=[set1x, xvec];
    set1y=[set1y, yvec];    
end

Tension=0.5; 
set2x=[];
set2y=[];
for k=1:length(Px)-3
     [xvec,yvec]=EvaluateCardinal2DAtNplusOneValues([Px(k),Py(k)],[Px(k+1),Py(k+1)],[Px(k+2),Py(k+2)],[Px(k+3),Py(k+3)],Tension,n);   
    set2x=[set2x, xvec];
    set2y=[set2y, yvec];    
end
plot(set1x,set1y,'g',set2x,set2y,'b','linewidth',2)

% no longer need. free the memory
clear set1x, clear set1y, clear set2x, clear set2y, clear xvec, clear yvec 

h = legend('Tension=0 (Catmull-Rom)','Tension=0.5');
hold on

plot(Px,Py,'ro','linewidth',2) % plot control points
title('\bfCardinal Spline')
hold off
end

function [xvec,yvec]=EvaluateCardinal2DAtNplusOneValues(P0,P1,P2,P3,T,N)

xvec=[]; yvec=[];

% u vareis b/w 0 and 1.
% at u=0 cardinal spline reduces to P1.
% at u=1 cardinal spline reduces to P2.

u=0;
[xvec(1),yvec(1)] =EvaluateCardinal2D(P0,P1,P2,P3,T,u);
du=1/N;
for k=1:N
     u=k*du;
    [xvec(k+1),yvec(k+1)] =EvaluateCardinal2D(P0,P1,P2,P3,T,u);
end
end

function [xt,yt] =EvaluateCardinal2D(P0,P1,P2,P3,T,u)

s= (1-T)./2;

% MC is cardinal matrix
MC=[-s     2-s   s-2        s;
    2.*s   s-3   3-(2.*s)   -s;
    -s     0     s          0;
    0      1     0          0];

GHx=[P0(1);   P1(1);   P2(1);   P3(1)];
GHy=[P0(2);   P1(2);   P2(2);   P3(2)];

U=[u.^3    u.^2    u    1];


xt=U*MC*GHx;
yt=U*MC*GHy;
end
