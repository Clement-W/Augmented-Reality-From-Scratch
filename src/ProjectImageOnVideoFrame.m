% This function projects an image on the paper sheet, taking into account the hand that holds the sheet

% Inputs:
% H = Homographic matrix
% imgVideo = frame from the video
% imgToProject = image to be projected on the paper sheet in the frame of the video
% xCorners = x coordinates of the corners of the paper sheet in the frame of the video
% yCorners = y coordinates of the corners of the paper sheet in the frame of the video

% Output:
% The same frame of the video with an image projected on the paper sheet

function imgVideo = ProjectImageOnVideoFrame(H, imgVideo, imgToProject, xCorners, yCorners)

    % Width of the image to be projected
    width = size(imgToProject, 2);
    % Height of the image to be projected
    height = size(imgToProject, 1);

    % Apply the homography matrix to each pixel of a reduced area of the image (created thanks
    % to the coordinates of the corners of the paper sheet to reduce the computing time) to project
    % the image on the paper sheet, taking into account the hand that holds the sheet

    % Reduce the search area in width
    for i = min(xCorners):max(xCorners)

        % Reduce the search area in height
        for j = min(yCorners):max(yCorners)

            % Get the pixel on which the homography matrix will be applied
            coordPx = [i; j; 1];

            % Apply the homography
            projectedPixelCoords = H * coordPx;
            projectedPixelCoords = projectedPixelCoords ./ projectedPixelCoords(3);

            % x and y coordinates of the projected pixel
            y = projectedPixelCoords(2);
            x = projectedPixelCoords(1);

            % Check if the projected pixel is in the image to be projected (if yes, the
            % coordinates must be between 1 and the max dimension)
            if (x >= 1) && (x <= width) && (y >= 1) && (y <= height)

                % Check if the projected pixel is in the hand that hold the paper sheet. The pixel is not
                % projected on the paper sheet
                if (x > 0.75 * width && x < width && y > 0.10 * height && y < 0.75 * height)

                    R = imgVideo(j, i, 1);
                    G = imgVideo(j, i, 2);
                    B = imgVideo(j, i, 3);

                    % Convert to YCbCr
                    Y = 0.299 * R + 0.587 * G + 0.114 * B;
                    %Cb = 0.564*(B-Y)+128;
                    Cr = 0.713 * (R - Y) + 128;

                    % If the red chrominance is greater than 130, then we consider that the pixel
                    % belongs to the hand, and we continue to the next pixel
                    if (Cr > 130)
                        continue
                    end

                end

                % If the pixel belongs to the paper sheet, a bilinear interpolation is
                % performed to compute the intensity of the pixel using its 2 closest neighbors
                % in each direction

                % Coordinates of the 4 neighbors
                X11 = [floor(y), floor(x)];
                X21 = [ceil(y), floor(x)];
                X12 = [floor(y), ceil(x)];
                X22 = [ceil(y), ceil(x)];

                % compute alpha and beta
                alpha = y - X11(1);
                beta = x - X11(2);

                % Bilinear interpolation
                intensity = (1 - alpha) * (1 - beta) * imgToProject(X11(1), X11(2), :) + (1 - alpha) * beta * imgToProject(X12(1), X12(2), :) + alpha * (1 - beta) * imgToProject(X21(1), X21(2), :) + alpha * beta * imgToProject(X22(1), X22(2), :);

                % Change the intensity of the pixel
                imgVideo(j, i, :) = intensity;

            end

        end

    end

end
