function r = rndSample(range,n)
% RNDSAMPLE   Calculate a normally distributed random sample.
%   r = rndSample(range,n) cacluates a size-n sample from
%   range = [range(1),range(2)].

    a = range(1);
    b = range(2);
    
    r = (b - a) .* rand(n,1) + a;
end