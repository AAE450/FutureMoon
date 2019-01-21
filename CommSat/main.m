% Satellite coverage simulation 

% clear the command window, stored data and all figures
clear; 
clc;

% Declaring globals 
global GM 
% Gravitational constant for Earth
GM  = 3.986e14 ;

global Re

GMoon = 4.902794e12; 



% Radius of Earth 
Re = 6375e3; 

% radius of moon 
Rm = 1737e3;

% The two lines of TLE for the moon  
% source: https://www.n2yo.com/satellite/?s=27424
TLEmoon = "1 00000U 00000   16179.56434792  .00000000  00000-0  10000-3 0 00001 2 00000 018.4553 004.0484 0463000 029.4136 333.1953 00.03660099000006" ;

% TLE of the sun 
TLEsun = "1 00001U 00  0  0 95080.09236111  .00000000  00000-0  00000-0 0  0017 2 00001 023.4400 000.0000 0000000 282.8700 075.2803 00.00273790930019"; 
% Seperate the parameters given in the TLE using the readtle function 
[inclination,RAAN0,eccentricity,omega0, MA,  MM, epoch] = readtle(TLEmoon); 
[inclinations,RAAN0s,eccentricitys,omega0s, MAs,  MMs, epochs] = readtle(TLEsun); 

% convert mean motion in rev/day to rad/s 
MeanMotion = MM * 2*pi / 86400; 

MeanMotions = MMs * 2*pi / 86400; 

% calculate the semi major axis 
semiMajor = nthroot((GM/ MeanMotion^2),3);

semiMajors = nthroot((GM/ MeanMotions^2),3);

%% Simulating the 3D orbit. 

% The satellite orbit is simulated from 4th Sept 2018 11 am to 5th Sept 2018 11 am 
% Unix timestaps were used to declare the UTC time using https://www.unixtimestamp.com/index.php
tstart = 0; tend = 250*24*60*60; step = 1e3; 

% construct a vector for the timeline of the simulation 
tvec = tstart : step: tend ;

% Obtain the orbital pertubations due to the oblateness of the Earth 
[omega, RAAN,MeanMotion ] = pertubations(semiMajor ,eccentricity, inclination, tvec, omega0, RAAN0); 
[omegas, RAANs,MeanMotions ] = pertubations(semiMajors ,eccentricitys, inclinations, tvec, omega0s, RAAN0s); 

figure();
earth_sphere; 

% plot the orbit in 3D and obtain the ECI 3d coordinates 
[XM,YM,ZM] = plot_orbit(MeanMotion,  eccentricity ,omega ,RAAN ,inclination , 'r', tstart,tend, step, epoch, MA );

% provide the keplerian elements of the satellite introduced

a = 1200e3 ; 
e = 0.5;
w = 0; 
phi = 0;
inc = 90;
epoch = 0;
MA = 0; 

n = sqrt(GMoon/ a^3);
    
period = 2*pi/n; 
    
    
tvec = tstart : step: tend ;

[X, Y, Z , X0,Y0, Z0] = plot_moonsat(a + Rm, e, w, 0, inc, 'g' ,tstart, tend,step, epoch, MA, XM, YM,ZM);

Southpole = [-90, 0, 1000];
[R, phi , theta] = groundstation(Southpole, [X0;Y0;Z0], tvec); 
timeview = (100*length(find(theta(theta >=5)))/length(theta)); 

plot(theta)

% % North pole of the moon 
% % long , lat ,alt 
% 
% 
% times = []; 
% 
% as = 100e3 : 100e3 : 1200e3 ;
% for i = 1 : length(as)
%     
%     
% 
%     % groundstation function calculates the relative coordinates of the
%     % satellite with respect to the station.
%     
%     [R, phi , theta] = groundstation(Southpole, [X0;Y0;Z0], tvec); 
% 
%     timeview = (100*length(find(theta(theta >=5)))/length(theta)); 
%     
%     times = [times, timeview]; 
%      
% end
% 
% figure()
% p = plot(as,times)
% plot_latex(p , 'Semi Major axis(m)', '% visibility', '' ,{})
% 

% minimum visiblity time 
time = timeview/100 * period; 