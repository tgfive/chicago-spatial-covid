clear
clc
close all;

zips = shaperead('chicago_zips.shp','UseGeoCoords',true);
h = height(zips);
faceColors = makesymbolspec('Polygon',...
    {'INDEX',[1 h],'FaceColor',polcmap(h)});

geoshow(zips,'SymbolSpec',faceColors)

% Create a polygon for each ZIP code
for zip = 1:length(zips)
    poly(zip) = simplify(polyshape(zips(zip).Lon, zips(zip).Lat));
end


% % Take the union of the polygons to create the entire domain
% polyout = simplify(union(poly));
% 
% % Create a triangulation representation of the domain
% tr = triangulation(polyout);
% 
% % Create a PDE model
% model = createpde;
% 
% tnodes = tr.Points';
% telements = tr.ConnectivityList';
% 
% geometryFromMesh(model,tnodes,telements);
% pdegplot(model)
% 
% generateMesh(model,'Hgrad',1.3)
% 
% figure
% pdemesh(model)
% pdegplot(model)