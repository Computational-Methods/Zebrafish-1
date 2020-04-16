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
Diff = zeros(1385);
average_current = zeros(1385);
average_previous = zeros(1385);
while hasFrame(videoReader)
    % Saves previous frame as the previous data
    if k > 0
        subset_previous = frame(region(1):region(1)+region(3),region(2):region(2)+region(4),:);
        average_previous(k) = mean(double(subset_previous));
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
   average_current(k+1) = mean(double(subset_current));
   k = k+1;
end



% We will want to use the diff function on the indeces defined by the
% region of interest. Diff used to find velocity of blood


% Use find peaks to get time on plot
