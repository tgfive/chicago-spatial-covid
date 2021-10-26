clear
clc
close all;

zips = shaperead('chicago_zips.shp','UseGeoCoords',true);
h = height(zips);
faceColors = makesymbolspec('Polygon',...
    {'INDEX',[1 h],'FaceColor',polcmap(h)});

geoshow(zips,'SymbolSpec',faceColors)

%% COVID data by ZIP code
% Import the shapefile
covid_zips = shaperead('chicago_covid_zips.shp','UseGeoCoords',true);

% Remove unused fields
fields = ["time_week_", "time_wee_2", "cases_cumu", "case_rate_", "case_rat_2", ...
    "tests_week", "tests_cumu", "test_rate_", "test_rat_2", "percent_te", ...
    "percent__2", "deaths_wee", "death_rate", "death_ra_2", "row_id"];
covid_zips = rmfield(covid_zips,fields);


maxweeks = max([covid_zips.week_numbe]);

for week = 1:maxweeks
    rows = ismember([covid_zips.week_numbe],week);
    week_zips = covid_zips(rows,:);
    
    rows = ~isnan([week_zips.cases_week]);
    week_zips = covid_zips(rows,:);
    
    maxcases = max([week_zips.cases_week]);
    fall = flipud(autumn(height(week_zips)));
    
    casesColors = makesymbolspec('Polygon',{'cases_week', ...
        [0 maxcases], 'FaceColor', fall});
    
    refresh
    geoshow(week_zips)
    pause(.2)
end