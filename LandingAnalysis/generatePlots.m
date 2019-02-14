function [] = generatePlots(segmentLogs)
posArr  = [];
thrustArr = [];
tArr = [];
qArr = [];
massArr = [];
tf = 0;
for log = segmentLogs
    posArr = [posArr, log{1}.pos];
    thrustArr = [thrustArr, log{1}.thrust];
    tArr = [tArr, tf + log{1}.time];
    qArr = [qArr, log{1}.quaternion];
    massArr = [massArr, log{1}.mass];
    tf = tArr(end);
end


figure('Name', 'Mass over time')
plot(tArr, massArr);
xlabel('time (s)');
ylabel('vehicle mass (kg)');

figure('Name', 'Position along whole Landing Trajectory')
plot(posArr(1, :), posArr(3, :));
grid on
xlabel('x (m)');
ylabel('z (m)');
