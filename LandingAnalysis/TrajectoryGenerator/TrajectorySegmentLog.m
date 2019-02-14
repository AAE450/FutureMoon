classdef TrajectorySegmentLog
    %TRAJECTORYSEGMENTLOG Stores the pose and thrusts over time.
    
    properties
        time = []; %{t1, t2}
        tf = 0;
        mass = [];
        thrust = []; % {[f1;f2;f3;f4;f5;f6;f7;f8], }
        quaternion = []; % {[w;x;y;z], }
        pos = []; % {[x;y;z], }
    end
    
    methods
        
    end
end

