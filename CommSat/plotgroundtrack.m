
% function outputs the latitude and longitiude coordinates covered by a
% satellite travelling through the ECI coordinates inputed within the 
% tsincevernal time array. 
function [lon, lat]  =  plotgroundtrack(coords, tsincevernal)

% convert ECI to ECEF 
coodinates = ECI_ECEF(coords, tsincevernal);

% convert ECEF to LGDV coordinates 
[lat, lon] = ecef_lgdv(coodinates); 



%--------------------------------------------------------------------------
% Nested functions 
%% function converts ECI to ECEF 
function  result = ECI_ECEF(cs, times)
       
       % declare an empty array to store the results 
       result = [];
       
       % omega is used to calculate ECEF coordinates 
       omega = 7.292115e-5; 
       
       % convert each set of coordinates to ECI
       for t = 1 : length(times) 
           matrix = [cos(omega * times(t)), sin(omega*times(t)), 0; -sin(omega*times(t)), cos(omega*times(t)), 0; 0, 0, 1];
           result = [result ,matrix*[cs(1, t); cs(2, t) ;cs(3, t)]]; 
       end
end
               
%% Function converts ECEF to LGDV coodinates for a matrix of coordinates                
function [lat, lon] = ecef_lgdv(cds)
    
    % declare an empty array to store the results 
    rest = [];
    
    % convert each set of coordinates to ECI
    for i = 1: length(cds)
        rest = [rest , ecef_llh_det([cds(1, i),cds(2 , i),cds(3, i)])];
    end
    
    % Extract the lat and long values from the matrix 
    lat = rest(1, : ); lon = rest(2, : );
end


%% Function converts ECEF to LGDV coodinates for an array of coordinates 
% source for the method : http://clynchg3c.com/Technote/geodesy/coordcvt.pdf

function new = ecef_llh_det(pos)

    % Declaring the globals 
    global Re 
    global e 

    % Extract x,y and z positons 
     x = pos(1); y = pos(2); z = pos(3);

    % Declare the constants used throughout the iterations 
    h = 0; N = Re; p = sqrt(x^2 + y^2);

    % state an initial latitiude 
    phi = 100;

    % iterate through the function given in source to find the solution for h
    % and phi. 
    for i = 1:100

        % solve for sinphi
        sinphi = z/(N*(1 - e^2) + h);

        % solve for phi
        phi = atan((z + (e^2)*N*sinphi)/p);

        % calculate N
        N = Re/sqrt(1 - (e^2)*(sin(phi)^2));

        % declare the new iteration N 
        Nprev = N;

        % calculate corresponding altitude 
        h = p/cos(phi) - N;
    end

    % merge latitude, longitude and altitude values.  
     new = [rad2deg(phi); rad2deg(atan2(y,x)); h-(Re/1000)];


end

end

  
 
  
 
 