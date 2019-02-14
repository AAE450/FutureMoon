function [C, finalMass, trajectorySegmentLog] = polynomialTrajectorySolver(X, Y, Z, settings, ITERATIONS)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%   This will solve for the coefficients of a constrained 9 order
%   polynomial
% END_POINT_MODES: 'FULL', 'VEL', 'NOVEL'
% for vel and no vel use zeros in their place
%the number of iterations

%declare ti as zero
ti = 0;
%this is a ball park estimate of tf for starting
%in the future it should take into account the distance
tf = 1000;

%create variables for newton's method
t_start = ti;
t_end = tf * 2;
t_mid = tf;
infeasible = 0;

neverFeasible = true;

bestT = t_end;

for it = (1:1:ITERATIONS)
    A = get9DegPolyMatrix(ti, t_mid);
    
    %solve for the coefficient matrix
    C = zeros(3, 10);
    C(1, :) = A\X';
    C(2, :) = A\Y';
    C(3, :) = A\Z';
    
    %now that we have the Coefficient matrix run the calculate Actuator
    %feasibility function
    [infeasible] = calculateActuatorFeasibility(C, settings, t_mid);
    
    
    % reasses the bounding points of the newton's method variables
    if infeasible == 1
        t_start = t_mid;
        t_mid = (t_mid + t_end) / 2;
    else
        bestT = t_mid;
        neverFeasible = false;
        t_end = t_mid;
        t_mid = (t_mid + t_start) / 2;
    end
end
%set the tf to the answer
tf = bestT;

%recalculate the Coefficient matrix one last time
A = get9DegPolyMatrix(ti, tf);
%solve for the coefficient matrix
C = zeros(3, 11);
C(1, 1:10) = A\X';
C(2, 1:10) = A\Y';
C(3, 1:10) = A\Z';
C(:, 11) = [tf, tf, tf]';

[infeasible, finalMass, trajectorySegmentLog] = calculateActuatorFeasibility(C(1:3, 1:10), settings, tf);



if neverFeasible
    error('TRAJECTORY SEGMENT NOT FEASIBLE!');
else
    fprintf('FOUND FEASSIBLE TRAJECTORY SEGMENT WITH TF: %f\n', tf);
end

end

