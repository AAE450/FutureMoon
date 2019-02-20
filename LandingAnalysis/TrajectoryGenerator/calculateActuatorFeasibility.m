function [infeasible, finalMass, trajectorySegmentLog] = calculateActuatorFeasibility(Coefficients, settings, tf)
% computes the forces on each motor over time and computes propellant
% consumption.

trajectorySegmentLog = TrajectorySegmentLog();
finalMass = 0;
% Compute the time vector.
maxDt = 1;
minResolution = 10;
times = (0:maxDt:tf);

 if length(times) < minResolution
     times = linspace(0, tf, minResolution);
 end

dt = times(2) - times(1);


% compute the all derivatives of the trajectory and sample them;

pos = [(polyval((Coefficients(1, :)), times)); 
       (polyval((Coefficients(2, :)), times));
       (polyval((Coefficients(3, :)), times))];

vel = [(polyval(polyder(Coefficients(1, :)), times)); 
       (polyval(polyder(Coefficients(2, :)), times));
       (polyval(polyder(Coefficients(3, :)), times))];
   
accel = [(polyval(polyder(polyder(Coefficients(1, :))), times)); 
       (polyval(polyder(polyder(Coefficients(2, :))), times));
       (polyval(polyder(polyder(Coefficients(3, :))), times))];
   
jerk = [(polyval(polyder(polyder(polyder(Coefficients(1, :)))), times)); 
       (polyval(polyder(polyder(polyder(Coefficients(2, :)))), times));
       (polyval(polyder(polyder(polyder(Coefficients(3, :)))), times))];
   
snap = [(polyval(polyder(polyder(polyder(polyder(Coefficients(1, :))))), times)); 
       (polyval(polyder(polyder(polyder(polyder(Coefficients(2, :))))), times));
       (polyval(polyder(polyder(polyder(polyder(Coefficients(3, :))))), times))];

% check for inverted flight
for idx = (1:1:length(times))
    acc = accel(1:3, idx);
    
    if (acc(3) + settings.g) < 0
        fprintf('INVERTED FLIGHT NOT ALLOWED.\n');
        infeasible = true;
        return
    end
end


%calculate the desired omega vector
Omega_desired = zeros(3, 1);
%Aplha desired calculation
Alpha_desired = zeros(3, 1);
%Fi_bar_prime calc
Fi_bar_prime = zeros(3, 1);
%Fi_bar_prime_prime calc
Fi_bar_prime_prime = zeros(3, 1);
%create the bar vector of Fi
Fi_bar = zeros(3, 1);
%moments
Mb = zeros(3, 1);

% check individual motor forces.
m = settings.initialMass;
for idx = (1:1:length(times))
    
    Fi = m * (accel(1:3, idx) + settings.g*[0;0;1]);
    Fi_prime = m * jerk(1:3, idx);
    Fi_prime_prime = m * snap(1:3, idx);
    
    mag = norm(Fi);
    %TODO is Fi too small?
    
    Fi_bar = Fi / mag;
    
    %Calculation of fi_bar_prime
    Fi_bar_prime = (Fi_prime / norm(Fi)) - ((Fi * (Fi' * Fi_prime)) / (norm(Fi)^3));
    
    % calcing fi_bar_prime_prime
    Fi_bar_prime_prime = (Fi_prime_prime / norm(Fi)) - ((2 * Fi_prime * (Fi' * Fi_prime) + Fi * (Fi_prime' * Fi_prime) + Fi * (Fi' * Fi_prime_prime)) / norm(Fi)^3) + ((3 * Fi * (Fi' * Fi_prime)) / norm(Fi)^5);
    
    %the omega desired calc
    Omega_desired = cross(Fi_bar, Fi_bar_prime);
    %set the z moment to zero
    Omega_desired(3) = 0;
    
    %the alpha vector
    Alpha_desired = cross(Fi_bar, (Fi_bar_prime_prime - cross(Omega_desired, (cross(Omega_desired, Fi_bar_prime)))));
    %set the z to zero
    Alpha_desired(3) = 0;
    
    %FINALLY! now that we have the desired omega and the simulated current
    %omega, we can calcuate the exact forces that each motor must produce at a
    %given time(the maximum accelerations along a polynomial)
    Mb = settings.inertiaTensor * Alpha_desired + cross(Omega_desired, settings.inertiaTensor * Omega_desired);
    
    motorForces = settings.thrusterMap \ [norm(Fi); Mb];
    
    if any(motorForces > settings.maxForcePerMotor)
        fprintf('THRUSTER FORCE TOO HIGH\n')
        infeasible = true;
        return;
    end
    if any(motorForces < settings.minForcePerMotor)
        fprintf('THRUSTER FORCE TOO LOW\n')
        infeasible = true;
        return;
    end
    
    % compute next mass
    m = m - (norm(Fi) / (settings.Isp * 9.8)) * dt;
    
    if m <= 0
        fprintf('VEHICLE MASS IS NEGATIVE!\n')
        infeasible = true;
        return;
    end
    
    % should the trajectory be logged.
    if nargout == 3
        trajectorySegmentLog.time(end+1) = times(idx);
        trajectorySegmentLog.mass(end+1) = m;
        trajectorySegmentLog.pos(1:3, end+1) = pos(1:3, idx);
        trajectorySegmentLog.thrust(1:4, end+1) = motorForces;
        trajectorySegmentLog.tf = tf;
        
        % compute quaternion;
        theta = acos(Fi_bar' * [0;0;1]);
        q = [cos(theta/2); sin(theta/2) * -cross(Fi_bar, [0;0;1])];
        %q = q / norm(q);
        
        trajectorySegmentLog.quaternion(1:4, end+1) = q;
    end
    
end

finalMass = m;
   
infeasible = false;
fprintf('FEASIBLE\n')

end

