%--------------------------------------------------------------------
%   main_Spin
%
%   Test file for spin
%   Saves result to file
%
%--------------------------------------------------------------------
 
clear all;
close all;
 
%filename = 'clock';
%filename = 'bikehorn';
filename = 'cow';
%filename = 'yodelay';
 
[x fs nbits] = wavread(filename);

y = spin ([x' x' x' x']', fs, 10, 2, 'kemar');
 
wavwrite(y, fs, nbits, strcat(filename, '_spin'));
