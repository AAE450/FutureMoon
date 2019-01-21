% function calculates the pertubations of omega and RAAN due to the J2
% effect of earth. 
function [omega, RAAN, n] = pertubations(a ,e, i, timearray, omega0, RAAN0 )

global GM 
global Re 

J2 = 0.00108263; 
p = a*(1 - e^2);

%orbit mean motion with J2 correction 
n = sqrt(GM / a^3) *(1 + 1.5* J2 * Re^2 / p^2*( 1 - 3/2 * (sind(i))^2)*(1 - e^2)^0.5 );

% rate of change of argument of perigee 
omegadot = 1.5* J2 * Re^2 /p^2 *n * (2 - 5/2 * (sind(i))^2);

% calculate the rate of change of RAAN
RAANdot = -1.5 * J2 * Re^2 / p^2 * n * cosd(i);

% Implement the rate of change to derive the varying omega and RAAN
omega = omega0 + rad2deg(omegadot).* timearray;
RAAN = RAAN0 + rad2deg(RAANdot).* timearray;


end
