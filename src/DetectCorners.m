% This function detects the corners of the paper sheet in a frame of the video

% Inputs :
% frame = A frame from the video
% LastTwoCornersDetected = Matrix containing the corners detected on the last 2 frames (acts like a queue)
%                          When received as input in the function, this matrix is defined as :
%                            [
%             Corner 1 -->   x_(t-1) y_(t-1) x_(t-2) y_(t-2)
%                            ....
%             Corner n -->   x_(t-1) y_(t-1) x_(t-2) y_(t-2)
%                            ]

% Output :
% LastTwoCornersDetected = The updated corners matrix with corners at t and t-1 instead of t-1 and t-2
function LastTwoCornersDetected = DetectCorners(frame, LastTwoCornersDetected)

    % Compute the luminance of the image
    R = frame(:, :, 1);
    G = frame(:, :, 2);
    B = frame(:, :, 3);
    % Grayscale version of the image
    grayscaleFrame = (0.299 * R) + (0.587 * G) + (0.114 * B);

    % Init the scale parameters :

    % Scale parameter of the gradient
    sigmaG = 2;
    % Scale parameter 1 of the covariance matrix
    sigmaC1 = 3;
    % Scale parameter 2 of the covaraince matrix
    sigmaC2 = 5;

    % Apply the multi scale harris corner detector to the grayscale image
    detectorResult = MultiScaleHarrisDetector(grayscaleFrame, sigmaG, sigmaC1, sigmaC2);

    % Size of the window for the search of the local maxima
    window = 37;

    n_corners = size(LastTwoCornersDetected, 1);

    % For each corner, predict it's next position
    for i = 1:n_corners

        % To find the next position of a corner, we use a linear tracking method
        % It consists in a linear prediction taking into account the corners of the two previous images

        % We obtain the linear prediction of the position X and Y of a corner in the image
        % at time t as follows:
        %                     xt = x_(t-1) + (x_(t-1) - x_(t-2))/2
        %                     yt = y_(t-1) + (y_(t-1) - y_(t-2))/2

        % with xt_1 the x position at time t-1 and xt_2 the x position at time t-2 :
        xt_1 = LastTwoCornersDetected(i, 1);
        yt_1 = LastTwoCornersDetected(i, 2);
        xt_2 = LastTwoCornersDetected(i, 3);
        yt_2 = LastTwoCornersDetected(i, 4);

        % Prediction of the x and y position at time t :
        X = xt_1 + floor((xt_1 - xt_2) / 2); % xt_1 = xt-1
        Y = yt_1 + floor((yt_1 - yt_2) / 2);

        % Find the real corner around this prediction by finding the local maxima in a window
        [X, Y] = LocalMaxima(detectorResult, Y, X, window);

        % Maj des LastTwoCornersDetected
        % les t-2 sont remplacés par les t-1, et les t-1 sont remplacés par les
        % t qu'on vient de calculer

        % Update the LastTwoCornersDetected matrix by reaplacing the t-2 corners by the t-1 corners
        % and the t-1 corners by the corners that has just been computed (acts like a queue)

        LastTwoCornersDetected(i, 3) = LastTwoCornersDetected(i, 1);
        LastTwoCornersDetected(i, 4) = LastTwoCornersDetected(i, 2);

        LastTwoCornersDetected(i, 1) = Y;
        LastTwoCornersDetected(i, 2) = X;
    end

end
