% Earth visiblity simulator function 
% Author: Minduli C. Wijayatunga (Communications and Control) 

% function generates the orbit around the moon under given keplerian
% coordinates from tstart to tend. 
% Then the visiblity from earth is calculated for each timestep in the time
% vector (tstart : step : tend)
% Ouput : Array which displays 1 when satellite is visible, 0 when it isnt.

function results = Earthvis(a,e,w,phi,inc,epoch, MAS,tstart,tend,step) 

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
    % TLEsun = "1 00001U 00  0  0 95080.09236111  .00000000  00000-0  00000-0 0  0017 2 00001 023.4400 000.0000 0000000 282.8700 075.2803 00.00273790930019"; 
    % Seperate the parameters given in the TLE using the readtle function 
    [inclination,RAAN0,eccentricity,omega0, MA,  MM, epochM] = readtle(TLEmoon); 
    % [inclinations,RAAN0s,eccentricitys,omega0s, MAs,  MMs, epochs] = readtle(TLEsun); 

    % convert mean motion in rev/day to rad/s 
    MeanMotion = MM * 2*pi / 86400; 

    % calculate the semi major axis 
    semiMajor = nthroot((GM/ MeanMotion^2),3);

    %% Simulating the 3D orbit. 


    % construct a vector for the timeline of the simulation 
    tvec = tstart : step: tend ;

    % Obtain the orbital pertubations due to the oblateness of the Earth 
    [omega, RAAN,MeanMotion ] = pertubations(semiMajor ,eccentricity, inclination, tvec, omega0, RAAN0); 
    % [omegas, RAANs,MeanMotions ] = pertubations(semiMajors ,eccentricitys, inclinations, tvec, omega0s, RAAN0s); 

    figure();
    earth_sphere; 

    % plot the orbit in 3D and obtain the ECI 3d coordinates 
    [XM,YM,ZM] = plot_orbit(MeanMotion,  eccentricity ,omega ,RAAN ,inclination , 'r', tstart,tend, step, epochM, MA );

    % provide the keplerian elements of the satellite introduced
    n = sqrt(GMoon/ a^3);

    period = 2*pi/n; 

    tvec = tstart : step: tend ;

    [X, Y, Z , X0,Y0, Z0] = plot_moonsat(a + Rm, e, w, phi, inc, 'g' ,tstart, tend,step, epoch, MAS, XM, YM,ZM);

    % convert moon MCI coordinates to MCMF
    coodinates = ECI_ECEF([X;Y;Z], tvec);

    % find the position relative to the Earth 
    XrelE = XM + coodinates(1,:); 
    YrelE = YM + coodinates(2,:); 
    ZrelE = ZM + coodinates(3,:); 

    % See if the point is on the far side or the near side.
    Moonmags = sqrt(XM.^2 + YM.^2 + ZM.^2); 
    relEmags = sqrt(XrelE.^2 + YrelE.^2 + ZrelE.^2); 

    results = []; 
    for i = 1 : length(relEmags) 
        if Moonmags(i) > relEmags(i)
            results = [results ,1]; 
        else
            results = [results , 0];
        end   
    end

end
