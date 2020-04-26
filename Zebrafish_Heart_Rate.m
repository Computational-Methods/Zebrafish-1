function heart_rate_bpm= Zebrafish_Heart_Rate(video)
% Input the movie to the function by typing the movie as a character array
% e.g. Zebrafish_Heart_Rate('movie.mov')

videoReader = VideoReader(video);
videoPlayer = vision.VideoPlayer;

% Making the video fit the window
set(0,'showHiddenHandles','on');
figure = gcf ;  
figure.findobj; 
fitwindow = figure.findobj ('TooltipString', 'Maintain fit to window');  
fitwindow.ClickedCallback();

% ROI specification
disp ('On the video use your mouse to select a rectangular shaped ROI that covers a small portion of the atrium (bottom part of the heart): ')

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
        if region(3) > 90 || region(4) > 90
            disp('Please restart the code and select a smaller region of interest')
            return
        end     
   end
   % Inserts the rectangle shape on each frame of the video
   insertShape(frame, 'rectangle', region);
   
   subset_current = frame(region(1):region(1)+region(3),region(2):region(2)+region(4),:);
   if k >= 1
        g_subset_previous = rgb2gray(subset_previous);
        g_subset_current = rgb2gray(subset_current);
        subset_cat = cat(3, g_subset_previous, g_subset_current);
        diff_max_vel(1,k) = mean(double(diff(subset_cat,1,3)), 'all');
   end
   k = k+1;

end
% Gets rid of the movie player
delete(figure)

% Finds time between peaks
peaks = findpeaks(average_current);
distance = diff(peaks);
time_between = distance./100;



plot(time_vector, diff_max_vel)

[peak2,locs]= findpeaks(diff_max_vel,time_vector,'MinPeakProminence',.08);

heartbeats = length(peak2)/2

Heart_Rate_bps = heartbeats/time    % Heart Rate in beats per second
Heart_Rate_bpm = Heart_Rate_bps*60  % Heart Rate in beats per minute