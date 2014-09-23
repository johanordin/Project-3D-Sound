%--------------------------------------------------------------------
%   main_Spin
%
%   Test file for spin
%   Saves result to file
%
%--------------------------------------------------------------------
 
clear all;
close all;
 
filename = 'clock';
 
[x fs nbits] = wavread(filename);
 
y = spin ([x' x' x' x']', fs, 2, 10, 'model');
 
wavwrite(y, fs, nbits, strcat(filename, '_spin'));
