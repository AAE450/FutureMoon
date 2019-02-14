function [] = computeLandingPropulsionRequirements()
%COMPUTETHRUSTERREQUIREMENTS Will compute a trajectory through the
%waypoints covered in my (Kevin Sheridan) 3rd presentation.

% Inputs: - vehicleMass (kg)
%         - vehicleRadius (m) (used for moment of inertia calculation)
%         - vehicleHeight (m)

R = 2;
H = 2;

mass = 5000;
Ixx = 1/4 * mass * R^2 + 1/12*mass*H^2;
Iyy = Ixx;
Izz = 1/2*mass*R^2;


settings = Settings;
settings.inertiaTensor = diag([Ixx, Iyy, Izz]);
settings.maxForcePerMotor = 12000;
settings.minForcePerMotor = 0;
settings.initialMass = 5000;
settings.Isp = 300;
settings.g = 1.62;


thrusterTheta = 5 * pi/180; % rad (the split between the thrusters)
settings.thrusterCount = 8/2; % this is because of an equality constrain imposed.

c = cos(thrusterTheta/2);
s = sin(thrusterTheta/2);

settings.thrusterMap = 2 * [1, 1, 1, 1;
                        0, c, 0, -c;
                        -c, 0, c, 0;
                        -s, s, -s, s];



entryAngle = 0;
entrySpeed = 1690;
v0 = [cos(entryAngle) * entrySpeed; 0; sin(entryAngle)*entrySpeed];
r0 = [-700000; 0; 100000];
r1 = [-10; 0; 30];
v1 = [0; 0; -5];

correctionDelta = [-20;-10;0];

r2 = [0; 0; 1] + correctionDelta;
v2 = [0; 0; -1];
r3 = [0; 0; 0] + correctionDelta;
v3 = [0;0;-0.05];

% generate the trajectory and plot.

start = [r0, v0, zeros(3, 1), zeros(3, 1), zeros(3, 1)];
mid = [[r1;v1], [r2;v2]];
%mid = [[r1;v1]];
final = [r3, v3, zeros(3, 1), zeros(3, 1), zeros(3, 1)];

warning('off')

[traj, flightTime, segmentLogs] = minimumTimeTrajectoryGenerator(start, mid, final, 'VEL', settings, 40);

fprintf('\nTotal Flight Time: %f s \nFinal Mass: %f kg\n', flightTime, segmentLogs{end}.mass(end));

% plot the trajectory
generatePlots(segmentLogs);

end
