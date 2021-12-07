clear
clc
close all;

zips = shaperead('chicago_zips.shp','UseGeoCoords',false);
h = height(zips);
faceColors = makesymbolspec('Polygon',...
    {'INDEX',[1 h],'FaceColor',polcmap(h)});

mapshow(zips,'SymbolSpec',faceColors)
grid on

series = load("initial_data.csv");

for i = 1:61
    disp(zips(i).BoundingBox);
    disp(zips(i).zip);
end

