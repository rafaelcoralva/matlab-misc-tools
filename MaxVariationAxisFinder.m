function [ axis_theta ] = MaxVariationAxisFinder( x ,y, z, varargin )
% Funciton to find the axis of maximum peak to peak variation (i.e. distance) on a 2D or 3D
% trajectory.


%   Detailed explanation goes here

if nargin<3
    
    % Interpolate by 5 times.
    
    x=interp(x,5);
    y=interp(y,5);
    
    
    
    for i=1:length(x)
        
        r(i)=sqrt(x(i).^2 + y(i).^2);
        theta(i)=atan(y(i)/x(i));
        
         if x(i)>0 && y(i)>0 % 1st Quadrant
            theta(i)=atan(abs(y(i))/abs(x(i)));
        end
        
        if x(i)<0 && y(i)>0 % 2nd Quadrant
            theta(i)=pi - atan(abs(y(i))/abs(x(i)));
        end
        
        if x(i)<0 && y(i)<0 % 3rd Quadrant
            theta(i)=pi + atan(abs(y(i))/abs(x(i))); 
        end
            
         if x(i)>0 && y(i)<0 % 4th Quadrant
             theta(i)=(1.5*pi) + atan(abs(y(i))/abs(x(i)));    
         end
        
    end
    
    r_theta=[r' theta'];
    
    clear theta r
       
    r_theta=sortrows(r_theta,2); % Arranging the trajectory points in order of increasing angle.
    
    
    theta_window=1; % The degrees window/tolerance we consider.
    
    for i=1:length(find(r_theta(:,2)<pi))
       
        theoretical_opposite_theta=r_theta(i,2)+pi; % This is the THEORETICAL angle corresponding to the opposite side of the trajectory - our data points will likely be close to this point but not exactly on it.
        
        % Searching for our data point thetas (i.e. angles) closest to the
        % theoretical theta.
        
        temp=find(r_theta(:,2)>theoretical_opposite_theta-theta_window*0.0175); % The indices of the data point angles (in r_theta) bigger than the lower limit of the window.
        opposite_thetas=temp(find(r_theta(temp,2)<theoretical_opposite_theta+theta_window*0.0175)); % The indices (in r_theta) that lie completely within the tolerance window.

        clear temp theoretical_opposite_theta
        
        theta_p_p_amplitudes=r_theta(i,1) + r_theta(opposite_thetas,1); % The peak to peak amplitude between the original considered data point, and the corresponding datapoints on the other side of the trajectory.
        
        if isempty(theta_p_p_amplitudes)
            theta_peak_to_peak(i)=NaN; % Sometimes there are no "opposite_thetas" (because our theta_window is too small).
        else
        
        theta_peak_to_peak(i)=max(theta_p_p_amplitudes); % This is the max peak-to-peak amplitude of the input trajectory for that theta.
        
        end
        
        clear theta_p_p_amplitudes
    
    end
    
    figure;    
    plot(r_theta(1:length(theta_peak_to_peak),2),theta_peak_to_peak)
    xlabel('Theta (radians)')
    ylabel('Peak-to-Peak Amplitude')    
    
    axis_theta = r_theta(find(theta_peak_to_peak==max(theta_peak_to_peak)),2);
        
end

end

