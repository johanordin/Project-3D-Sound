%--------------------------------------------------------------------
%   get_hrir
%
%   Returns a (stereo) head related impulse response which matches
%   closest the input angles. The IR is obtained from an MIT media
%   lab's HRTF Measurements of a KEMAR Dummy-Head Microphone which
%   can be found at http://sound.media.mit.edu/KEMAR.html
%
%   Input parameters
%           theta: angle (in degrees) in plane around head
%           phi: angle (in degreees) of elevation
%   Returns:
%           h: HRIR matching closest theta and phi
%--------------------------------------------------------------------
function [h] = get_hrir(theta, phi);
 
% define available locations:
% elevations: available phi values
elevations = [-40 -30 -20 -10 0 10 20 30 40 50 60 70 80 90];
% theta_increments: spacing between thetas for corresponding phi
theta_increments =   [6.5 6 5 5 5 5 5 6 6.5 8 10 15 30 360];
 
% Determine which phi is best match based on search of
% values in elevations; record the index
diff = Inf;
elev_match = 1;
for I = 1:length(elevations)
    this_diff = abs(elevations(I)-phi);
    if ( this_diff <= diff )
        diff = this_diff;
        elev_match = I;
    end
end
 
% Calculate best theta match knowing the linear spacing
% between each theta
num_incr = round(abs(theta)/theta_increments(elev_match));
theta_match = floor(num_incr*theta_increments(elev_match));
while (theta_match>180)
    num_incr = num_incr-1;
    theta_match = floor(num_incr*theta_increments(elev_match));
end
 
% concatonate strings to make appropriate file name
% based on the HRIR file naming convention of
% H*e&&&a.wav in dir hrirs 
% (*=phi in min digits; &&& = three digit phi, zero padded)
 
filename = strcat( 'hrirs\H', int2str(elevations(elev_match)) );
filename = strcat( filename, 'e');
 
tempstr = int2str(theta_match);
needed_zeros = 3-length(tempstr);
if (needed_zeros > 0)
    for I = 1:needed_zeros
        tempstr = strcat( '0',tempstr );
    end
end
 
filename = strcat( filename, tempstr );
filename = strcat( filename, 'a.wav');
 
% now read file with 'filename' into memory
[x fs nbits] = wavread(filename);
 
% if theta was negative, we are to the left of the frontal plane.
% only thetas to right (positive: 0 to 180) of plane are measured,
% but we can use these for left by swapping the l/r hrirs for the
% absolute value of theta (ie left HRTF is same as right HRTF but
% swapping stereo tracks)
h = zeros(size(x));
if (theta < 0)
    h(:,1) = x(:,2);
    h(:,2) = x(:,1);
else
    h(:,1) = x(:,1);
    h(:,2) = x(:,2);
end



 
