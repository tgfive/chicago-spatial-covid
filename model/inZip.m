function [cases, deaths, population] = inZip(x,y,zips,initdata)
    for i=1:length(zips)
        box = zips(i).BoundingBox;
        zip = str2num(zips(i).zip);

        xv = box(:,1);
        yv = box(:,2);
        if inpolygon(x,y,xv,yv)
            index = find(initdata(:,1) == zip);
            cases = initdata(index,2);
            deaths = initdata(index,3);
            population = initdata(index,4);
            return
        end
            
    end
    cases = 0;
    deaths = 0;
    population = 0;
    return