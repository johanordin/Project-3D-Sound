%
%   Applies a 3D with headphones spatialization effect
%   of the source audio spinning around the listener. The spinning
%   is applied to both the angle relative to the frontal plane (theta)
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
function y = spin (x, fs, theta_period, hrtfMode)
 
% set constants
%theta_rotation_period = period;         %rotation around the head in
theta_period = 10;
N_theta = 100;                           %number of blocks per rotation

fprintf('Theta period(rotation)\t\t\t: %i\n', theta_period);
fprintf('Number of blocks per rotation\t: %i\n', N_theta);

%calculate the block size
samples_per_block = fs*theta_period/N_theta;

fprintf('Sampels per block ->(size)\t\t: %i\n', N_theta);

%create the vector of angles to be run through during the rotation period
thetas = 360*linspace(0, (N_theta-1)/N_theta,N_theta) - 180;

fprintf('Length of the vector\t\t\t: %i\n', length(thetas));
fprintf('The vector of angles\t\t\t: %f\n', thetas);

phis = zeros(1,length(thetas));
 
%initialize y
y=[];
 
%initialize starting block to 1
blockStart = 1;

%loopen går till
Block_end = floor(length(x)/samples_per_block);
fprintf('Loopen går mellan\t\t\t 1 och %i\n', Block_end );


%iterate through each block
for block_num = 1:floor(length(x)/samples_per_block)
    
    fprintf('------------------------------\n');
    fprintf('>> Inuti loopen -> varv nr: %i\n', block_num);
    
    %determine theta indeces
    I_theta = 1+mod(block_num, N_theta);
    fprintf('Theta indeces\t\t: %i\n', I_theta);
    
    %calc block length
    blockLength = min([samples_per_block (length(x) - block_num*samples_per_block)]);
    fprintf('Block length\t\t: %f\n', blockLength);
    
    %The theta angle
    fprintf('Theta angle\t\t\t: %f\n', thetas(I_theta));
    pause(5)
    
    %apply hrtf to this block for this theta and phi
    filtered_block = hrtf(x(blockStart:blockStart+blockLength-1), fs, thetas(I_theta), phis(I_theta), hrtfMode);
    
    %crossfade in new filtered block to match previous overrun (don't do on first iteration)
    if block_num ~= 1
        cross_up = linspace(0 ,1 ,overrun_length);
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

