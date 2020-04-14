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
while hasFrame(videoReader)
   frame = readFrame(videoReader);
   step(videoPlayer,frame);
% Code to select region of interest on first frame of video
   if k == 0
        region = round(getPosition(imrect));
        k= k+1;
   end
   insertShape(frame, 'rectangle', region);
end

subset = frame(region(1):region(1)+region(3),region(2):region(2)+region(4),:);


% We will want to use the diff function on the indeces defined by the
% region of interest

Diff = diff(subset);

