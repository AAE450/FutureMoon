function [] = computeLandingPropulsionRequirements()
%COMPUTETHRUSTERREQUIREMENTS Will compute a trajectory through the
%waypoints covered in my (Kevin Sheridan) 2nd presentation.

% Inputs: - vehicleMass (kg)
%         - vehicleRadius (m) (used for moment of inertia calculation)
%         - vehicleHeight (m)

mass = 5000;
R = 4;
H = 2;
Fmax = 71000;
Fmin = 0;
Isp = 300;

Ixx = 1/4 * mass * R^2 + 1/12*mass*H^2;
Iyy = Ixx;
Izz = 1/2*mass*R^2;

entryAngle = -pi/4;
entrySpeed = 320;
v0 = [cos(entryAngle) * entrySpeed; 0; sin(entryAngle)*entrySpeed];
r0 = [-5000; 0; 5000];
r1 = [0; 0; 50];
v1 = [0; 0; -5];

correctionDelta = [20;0;0];

r2 = [0; 0; 25] + correctionDelta;
v2 = [0; 0; -2.5];
r3 = [0; 0; 0] + correctionDelta;
v3 = [0;0;0];

% generate the trajectory and plot.

start = [r0, v0, zeros(3, 1), zeros(3, 1), zeros(3, 1)];
mid = [[r1;v1], [r2;v2]];
final = [r3, v3, zeros(3, 1), zeros(3, 1), zeros(3, 1)];


[traj, flightTime] = minimumTimeTrajectoryGenerator(start, mid, final, 'VEL', mass, [1.5, 1.5, 1], 1e6, -45, Fmax*2, pi/2, 10)

%plot the trajectory
clf;
[p1, p2] = trajectoryPlotter(traj);
p2
daspect([1 1 1])
xlim([-100, 30])
ylim([0, 200])
%zlim([-10, 10])
hold on
%arrow3(p1, p2, 'b', 10)
plot(p1(:, 1), p1(:, 3))
title('Landing Trajectory')
xlabel('x (m)')
ylabel('z (m)')
grid on;
%savefig('initial_trajectory');
hold off

end
