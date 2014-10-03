%--------------------------------------------------------------------
%   main_Spin
%
%   Test file for spin
%   Saves result to file
%
%--------------------------------------------------------------------
 
clear all;
close all;
 
%filename = 'Sounds\clock';
%filename = 'Sounds\bikehorn';
filename = 'Sounds\cow';
%filename = 'Sounds\yodelay';
 
[x fs nbits] = wavread(filename);

disp(size(x));
%pause(5)

%% model
% y = spin ([x' x' x' x']', fs, 10, 2, 'model');
%  
% wavwrite(y, fs, nbits, strcat(filename, '_spin_model'));

%% kemar
% G�r p� ljud
y = spin ( x, fs, 10, 2, 'kemar');
% G�r p� 4x orginalljudet
%y = spin ([x' x' x' x']', fs, 10, 2, 'kemar');
 
wavwrite(y, fs, nbits, strcat(filename, '_spin_kemar'));
