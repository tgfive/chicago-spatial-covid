function [cases, deaths, population] = inZip(x,y,zips)
    for i=1:length(zips)
        box = zips(i).BoundingBox;
        xv = box(:,1);
        yv = box(:,2);
        if inpolygon(x,y,xv,yv)
            cases = zips(i).zip;
        else
            cases = 0;
            deaths = 0;
            population = 0;
        end
    end