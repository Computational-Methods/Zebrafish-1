%% Computational Methods Final Project

%%
clear,clc 

% Intializing Video Objects
video = 'Zebrafish.mov';
videoReader = VideoReader(video)
videoPlayer = vision.VideoPlayer

% Making the video fit the window
set(0,'showHiddenHandles','on')
figure = gcf ;  
figure.findobj 
fitwindow = figure.findobj ('TooltipString', 'Maintain fit to window');  
fitwindow.ClickedCallback()  

% Playing the video
k = 0;

% Get Duration of video and multiply it by 100 to get into 1/100 of a
% second.
time = videoReader.Duration;
duration = time*100; %13.85*100=1385 ms
average_current = zeros(1,duration);
average_previous = zeros(1,duration);
time_vector = [0:1:duration-1];

% Initializing the vectors
diff_max_vel = zeros(1,duration);
average_current = zeros(1,duration);
average_previous = zeros(1,duration);

while hasFrame(videoReader)
    % Saves previous frame as the previous data
    if k > 0
        subset_previous = frame(region(1):region(1)+region(3),region(2):region(2)+region(4),:);
    end
    
   frame = readFrame(videoReader);
   step(videoPlayer,frame);
   
% Code to select region of interest on first frame of video
   if k == 0
        region = round(getPosition(imrect));
   end
   % Inserts the rectangle shape on each frame of the video
   insertShape(frame, 'rectangle', region);
   
   subset_current = frame(region(1):region(1)+region(3),region(2):region(2)+region(4),:);
   if k >= 1
        g_subset_previous = rgb2gray(subset_previous);
        g_subset_current = rgb2gray(subset_current);
        subset_cat = cat(1, g_subset_previous, g_subset_current);
        diff_max_vel(1,k) = mean(double(diff(subset_cat)), 'all');
   end
   k = k+1;

end
% Gets rid of the movie player
delete(figure)

% Finds time between peaks
peaks = findpeaks(average_current);
distance = diff(peaks);
time_between = distance./100;


%% TESTING SECTION- Plot and finding peaks

% In this section I have just been messing around with the time_vector and
% velocity vector that we found from before in an attempt to see if those
% values can allow us to recognize where there is a heart beat.  I tried
% using the value of .07 as a baseline for the speed where the heart moves
% into the ROI and then moves out.  Looking at the plot visually it looks
% like there are roughly 44-45 peaks but that is up for interpretation
% which is bad haha.  But if that is true and each peak measures when the
% heart moves into and then out of the ROI that would be good because
% watching the video I count 22 beats during the 13 second video which
% would match up with the 44 peaks...  Unfortunately using findpeaks on the
% velocity variable gave me 92 peaks that were above the .07 threshold.

test_vector= ones(length(time_vector));

test_vector= test_vector.*.7;

plot(time_vector, diff_max_vel, time_vector, test_vector)
% locs is the indices of each maximum
% MinPeakProminence makes it so maxima have to be at least .08 higher than
% the other peaks -Brendan
[peak2,locs]= findpeaks(diff_max_vel,time_vector,'MinPeakProminence',.08)
% On my code this reduced it from 290 to 46 columns of peak2.

% Find number of heart beats
heartbeats = length(peak2)/2;

Heart_Rate_bps = heartbeats/time    % Heart Rate in beats per second
Heart_Rate_bpm = Heart_Rate_bps*60  % Heart Rate in beats per minute

% Probably don't need this stuff so I commented it out for now

% test_find= find(peak2 >= .7)
% 
% counter= 0
% 
% for ii= 1:length(peak2)
%     if peak2(ii)>=.7
%         counter = counter + 1;
%     end
% end
% 
% disp(counter)

%%

plot(time_between, 'or')


% Calculates average velocity and plots on graph
trend = mean(diff_max_vel);
trend_vector = ones(1, duration)*trend;

plot(time_vector, diff_max_vel,'b', time_vector, trend_vector, '-r')