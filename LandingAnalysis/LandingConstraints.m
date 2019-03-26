classdef LandingConstraints
    %LANDINGCONSTRAINTS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        payloadMass; % 1x1 (kg)
        propellantMass; % 1x1 (kg)
        vehicleHeight; % 1x1 (m) height of vehicle
        vehicleRadius; % 1x1 (m) radius of cylindrical vehicle
        
        % Trajectory Generator Settings
        g; % m/s^2
        maxForcePerMotor; % N
        minForcePerMotor; % N
        
        initialMass; % kg
        Isp;
        inertiaTensor; % 3x3 inertia tensor
        
        thrusterLeverArm = 4; % meters (the distant from the com to each thruster)
        thrusterCount = 8;
        thrusterMap; % used to map moments and total body z force to individual thruster outputs.
        
        
        trajectoryConstraints; % [[pos1;vel1], [pos2;vel2], [pos3;vel3], ...]
                               % each constraint is in the frame centered
                               % at the landing site.
        
        
    end
    
    methods
        
    end
end

