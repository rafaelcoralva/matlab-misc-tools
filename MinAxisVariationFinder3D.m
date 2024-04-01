function [ min_theta, min_elevation ] = MinAxisVariationFinder3D( x,y,z )
%UNTITLED Summary of this function goes here

% Interpolate by 5 times - this ensures we have enough resolution to capture every angle.
    
    x=interp(x,5);
    y=interp(y,5);
    z=interp(z,5);
    
    % Plotting the trajectory
    ThreeDtrajectory=figure;
    
    plot3(x,y,z)
    ylabel('Y')
    xlabel('X')
    zlabel('Z')
    title('Interpolated Trajectory')
    
    % Plotting the origin on the trajectory
    line([0 0], [0 0],[min(z) max(z)],'Color','black','LineStyle','--')
    line([0 0], [min(y) max(y)] ,[0 0],'Color','black','LineStyle','--')
    line( [min(x) max(x)] ,[0 0], [0 0],'Color','black','LineStyle','--')
    
    % Expressing the trajectory in spherical polar coordinates.
    
    [theta,elevation,r] = cart2sph(x,y,z);
    
    
    r_theta_elevation=[r' theta' elevation'];
    
    clear theta r elevation
    
    
    % Calculating the distance between every data point.
    
    for i=1:length(x)
        
        for j=i+1:length(x)
            
            dist(i,j)=norm([x(j); y(j); z(j)] - [x(i); y(i); z(i)]);
            
        end
        
    end
    
    
    angle_lim_degrees=1;
    ErrorInDegrees=angle_lim_degrees+100;
    
    while ErrorInDegrees>angle_lim_degrees
        
        % Identifying the data points with the smallest distance between
        % them (most of them will be adjacent points on the trajectory
        
        minimum = min(min(dist)); % The minimum distance between any two points.
        [point1,point2]=find(dist==minimum); % The indices of the two data points with the maximum distance between them.
        
        % Testing the points are colinear with the origin by checking the
        % difference in azimuthal and polar angle between them.
        coordinates1=[x(point1); y(point1); z(point1)];
        coordinates2=[x(point2); y(point2); z(point2)];
        
        CosError = dot(coordinates1,coordinates2)/(norm(coordinates1)*norm(coordinates2));
        ErrorInDegrees = 180 - acosd(CosError);
        
        if ErrorInDegrees>angle_lim_degrees
            
            dist(point1,point2)=0;
            
        end
        
    end
    
       figure(ThreeDtrajectory)
    hold on
    plot3([x(point1) x(point2)], [y(point1) y(point2)], [z(point1) z(point2)],'r')
    plot3(x(point1),y(point1),z(point1),'ro')
    plot3(x(point2),y(point2),z(point2),'ro')
    legend('Trajectory',' ',' ',' ','Axis of Maximum Variation')
    

end

