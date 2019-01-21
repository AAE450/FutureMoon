% function plots the 3d orbit of satellites, and if provided with an
% output, calculates the longitude and lattitude coordinates of the
% satellite. 
function [X, Y, Z ] = plot_orbit(n,  e, w, phi, inc, colour,tstart, tend,step, epoch, MA)
  
    global GM 
    
    % calculate the semi major axis from mean motion
    % semiMajor = nthroot((GM/ n^2),3);
     
    % define an array of time taken to complete a single orbit
    t = tstart : step : tend;
    
    % hence calculate the mean anomaly within the orbit using M = n* (t - T0)
    % assume the tragectory starts from t = 0;
    M = MA + n*(t - epoch);
     
    if e == 0
        True_an = M ;
        R = nthroot((GM/ n^2),3);
    else
        
        % calculate the eccentric anomaly vector
        
        % calculating the eccentric anomaly using the Newton Raphson (N-R)  method
        % let the initial estimates of E be equal to M, as the eccentricity is very
        % close to zero ,this assumption is valid.
        E = M;
        E_old = zeros(1,length(M));
        precision  = 10e-8;
        
        for i = 1: length(E)
            while abs(E(i) - E_old(i)) > precision
                % find the next eccentric anomaly value using N-R method
                E(i) = E(i) - ((E(i) - e*sin(E(i)) - M(i))./(1 - e*cos(E(i))));
                
                E_old(i) = E(i) ;
            end
        end
        
        
        % Find the true anomaly
        
        % Now the vector E gives the eccentric anomalies observed within a single
        % orbit, with time intervals of one second
        
        % calculating the true anomaly, using
        % V = 2arctan[ sqrt(1 + e / 1 - e) tanE/2);
        True_an = 2 * atan(sqrt((1 + e)/ (1 - e)) .* tan(E/2) );

        % Find the radial distance and semi-major axis vector for a single orbit
        % in order to find radial distance, we need to find the semi-major axis
        % length of the elliptical orbit provided
        % calculating the semi major a using a = (GM/n^2)^1/3
        a = nthroot((GM/ n^2),3); 
        
        % finding radial distance in meters at each point in the tragectory
        R = a*(1 - e^2) ./ (1 + e *cos(True_an));  
      
    end
   
    %  2D coordinates
    two_dimension = [R.*cos(True_an); R.*sin(True_an); zeros(1, length(True_an))] ;
    
    % the coordinate conversion from orbit to ECI
    % This is done in a for loop due to the variations in RAAN(phi) and
    % omega(w)
    three_dimension = [];  
    for i = 1 : length(w)
       
        % Convert 2D coordinates to 3D (ref: AERO4701 : orbital mechanics) http://web.aeromech.usyd.edu.au//AERO4701/Course_Documents/AERO4701_week2.pdf
        conv_matrix = [cosd(w(i)) .* cosd(phi(i))-sind(phi(i)).*sind(w(i)).*cosd(inc), -cosd(phi(i)).*sind(w(i))-sind(phi(i)).*cosd(w(i)).*cosd(inc) , sind(phi(i)).*sind(inc); 
        sind(phi(i)).*cosd(w(i))+cosd(phi(i)).*sind(w(i)) .* cosd(inc), -sind(w(i)).*sind(phi(i)) + cosd(phi(i)).*cosd(w(i)).*cosd(inc),  -cosd(phi(i)).*sind(inc);
        sind(w(i)).*sind(inc) , cosd(w(i)).*sind(inc),  cosd(inc)];

        % convert to 3d
        three_dimension = [three_dimension , conv_matrix * two_dimension(: , i )] ;

    end
    
    X = three_dimension(1, :);
    Y = three_dimension(2, :);
    Z = three_dimension(3, :); 
    
    
    hold on;
    plot3(X,Y,Z)
end

    



