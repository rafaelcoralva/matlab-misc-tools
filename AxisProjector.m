function [ projection ] = AxisProjector( theta, x, y, z, elevation, varargin )
% Function to "project" the x,y, (and z) signals onto a new specific axis
% given by theta (and elevation) using the dot product.

    if nargin==3 % For two dimensions
        
        projection_axis=[cos(theta) ; sin(theta)] - [0; 0];
        
        for i=1:length(x)
           
            projection(i)= dot([x(i); y(i)],projection_axis);
            
        end
        
    end
    
    
    if nargin==5 % For three dimensions
        
        [xhat, yhat, zhat]=sph2cart(theta,elevation,1); % The unit vector coordinates pointing in the direction of the desired axis.
        
        projection_axis=[xhat; yhat; zhat] - [0; 0; 0];
        
        for i=1:length(x)
            
            projection(i)= dot(([x(i); y(i); z(i)]-[0; 0; 0]),projection_axis);

        end
        
    end



end

