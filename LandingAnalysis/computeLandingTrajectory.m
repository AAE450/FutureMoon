function [traj, flightTime, segmentLogs] = computeLandingTrajectory(landingConstraints)
%COMPUTETHRUSTERREQUIREMENTS Will compute a trajectory through the
%waypoints covered in my (Kevin Sheridan) 3rd presentation.

% generate the trajectory and plot.

start = [landingConstraints.trajectoryConstraints(1:3, 1), landingConstraints.trajectoryConstraints(4:6, 1), zeros(3, 1), zeros(3, 1), zeros(3, 1)];
mid = landingConstraints.trajectoryConstraints(1:6, 2:(end-1));
final = [landingConstraints.trajectoryConstraints(1:3, end), landingConstraints.trajectoryConstraints(4:6, end), zeros(3, 1), zeros(3, 1), zeros(3, 1)];

warning('off')

[traj, flightTime, segmentLogs] = minimumTimeTrajectoryGenerator(start, mid, final, 'VEL', landingConstraints, 10);

fprintf('\nTotal Flight Time: %f s \nFinal Mass: %f kg\n Propellant Remaining: %f\n', flightTime, segmentLogs{end}.mass(end),...
    segmentLogs{end}.mass(end) - landingConstraints.payloadMass);

end
