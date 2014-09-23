%--------------------------------------------------------------------
%   hrtf_model
%
%   Applies a head-related transfer function to an input 
%   monoaural audio track using a head/torso/pinna model
%
%   Input parameters
%           x: Input signal
%           fs: sample rate of x in samples per second
%           theta: angle (in degrees) in plane around head
%           phi: angle (in degreees) of elevation
%   Returns:
%           y: [r l] stereo track in 3D for headphones
%--------------------------------------------------------------------
function [y] = hrtf_model(x, fs, theta, phi)
 
% 180 degrees gives a divide by zero, so if exactly 180 compensate
% for this by approximating with another (close) value
if (abs(theta) == 180)
    theta = 179 * sign(theta);
end
 
% Apply Head Shadowing to input (-theta for left ear)
r_hs = hsfilter(theta, fs, x);
l_hs = hsfilter(-theta, fs, x);
 
% Apply a torso delay to input (-theta for left ear)
r_sh = torso(x, fs, theta, phi);
l_sh = torso(x, fs, -theta, phi);

size(r_sh)
size(r_hs)

% Sum the head shadowed/torso delayed signals: This is the
% signal that makes it to the outer ear (pre pinna)
r_on_pinna = zeros(1, max(length(r_hs),length(r_sh)));

size(r_on_pinna(1:length(r_hs)))

% r_on_pinna(1:length(r_hs)) = r_on_pinna(1:length(r_hs)) + r_hs';
r_on_pinna(1:length(r_sh)) = r_on_pinna(1:length(r_sh)) + r_sh;
 
l_on_pinna = zeros(1, max(length(l_hs),length(l_sh)));

%l_on_pinna(1:length(l_hs)) = l_on_pinna(1:length(l_hs)) + l_hs';
l_on_pinna(1:length(l_sh)) = l_on_pinna(1:length(l_sh)) + l_sh;
 
% Apply pinna reflections to the prepinna signals (-theta for left ear)
r = pinna_reflections(r_on_pinna, fs, theta, phi);
l = pinna_reflections(l_on_pinna, fs, -theta, phi);
 
% Pad shorter signal with zeros to make both same length
if ( length(r) < length(l) )
    r = [r zeros(1,length(l)-length(r))];
else
    l = [l zeros(1,length(r)-length(l))];
end;
 
% return final headphone stereo track
y = [r' l'];

 
function [output] = hsfilter(theta, Fs, input)
% hsfilter(theta, Fs, input)
% 
% filters the input signal according to head shadowing
% theta is the angle with the frontal plane 
% Fs is the sample rate
 
theta = theta + 90;
theta0 = 150 ;alfa_min = 0.05 ;     
c = 334;  % speed of sound
a = 0.08; % radius of head                                              
w0 = c/a;
alfa = 1+ alfa_min/2 + (1- alfa_min/2)* cos(theta/ theta0* pi) ;    
 
B = [(alfa+w0/Fs)/(1+w0/Fs), (-alfa+w0/Fs)/(1+w0/Fs)] ; 
    % numerator of Transfer Function
A = [1, -(1-w0/Fs)/(1+w0/Fs)] ;                       
    % denominator of Transfer Function
if (abs(theta) < 90)
 gdelay = - Fs/w0*(cos(theta*pi/180) - 1)  ;
else
 gdelay = Fs/w0*((abs(theta) - 90)*pi/180 + 1); 
end;
a = (1 - gdelay)/(1 + gdelay);
    % allpass filter coefficient
out_magn = filter(B, A, input);
output = filter([a, 1],[1, a], out_magn);

