% Main process to create the final video
clear
close all

% Open the input video and take the first image
video = VideoReader('../video/inputVideo.mp4');
img = read(video, 1);
imshow(img);

% Read the image to insert
imageToProject = uint8(imread('../img/ImageToBeProjected.jpg'));
X2 = [1 size(imageToProject, 2) 1 size(imageToProject, 2)];
Y2 = [1 1 size(imageToProject, 1) size(imageToProject, 1)];

% Click on the 4 corners of the paper sheet, and on the 2 corners used to make the 3d plane
[x, y] = ginput(6);
x = round(x);
y = round(y);
cornersT0 = [x(1) y(1); x(2) y(2); x(3) y(3); x(4) y(4); x(5) y(5); x(6) y(6)];

LastTwoCornersDetected = [cornersT0, cornersT0];
% LastTwoCornersDetected contains the corners on the frames at time t-2 and t-1
% To start, this matrix is initialized with the corners at time t0 duplicated at t-2 et t-1
% To predict the next position of these corners, we need to keep track of the last corners detected
% This is why this matrix is used

% Open the video in write mode and initialize the frame counter
outputVideo = VideoWriter('../video/outputVid.avi');
open(outputVideo);
numFrame = 1;

% Process each frame
while numFrame <= video.NumFrames
    disp("process frame " + numFrame + "/" + video.NumFrames)

    % Corner detection
    imgVideo = read(video, numFrame);
    LastTwoCornersDetected = DetectCorners(imgVideo, LastTwoCornersDetected);

    % Get the current x and y corner as vectors
    xCorners = LastTwoCornersDetected(:, 1)';
    yCorners = LastTwoCornersDetected(:, 2)';

    % Replace the content of the paper sheet
    H = ComputeHomographyMatrix(xCorners(1:4), yCorners(1:4), X2, Y2);
    imgVideo = ProjectImageOnVideoFrame(H, imgVideo, imageToProject, xCorners(1:4), yCorners(1:4));

    % Add the 3D structure (little boat)
    imgVideo = Draw3DStructure(imgVideo, xCorners, yCorners, numFrame);

    writeVideo(outputVideo, imgVideo);
    numFrame = numFrame + 1;

end

% close the video
close(outputVideo);
