function [] = drawLander(pos, quat, thrust)
%Draws a lander on the current figure.

height = 2;
rad = 2;

R = quat2rotm(quat');

theta = linspace(0, 2*pi, 10);
circle = rad * [cos(theta); sin(theta); zeros(1, length(theta))];

% draw top of circle
transformedCircle = circle + height / 2 * [zeros(2, length(theta)); ones(1, length(theta))];
transformedCircle = R * transformedCircle + [ones(1, length(theta)) * pos(1); ones(1, length(theta)) * pos(2); ones(1, length(theta)) * pos(3)];
hold on
plot3(transformedCircle(1, :), transformedCircle(2, :), transformedCircle(3, :), 'k-')

% draw top of circle
transformedCircle = circle - height / 2 * [zeros(2, length(theta)); ones(1, length(theta))];
transformedCircle = R * transformedCircle + [ones(1, length(theta)) * pos(1); ones(1, length(theta)) * pos(2); ones(1, length(theta)) * pos(3)];

plot3(transformedCircle(1, :), transformedCircle(2, :), transformedCircle(3, :), 'k-')

% draw connections
for idx = (1:length(theta))
    ln = [R * [circle(1:2, idx); height/2] + pos, R * [circle(1:2, idx); -height/2] + pos];
    
    plot3(ln(1, :), ln(2, :), ln(3, :), 'k-');
end

% draw thrust forces
theta = [0, pi/2, pi, 3*pi/2];
idx = 1;
for th = theta
    ln = [rad*[cos(th), cos(th); sin(th), sin(th)]; 0, -5*thrust(idx)*1e-3];
    
    ln = [R * ln(1:3, 1) + pos, R * ln(1:3, 2) + pos];
    
    plot3(ln(1, :), ln(2, :), ln(3, :), 'r-');
    idx = idx + 1;
end

