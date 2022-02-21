% This function draws several lines using the coordinatesof the start and end points

% Inputs:
% X_start = The x coordinates of the starting points of the lines
% Y_start = The y coordinates of the starting points of the lines
% X_end = The  x coordinates of the ending points of the lines
% Y_end = The y coordinates of the ending points of the lines
% thickness = The thickness of the lines drawn
% image = The image on which the line is drawn
% color = The color of the line

% Output:
% The image on which the lines were drawn

function image = DrawLines(X_start, Y_start, X_end, Y_end, thickness, image, color)

    alpha = 1.5;
    L = round(alpha * sqrt((X_end - X_start).^2 + (Y_end - Y_start).^2));
    % L = The number of pixels (points) that are colored for each lines

    % Compute n, the orthogonal normed vector to the segment Start-End
    nx =- (Y_end - Y_start) ./ sqrt((X_end - X_start).^2 + (Y_end - Y_start).^2);
    ny = (X_end - X_start) ./ sqrt((X_end - X_start).^2 + (Y_end - Y_start).^2);

    % Draw each line
    for k = 1:length(X_start)

        % Draw several lines on each side of the main line to create a thicker line
        for j = -round(thickness / 2):round(thickness / 2)

            % Trace L points which form a line
            for i = 1:L(k)
                x = round(X_start(k) + (i / L(k)) .* (X_end(k) - X_start(k)) + (nx(k) * j));
                y = round(Y_start(k) + (i / L(k)) .* (Y_end(k) - Y_start(k)) + (ny(k) * j));

                image(y, x, 1) = color(1);
                image(y, x, 2) = color(2);
                image(y, x, 3) = color(3);
            end

        end

    end

end
