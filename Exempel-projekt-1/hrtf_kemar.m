%--------------------------------------------------------------------
%   hrtf_kemar
%
%   Applies a head-related transfer function to an input 
%   monoaural audio track using a HRIR obtained from
%   MIT media lab's measurements, as documented in get_hrir.m
%
%   Input parameters
%           x: Input signal
%           fs: sample rate of x in samples per second
%           theta: angle (in degrees) in plane around head
%           phi: angle (in degreees) of elevation
%   Returns:
%           y: [r l] stereo track in 3D for headphones
%--------------------------------------------------------------------
function [y] = hrtf_kemar(x, fs, theta, phi);
 
% get closest matching HRIR
h = get_hrir(theta, phi);
 
% convolve and return input with hrir
y(:,1) = conv(x, h(:,1));
y(:,2) = conv(x, h(:,2));
