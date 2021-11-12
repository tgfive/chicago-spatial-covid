clear
clc
close all;

domain = shaperead('boundaries.shp','UseGeoCoords',true);

pgon = simplify(polyshape(domain.Lon,domain.Lat));
plot(pgon)
axis equal

tr = triangulation(pgon);

model = createpde;

tnodes = tr.Points';
telements = tr.ConnectivityList';

geometryFromMesh(model,tnodes,telements);

dFig = figure(1);
pdegplot(model)
xlabel('$x$','interpreter','latex')
ylabel('$y$','interpreter','latex')
set(gca,'TickLabelInterpreter','latex')

mFig = figure(2);
pdemesh(model)
xlabel('$x$','interpreter','latex')
ylabel('$y$','interpreter','latex')
set(gca,'TickLabelInterpreter','latex')

% Export domain plot
set(dFig,'Units','Inches');
pos = get(dFig,'Position');
set(dFig,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
print(dFig,'~/Documents/GitHub/chicago-spatial-covid/update-10-22/domain','-dpdf','-r0')

% Export mesh plot
set(mFig,'Units','Inches');
pos = get(mFig,'Position');
set(mFig,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
print(mFig,'~/Documents/GitHub/chicago-spatial-covid/update-10-22/mesh','-dpdf','-r0')


%generateMesh(model)