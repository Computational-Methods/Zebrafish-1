function [heartbeats, heart_rate_bps, heart_rate_bpm]= Zebrafish_Heart_Rate_Analysis(video)
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
disp ('On the video click and drag to select a rectangular shaped ROI covering a small portion of the heart that visibly contracts: ')

% Get Duration of video and multiply it by 100 to get into 1/100 of a
% second.
time = videoReader.Duration;
duration = round(time*100,0); 
time_vector = [0:1:duration-1];

% Initializing the vectors and variables
diff_mean_bright = zeros(1,duration);
k = 0;

% Playing the video
while hasFrame(videoReader)
   frame = readFrame(videoReader);
   step(videoPlayer,frame);
   
% Code to select region of interest on first frame of video
   if k == 0
        region = round(getPosition(imrect));
        disp('Calculating... Please wait. Do not close the windows.')
        if region(3) > 100 || region(4) > 100
            disp('Please restart the code and select a smaller region of interest.')
            return
        end     
   end
   % Inserts the rectangle shape on each frame of the video
   insertShape(frame, 'rectangle', region);
   k = k+1;

   subset = frame(region(1):region(1)+region(3),region(2):region(2)+region(4),:);
   g_subset = rgb2gray(subset);
   diff_mean_bright(1,k) = mean(g_subset(:));


end
% Gets rid of the movie player
delete(figure)

brightness_smooth= smoothdata(diff_mean_bright)

plot(time_vector, brightness_smooth)
title('Movement in and out of ROI')
ylabel('Brightness')
xlabel('Time (.01 seconds)')

[peak,locs]= findpeaks(brightness_smooth,time_vector, 'MinPeakDistance', 28)

heartbeats = length(peak);

heart_rate_bps = heartbeats/time    % Heart Rate in beats per second
heart_rate_bpm = heart_rate_bps*60  % Heart Rate in beats per minute

msgbox(sprintf('The total number of heartbeats is %.1f \n Heart beats per second is %.2f \n Heart beats per minute is %.2f', heartbeats, heart_rate_bps,heart_rate_bpm));