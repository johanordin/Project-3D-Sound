%--------------------------------------------------------------------
%   hrtf
%
%   Applies a head-related transfer function to an input 
%   monoaural audio track, using either measured HRIR (see
%   get_hrir.m for details), or using head/torso/pinna model,
%   depending on input mode specified
%
%   Input parameters
%           x: Input signal
%           fs: sample rate of x in samples per second
%           theta: angle (in degrees) in plane around head
%           phi: angle (in degreees) of elevation
%           mode: hrtf mode: 'kemar' for hrir, 'model' for model.
%   Returns:
%           y: [r l] stereo track in 3D for headphones
%--------------------------------------------------------------------
function [y] = hrtf(x, fs, theta, phi, mode);
 
%switch on mode, calling appropriate hrtf function
if ( strcmp(mode, 'kemar') )
    y = hrtf_kemar(x, fs, theta, phi);
elseif ( strcmp(mode, 'model') )
    y = hrtf_model(x, fs, theta, phi);
else
    y = x; %if no match, return input
end;
