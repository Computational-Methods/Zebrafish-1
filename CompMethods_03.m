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

indices = zeros(region(3),region(4));
vid_width = videoReader.width;

% Code to find indices of region of interest. **I'm not sure if this code
% works, the numbers seem too large in the indices matrix. Please review.
for j = 1:region(3)
    for k = 1:region(4)
        indices(j,k) = region(1)+ k - 1 + ((vid_width - region(3))*(j-1));
    end
end

% We will want to use the diff function on the indeces defined by the
% region of interest


