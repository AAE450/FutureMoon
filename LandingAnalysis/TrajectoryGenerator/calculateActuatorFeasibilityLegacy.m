function [infeasible, trajectorySegmentLog] = calculateActuatorFeasibilityLegacy(Coefficients, settings, tf)
% DEPRECATED!!!!!!!!!!!

%UNTITLED4 Summary of this function goes here
%   This function will test a given set of polynomials to see if they fit
%   within the actuator constraints specified
%   ESSENTIALLY
%   Coefficients: a 3X10 Matrix of coefficients
%   Mass
%   Moment - moment vector
%   tf: the final time
%MinZForce = the minumum force in the z direction typlically gravity (-45)

%gravity
g = settings.g;
%create the moment matrix
J = settings.inertiaTensor;
Mass = settings.initialWetMass;

% Find the maximum accelerations
%[maxima, foundRoots] = calculateMaximums(Coefficients, 2, tf);
%maxima
%foundRoots
%MinZForce
minResolution = 100;
times = (0:1:tf); 
if length(times) < minResolution
    times = linspace(0, tf, minResolution);
end

dt = times(2) - times(1);

%create the fTot
% [~, c] = size(foundRoots);
% f_total = zeros(3, c);
% %now test whether these maximums are within feasible limits
% for it = (1:length(foundRoots))
%     %calculate the magnitude of the acceleration gravity while taking into
%     %account mass and gravity
%     %mag is the [0, 0, 0, F_Total]' vector of the quadrotor. It must not
%     %exceed the maximum possible acceleration
%     f_total(1:3, it) = Mass * (maxima(:, it) + [0; 0; g]);
%     if norm(f_total(:, it)) > MaxForce || norm(f_total(3, it)) <= MinZForce
%         fprintf('FORCE TOO HIGH\n');
%         Error = 1;
%         return
%     end
% end


%now use a lot of physics and math to calculate the force each motor must
%be exerting at each point

%start by declaring the variables
%inertial frame force vector
Fi = zeros(3, length(times));
Fi(1, :) = Mass * (polyval(polyder(polyder(Coefficients(1, :))), times));
Fi(2, :) = Mass * (polyval(polyder(polyder(Coefficients(2, :))), times));
% add g to the 
Fi(3, :) = Mass * (polyval(polyder(polyder(Coefficients(3, :))), times) + (Mass * g * ones(1, length(times))));

f_total = Fi;

if any(Fi(3, :) < 0)
    fprintf('INVERTED FLIGHT NOT ALLOWED!\n');
    infeasible = 1;
    return;
end

% create the first derivative of force vector
Fi_prime = zeros(3, length(times));
Fi_prime(1, :) = Mass * (polyval(polyder(polyder(polyder(Coefficients(1, :)))), times));
Fi_prime(2, :) = Mass * (polyval(polyder(polyder(polyder(Coefficients(2, :)))), times));
Fi_prime(3, :) = Mass * (polyval(polyder(polyder(polyder(Coefficients(3, :)))), times));

% create the first derivative of force vector
Fi_prime_prime = zeros(3, length(times));
Fi_prime_prime(1, :) = Mass * (polyval(polyder(polyder(polyder(polyder(Coefficients(1, :))))), times));
Fi_prime_prime(2, :) = Mass * (polyval(polyder(polyder(polyder(polyder(Coefficients(2, :))))), times));
Fi_prime_prime(3, :) = Mass * (polyval(polyder(polyder(polyder(polyder(Coefficients(3, :))))), times));

%calculate the desired omega vector
Omega_desired = zeros(3, length(times));
%Aplha desired calculation
Alpha_desired = zeros(3, length(times));
%Fi_bar_prime calc
Fi_bar_prime = zeros(3, length(times));
%Fi_bar_prime_prime calc
Fi_bar_prime_prime = zeros(3, length(times));
%create the bar vector of Fi
Fi_bar = zeros(3, length(times));
%moments
Mb = zeros(3, length(times));

%caclculate the bar and prime and alpha
for it = (1:1:length(times))
    mag = norm(Fi(:, it));
    Fi_bar(:, it) = Fi(:, it) / mag;
    
    %Calculation of fi_bar_prime
    Fi_bar_prime(:, it) = (Fi_prime(:, it) / norm(Fi(:, it))) - ((Fi(:, it) * (Fi(:, it)' * Fi_prime(:, it))) / (norm(Fi(:, it))^3));
    
    % calcing fi_bar_prime_prime
    Fi_bar_prime_prime(:, it) = (Fi_prime_prime(:, it) / norm(Fi(:, it))) - ((2 * Fi_prime(:, it) * (Fi(:, it)' * Fi_prime(:, it)) + Fi(:, it) * (Fi_prime(:, it)' * Fi_prime(:, it)) + Fi(:, it) * (Fi(:, it)' * Fi_prime_prime(:, it))) / norm(Fi(:, it))^3) + ((3 * Fi(:, it) * (Fi(:, it)' * Fi_prime(:, it))) / norm(Fi(:, it))^5);
    
    %the omega desired calc
    Omega_desired(:, it) = cross(Fi_bar(:, it), Fi_bar_prime(:, it));
    %set the z moment to zero
    Omega_desired(3, it) = 0;
    
    %the alpha vector
    Alpha_desired(:, it) = cross(Fi_bar(:, it), (Fi_bar_prime_prime(:, it) - cross(Omega_desired(:, it), (cross(Omega_desired(:, it), Fi_bar_prime(:, it))))));
    %set the z to zero
    Alpha_desired(3, it) = 0;
    
    %FINALLY! now that we have the desired omega and the simulated current
    %omega, we can calcuate the exact forces that each motor must produce at a
    %given time(the maximum accelerations along a polynomial)
    Mb(:, it) = J * Alpha_desired(:, it) + cross(Omega_desired(:, it), J * Omega_desired(:, it));
end

motorForces = zeros(4, length(Mb));

torqueMat = settings.thrusterMap;
        
for it = (1:1:length(times))
    motorForces(:, it) = torqueMat \ [norm(f_total(:, it)); Mb(1, it); Mb(2, it); Mb(3, it)]
    
    % while in the for loop check to see if the forces are within the
    % bounds
    
    if any(motorForces(:, it) <= settings.minForcePerMotor) || any(motorForces(:, it) >= settings.maxForcePerMotor / 8)
        fprintf('INDIVIDUAL MOTOR FORCE TOO HIGH\n');
        infeasible = 1;
        return;
    end    
end

%IF YOU HAVE NOT RETURNED BY THIS POINT THE TRAJECTORY IS WITHIN FEASIBLE
%LIMITS
fprintf('FEASIBILE\n');
infeasible = -1;
return;

end

