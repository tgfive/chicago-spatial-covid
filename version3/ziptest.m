clear
clc
close all

zips = shaperead('chicago_zips.shp','UseGeoCoords',false);
h = height(zips);
faceColors = makesymbolspec('Polygon',...
    {'INDEX',[1 h],'FaceColor',polcmap(h)});

findata = load("final_data.csv");

for i=1:length(zips)
    zip = str2num(zips(i).zip);
    index = find(findata(:,1) == zip);
    cases = findata(index,2);
    deaths = findata(index,3);
    population = findata(index,4);
    
    if population
        infected = cases / population;
    else
        infected = 0;
    end

    zips(i).objectid = infected;

end

maxinfected = max([zips.objectid]);
fall = flipud(autumn(height(zips)));
densityColors = makesymbolspec('Polygon', {'objectid', [0 maxinfected], 'FaceColor', fall});

cFig = figure(1)
mapshow(zips,'SymbolSpec',densityColors)

caxis([0 maxinfected])
colormap(fall)
colorbar

set(cFig,'Units','Inches');
pos = get(cFig,'Position');
set(cFig,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
print(cFig,'~/Documents/GitHub/chicago-spatial-covid/version3/final-cases','-dpng','-r0')