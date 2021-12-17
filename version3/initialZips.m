clear
clc
close all;

zips = shaperead('chicago_zips.shp','UseGeoCoords',false);
h = height(zips);
faceColors = makesymbolspec('Polygon',...
    {'INDEX',[1 h],'FaceColor',polcmap(h)});

cFig = figure(1)

mapshow(zips,'SymbolSpec',faceColors)

set(cFig,'Units','Inches');
pos = get(cFig,'Position');
set(cFig,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
print(cFig,'~/Documents/GitHub/chicago-spatial-covid/version3/zips','-dpng','-r0')



initdata = load("initial_data.csv");

points = 40;

xvals = linspace(-87.9397,-87.5245,points);
yvals = linspace(41.6447,42.023,points);

initialS = zeros(points,points);
initialA = zeros(points,points);
initialI = zeros(points,points);
initialR = zeros(points,points);

for i = 1:points
    for j = 1:points
        x = xvals(i);
        y = yvals(points-j+1);

        [cases, deaths, population] = inZip(x,y,zips,initdata);

        if population
            i0 = cases / population;
            a0 = i0;
            r0 = (deaths + 8) / population;
            s0 = (population - (2 * cases + deaths + 8)) / population;

            initialS(j,i) = s0;
            initialA(j,i) = a0;
            initialI(j,i) = i0;
            initialR(j,i) = r0;
        end  
    end
end

writematrix(initialS,'initialS.csv')
writematrix(initialA,'initialA.csv')
writematrix(initialI,'initialI.csv')
writematrix(initialR,'initialR.csv')

