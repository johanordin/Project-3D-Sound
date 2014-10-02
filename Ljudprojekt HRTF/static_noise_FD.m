function static_noise_TD(ang)
%ang is an angle decided by user, that is the direction user want to 
%hear the sound
a=-1;
b=1;% (a,b) is the range of random numbers
load('HRIRs_0el_IRC_subject59.mat');%get HRIRs

%generate a noise signal, range of it is (a,b)=(-1,1)
%noise=a+(b-a).*rand(1,Fs,'double');   
    
%get the HRIRs in specific direction: ang degree
HRIR_L=HRIR_set_L((ang+15)/15,:);
HRIR_R=HRIR_set_R((ang+15)/15,:);

[noise, Ts] = audioread('Lion.mp3');

HRIR_L=HRIR_set_L((ang+15)/15,:);

%Utöka så de blir samma längd och fyll ut med zeros
frame = length(HRIR_L);
frame_size = length(noise) - frame;

myVec_L = HRIR_L;
myVec_R = HRIR_R;

myVec_L(end+frame_size)=0;
myVec_R(end+frame_size)=0;

%Transponat
myVec_L = myVec_L.';
myVec_R = myVec_R.';

%convolves noise and HRIRs in time domain
L_FD=real(ifft(fft(myVec_L) .* fft(noise)));
R_FD=real(ifft(fft(myVec_R) .* fft(noise)));

%play the noise
noise_burst_FD=[L_FD R_FD];

length(noise_burst_FD)
audioplayer(noise_burst_FD,Fs);
%store in file
audiowrite('Lion_.wav',noise_burst_FD,Fs);


%-------------------------------------------------------%
%Olika plots

%plot the noise on the time axes
figure(1);
t=(1:length(noise))./Fs;
plot(t,noise);
grid on;
title('noise signal');
ylabel('Amplitude');
xlabel('time/s');
axis([0 5 -5 5]);

%plot sound left and right
figure(3);
t=(1:length(L_FD))./Fs;
plot(t,L_FD);
grid on;
title('audio output left');
ylabel('Amplitude');
xlabel('time/s');
axis([0 5 -5 5]);

figure(4);
t=(1:length(R_FD))./Fs;
plot(t,R_FD);
grid on;
title('audio output right');
ylabel('Amplitude');
xlabel('time/s');
axis([0 5 -5 5]);

%plot sound both channelse
figure(5);
t=(1:length(noise_burst_FD))./Fs;
plot(t,noise_burst_FD);
grid on;
title('audio left and right');
ylabel('Amplitude');
xlabel('time/s');
axis([0 5 -5 5]);

end