
%
%   Applies a 3D with headphones spatialization effect
%   of the source audio spinning around the listener. The spinning
%   is applied to both the angle relative to the frontal plane (theta)
%   and the angle of elevation (phi)
%
%   Input parameters
%           x: Input signal
%           fs: sample rate of x in samples per second
%           theta_period: period of theta rotation
%           phi_period: period of phi rotation
%           mode: hrtf mode: 'kemar' for hrir, 'model' for model.
%   Returns:
%           y: [r l] stereo track in 3D for headphones
%--------------------------------------------------------------------
function y = spin (x, fs, theta_period, phi_period, hrtfMode)
 
% set constants
%theta_rotation_period = period;         %rotation around the head in seconds
%phi_rotation_period = 10;               %elevation change (up/down) in seconds
N_theta = 40;                           %number of blocks per rotation
%N_phi = N_theta;                        %number of blocks per rotation
 
%calculate the block size
samples_per_block = fs*theta_period/N_theta;
 
%Now we can calc blocks/rotation for phi with fixed block size
N_phi = fs*phi_period/samples_per_block; %blocks per rotation
 
%create the vector of angles to be run through during the rotation period
thetas = 360*linspace(0, (N_theta-1)/N_theta,N_theta) - 180;

disp(thetas);

%phis = 180*linspace(0,(N_phi-1)/N_phi,N_phi)-90;
 phis = zeros(1,20);
 

%initialize y
y=[];
 
%initialize starting block to 1
blockStart = 1;
 
%iterate through each block
for block_num = 1:floor(length(x)/samples_per_block)
    
    %determine theta and phi indeces
    I_theta = 1+mod(block_num, N_theta);
    I_phi = 1+mod(block_num, N_phi);        %round((N_phi+1)/2);
    
    %calc block length
    blockLength = min([samples_per_block (length(x) - block_num*samples_per_block)]);
    
    %%%%
    thetas((I_theta));
    disp(phis(I_phi));
    
    
    %apply hrtf to this block for this theta and phi
    filtered_block = hrtf(x(blockStart:blockStart+blockLength-1), fs, thetas(I_theta), phis(I_phi), hrtfMode);
    
    %crossfade in new filtered block to match previous overrun (don't do on first iteration)
    if block_num ~= 1
        cross_up = linspace(0,1,overrun_length);
        filtered_block(1:overrun_length) = filtered_block(1:overrun_length).*cross_up;
    end
    
    % get sizes of vectors
    y_size = size(y);
    filtered_block_size = size(filtered_block);
    overrun_length = filtered_block_size(1) - (blockLength-1);
    
    %crossfade out overrun (from delay)
    cross_down = linspace(1,0,overrun_length);
    filtered_block(blockLength:filtered_block_size(1)) = filtered_block(blockLength:filtered_block_size(1)).*cross_down;
    
    %add filtered block to running total
    y = [y' zeros(blockStart-1+filtered_block_size(1)-y_size(1), 2)']' + [zeros(blockStart-1, 2)' filtered_block']';         %[y; temp];
 
    % increment starting sample for next block
    blockStart = blockStart+samples_per_block; 
end

