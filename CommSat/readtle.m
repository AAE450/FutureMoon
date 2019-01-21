
% function reads the TLE and outputs important parameters. 
function [inclination,RAAN,eccentricity,omega,MA, MM, epoch] =    readtle(line)

% seperate each element in the TLE
values = strsplit(line);

% inclination is the 12th element 
inclination =  double(values(12));

% RAAN is the 13th element 
RAAN =  double(values(13));

% eccentricity is the 14th element, the decimal point need to be placed in front of the numbers 
eccentricity = double( strcat( ".", values(14))); 

% omega is the 15th element 
omega = double(values(15));

% Mean anomaly is the 16th element 
MA = double(values(16)) ;

% Mean motion is the 17th element 
MM = double(values(17)) ;


% 2018-01-01:0:0:0 + the fractional section in the TLE 
% converted to a timestamp using https://www.unixtimestamp.com
epoch = 1535724947.16; 

end