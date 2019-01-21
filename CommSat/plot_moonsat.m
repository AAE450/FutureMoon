% function plots the 3d orbit of satellites, and if provided with an
% output, calculates the longitude and lattitude coordinates of the
% satellite. 

function [X, Y, Z , X0,Y0, Z0] = plot_moonsat(a,  e, w, phi, inc, colour,tstart, tend,step, epoch, MA, XM, YM,ZM)
  
    GMoon = 4.902794e12; 
    
    % calculate the semi major axis from mean motion
    % semiMajor = nthroot((GM/ n^2),3);
     
    % define an array of time taken to complete a single orbit
    t = tstart : step : tend;
   
    n = sqrt(GMoon/ a^3);
    
    P = 2*pi/n; 
    
    % hence calculate the mean anomaly within the orbit using M = n* (t - T0)
    % assume the tragectory starts from t = 0;
    M = MA + n*(t - epoch);
     
    if e == 0
        True_an = M ;
        R = nthroot((GMoon/ n^2),3);
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
        a = nthroot((GMoon/ n^2),3); 
        
        % finding radial distance in meters at each point in the tragectory
        R = a*(1 - e^2) ./ (1 + e *cos(True_an));  
      
    end
   
    %  2D coordinates
    two_dimension = [R.*cos(True_an); R.*sin(True_an); zeros(1, length(True_an))] ;

    
    % Convert 2D coordinates to 3D (ref: AERO4701 : orbital mechanics) http://web.aeromech.usyd.edu.au//AERO4701/Course_Documents/AERO4701_week2.pdf
    conv_matrix = [cosd(w) .* cosd(phi)-sind(phi).*sind(w).*cosd(inc), -cosd(phi).*sind(w)-sind(phi).*cosd(w).*cosd(inc) , sind(phi).*sind(inc); 
    sind(phi).*cosd(w)+cosd(phi).*sind(w) .* cosd(inc), -sind(w).*sind(phi) + cosd(phi).*cosd(w).*cosd(inc),  -cosd(phi).*sind(inc);
    sind(w).*sind(inc) , cosd(w).*sind(inc),  cosd(inc)];

    % convert to 3d
    three_dimension = conv_matrix * two_dimension;
    
    X0 = three_dimension(1, :);
    Y0 = three_dimension(2, :);
    Z0 = three_dimension(3, :);
    
    X = X0 + XM;
    Y = Y0 + YM;
    Z = Z0 + ZM; 
    
    hold on; 
    p  = plot3(X,Y,Z);
    plot_latex(p, 'X(m)', 'Y(m)','Z(m)', '', {});
    
end




