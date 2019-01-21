
% Function produces the relative polar coordinates of a satellite
% travelling through the given ECI coords, with respect to the station
% coordinates over the time described by tsincevernal. 
function [R, phi2 , theta_orbit] = groundstation(station, coords, tsincevernal)

%% 
% convert ECI to ECEF 
coodinates = ECI_ECEF(coords, tsincevernal);


% Convert coordinates of the satellite to local vertical coordinates 
% calculate the position of the satellite with respect to the ground 
LGDV = ecef_lgdv(station, coodinates);
 
% convert the satellite relative position coordinates to polar 
 inpolar = cart_polar(LGDV);
 R= inpolar(1,:) ; phi2 = inpolar(2,:); theta_orbit= inpolar(3,:);
 
% ------------------------------------------------------------------------ 
% Nested functions 
%% Convert the ECEF coordinates to LGDV
 function new = ecef_lgdv(station, position)
     
     % convert the station longitude to radians 
     lambda = deg2rad(station(1));
     
     % convert station latitude to radians 
     phi = deg2rad(station(2)); h = station(3);
     
     % convert the LGDV station coordinates to ECEF. 
     ground_ecef = llh_ecef_det(station);
     
     % calculate the relative position in ECEF 
     relative_ecef = position - ground_ecef;
     
     % convert ECEF to LDCV 
     transform = [-sin(lambda)*cos(phi), -sin(phi), -cos(lambda)*cos(phi);
         -sin(lambda)*sin(phi), cos(phi), -cos(lambda)*sin(phi);
         cos(lambda), 0, -sin(lambda)];
     
     % return the LGDV coordinate of the relative satellite position 
     new = transform' * relative_ecef;
 end
      
%% function converts ECI to ECEF 
function  result = ECI_ECEF(cs, times)
       % declare an empty array to store the results. 
       result = [];
       
       % omega is required for the conversion and is a constant. 
       omega = 2*pi / (27 *24* 60*60); 
       
       % convert each set of coordinates using the conversion matrix 
       for t = 1 : length(times) 
           matrix = [cos(omega * times(t)), sin(omega*times(t)), 0; -sin(omega*times(t)), cos(omega*times(t)), 0; 0, 0, 1];
           result = [result ,matrix*[cs(1, t); cs(2, t) ;cs(3, t)]]; 
       end
end

% convert cartesian coordinates to polar coordinates 
 function new = cart_polar(position)
            Rs = sqrt(position(1, : ).^2 + position(2,:).^2 + position(3,:).^2);
            phi = atan2(position(2,:), position(1,:));
            theta = atan(-position(3,:)./sqrt(position(1,:).^2 + position(2,:).^2));
            
            new = [ Rs; rad2deg(phi);rad2deg(theta)];
 end

% convert latitude, longitude and height to ECEF. 
 function new = llh_ecef_det(llh)
  
  Rm = 1737e3; 
  e = 1/900; 
  
            % using the conversion matrix,llh is converted to ECEF. 
            lambda = deg2rad(llh(1)); phi = deg2rad(llh(2)); h = llh(3);
            N = Rm/sqrt(1-(e^2*sin(lambda)^2));
            r_x = (N+h) * cos(lambda) * cos(phi);
            r_y = (N+h) * cos(lambda) * sin(phi);
            r_z = (N * (1 - e^2) + h) * sin(lambda);
            
            new = [r_x; r_y; r_z];
 end

    
end
