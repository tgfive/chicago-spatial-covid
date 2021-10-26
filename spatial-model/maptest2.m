MapLatLimit = [41 48];
MapLonLimit = [-74 -66];

states = readgeotable('usastatelo.shp');
n = ["Maine" "New Hampshire" "Vermont" "Massachusetts" "Connecticut" "Rhode Island" "New York"];
rows = ismember(states.Name,n);
NEstates = states(rows,:);

maxdensity = max([NEstates.PopDens2000])
fall = flipud(autumn(height(NEstates)));

densityColors = makesymbolspec('Polygon', {'PopDens2000', ...
    [0 maxdensity], 'FaceColor', fall});

axesm('MapProjection', 'eqaconic', 'MapParallels', [],...
  'MapLatLimit', MapLatLimit, 'MapLonLimit', MapLonLimit,...
  'GLineStyle', '-')
geoshow(NEstates, 'DisplayType', 'polygon', ...
    'SymbolSpec', densityColors)