% This function returns the local maxima of the values of a detector within a given window
% This is used in order to detect a corner

% Inputs :
% D = Result of the corner detector (Multiscale harris detector here)
% x = x-coordinate of a point around which the local maximum is searched (here, it will be the last corner predicted)
% y = y-coordinate of a point around which the local maximum is searched (here, it will be the last corner predicted)
% window = search area of the local maxima

% Outputs :
% xMax = The x position of the pixel with the highest value within the window
% yMax = The y position of the pixel with the highest value within the window

function [xMax, yMax] = LocalMaxima(D, x, y, window)

    % Init variables
    max = D(x, y);
    xMax = x;
    yMax = y;
    f = floor(window / 2);

    % In a square of height and width set by the window around the point of
    % coordinates (x, y), we look for the one with the highest detector value (to find a corner)

    % TODO: Write it better
    for i = x - f:x + f

        for j = y - f:y + f

            if D(i, j) > max
                max = D(i, j);
                xMax = i;
                yMax = j;
            end

        end

    end

end
