function d= findD (area, shape)
if strcmp( shape, 'Circle' )
    d=2*sqrt(area/pi);
elseif strcmp( shape, 'Square' )
    d=sqrt(area);
elseif strcmp( shape, 'Triangle' )
    d=(2/3)*(3^(3/4))*sqrt(area);
    d=d;
end