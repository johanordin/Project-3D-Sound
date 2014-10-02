function static_noise_TD(ang)
%ang is an angle decided by user, that is the direction user want to 
%hear the sound
a=-1;
b=1;% (a,b) is the range of random numbers
load('HRIRs_0el_IRC_subject59.mat');%get HRIRs

%get the HRIRs in specific direction: ang degree
HRIR_L=HRIR_set_L((ang+15)/15,:);
HRIR_R=HRIR_set_R((ang+15)/15,:);

%generate a noise signal, range of it is (a,b)=(-1,1)
sound=a+(b-a).*rand(1,Fs,'double');

%[sound, Fs] = audioread('Lion.mp3');

%convolves noise and HRIRs in time domain
L_TD=conv(HRIR_L,sound);
R_TD=conv(HRIR_R,sound);

% %plot the noise on the time axes
% figure(1);
% t=(1:length(noise))./Fs;
% plot(t,noise);
% grid on;
% title('noise signal');
% ylabel('Amplitude');
% xlabel('time/s');
% axis([0 1 -1 1]);
% 
% %plot the noise again in a suitable scale
% figure(2);
% plot(t,noise);
% grid on;
% title('noise signal');
% ylabel('Amplitude');
% xlabel('time/s');
% axis([0 0.001 -1 1]);
% 
% %plot sound on both channels in the same axes
% figure(3);
% t=(1:length(L_TD))./Fs;
% plot(t,L_TD,'g',t,R_TD,'r');
% grid on;
% title('audio output');
% ylabel('Amplitude');
% xlabel('time/s');
% axis([0 0.01 -4 4]);

%play the noise
noise_burst_TD=[L_TD' R_TD'];
audioplayer(noise_burst_TD,Fs);
%store in file
audiowrite('noise_TD.wav',noise_burst_TD,Fs);
end