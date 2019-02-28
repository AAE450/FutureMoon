function [propellantRemaining] = analyzeLunarDeploymentDescent(payloadMass, propMass, initialX)
%% VEHICLE PARAMETERS
landingConstraints.payloadMass = payloadMass;
landingConstraints.propellantMass = propMass;
landingConstraints.maxForcePerMotor = 2*12000;
landingConstraints.minForcePerMotor = 0;
landingConstraints.Isp = 470;
landingConstraints.g = 1.62;
landingConstraints.vehicleRadius = 4.5;
landingConstraints.vehicleHeight = 3;

%% TRAJECTORY CONSTRAINTS
                                 
entrySpeed = 1690;
exitDelta = [-500;-10;0];
entryAlt = 100000;

% [[pos;vel], [pos;vel]]
landingConstraints.trajectoryConstraints = [];
landingConstraints.trajectoryConstraints(1:6, end+1) = [[initialX;0;entryAlt]; [entrySpeed;0;0]];
landingConstraints.trajectoryConstraints(1:6, end+1) = [0;0;21; 0;0;-1];
landingConstraints.trajectoryConstraints(1:6, end+1) = [[-38000;0;21]; [0;0;0]];
landingConstraints.trajectoryConstraints(1:6, end+1) = [[-38000-41000;0;21]; [0;0;0]];
landingConstraints.trajectoryConstraints(1:6, end+1) = [[-38000-41000-38000;0;21]; [0;0;0]];

%% DON'T TOUCH
landingConstraints.thrusterLeverArm = landingConstraints.vehicleRadius;

R = landingConstraints.vehicleRadius;
H = landingConstraints.vehicleHeight;

mass = landingConstraints.payloadMass + landingConstraints.propellantMass/2;
Ixx = 1/4 * mass * R^2 + 1/12*mass*H^2;
Iyy = Ixx;
Izz = 1/2*mass*R^2;

landingConstraints.inertiaTensor = diag([Ixx, Iyy, Izz]);

landingConstraints.initialMass = landingConstraints.payloadMass + landingConstraints.propellantMass;


thrusterTheta = 5 * pi/180; % rad (the split between the thrusters)
landingConstraints.thrusterCount = 8/2; % this is because of an equality constrain imposed.

c = cos(thrusterTheta/2);
s = sin(thrusterTheta/2);

landingConstraints.thrusterMap = 2 * [1, 1, 1, 1;
                                      0, c, 0, -c;
                                      -c, 0, c, 0;
                                      -s, s, -s, s];
                                  
%% COMPUTE TRAJECTORY
[traj, flightTime, segmentLogs] = computeLandingTrajectory(landingConstraints);

propellantRemaining = segmentLogs{end}.mass(end) - landingConstraints.payloadMass;

generatePlots(segmentLogs, landingConstraints);
end