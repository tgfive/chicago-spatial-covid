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

xpoints = 40;
ypoints = 29;

xvals = linspace(-87.9397,-87.5245,xpoints);
yvals = linspace(41.6447,42.023,ypoints);

initialS = zeros(ypoints,xpoints);
initialA = zeros(ypoints,xpoints);
initialI = zeros(ypoints,xpoints);
initialR = zeros(ypoints,xpoints);

for j = 1:ypoints
    for i = 1:xpoints
        x = xvals(i);
        y = yvals(ypoints-j+1);

        [cases, deaths, population] = inZip(x,y,zips,initdata);

        if population
            i0 = cases / population;
            a0 = 3 * i0;
            r0 = (deaths + 8) / population;
            s0 = 1 - (i0 + a0 + r0);

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