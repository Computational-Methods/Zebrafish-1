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

% Get Duration of video and multiply it by 100 to get into ms
time = videoReader.Duration;
duration = time*100; %13.85*100=1385
average_current = zeros(1,duration);
average_previous = zeros(1,duration);

Diff = zeros(duration);
average_current = zeros(1,duration);
average_previous = zeros(1,duration);
while hasFrame(videoReader)
    % Saves previous frame as the previous data
    if k > 0
        subset_previous = frame(region(1):region(1)+region(3),region(2):region(2)+region(4),:);
        average_previous(1,k) = mean(double(subset_previous), 'all');
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
   k = k+1;
   average_current(1,k) = mean(double(subset_current), 'all');
   
   % Getting the diff values for each frame
   placeholder = diff(subset_current);
   velocity(k) = mean(double(placeholder), 'all')./time;

end

delete(figure)

plot(velocity)





% Use find peaks to get time on plot
