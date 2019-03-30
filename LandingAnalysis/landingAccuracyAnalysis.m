% This script produces a plot which shows the deployment accuracy when
% winching a system down from various altitudes. This is mainly useful for
% Hab deployment.

fx = 32; % This accounts for lens distortion in wide FOV lenses.
cx = 256;
l = 30;

theta = deg2rad(30);

z = (10:0.1:100);

sigma = sqrt(1/2 * (z + sin(theta)*l).^2 / fx^2);

plot(z, (sigma).^2 + 1);
title('Position Estimate Accuracy from different altitudes');
xlabel('Deployment Alittude (m)');
ylabel('Position Variance m^{2}')
grid on
ylim([0, 8])

figure();
plot(z, (sigma)*6 + 1);
title('6-\sigma Deployment Accuracy');
xlabel('Deployment Alittude (m)');
ylabel('Maximum Deployment Position Error (m)')
grid on