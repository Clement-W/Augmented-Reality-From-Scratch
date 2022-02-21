% This function draw a 3D structure on a frame of the video

% Inputs:
% imgVideo = A frame from the video, on which we draw a 3d structure
% X2D = The x coordinates of the selected points on the video (corners of the paper sheet + corners of the lego structures displayed on the sheet)
% Y2D = The y coordinates of the selected points on the video
% numFrame = The number of the frame that is processed (used to create the movment of the structure as a function of time)

% Output :
% imgVideo = The same frame but with a 3d structure drawn on it

function imgVideo = Draw3DStructure(imgVideo, X2D, Y2D, numFrame)

    % X,Y,Z coordinates of the points of the 3D structure (little boat)
    % (The structure was created with a pencil on paper)
    X = [0.25 0.4375 0.625 0.4375 0.23 0.4375 0.645 0.4375 0.4375 0.4375 0.6 0.4375];
    Y = [0.5 0.375 0.5 0.625 0.5 0.375 0.5 0.625 0.5 0.5 0.5 0.5];
    Z = [0 0 0 0 0.2 0.2 0.2 0.2 0 1 0.4 0.4];

    % To vary the vertical position of the structure, we vary the z coordinate. To do so,
    % the z coordinate is incremented or decremented by 0.1 periodically every 30 frames.
    % So each frame, 0.1/30 = 0.00333 is added or removed to z
    if (mod(numFrame / 30, 2) >= 1)
        % We decrease the z coordinates when they reach their maximum (+0.1)
        Z = Z + 0.00333 * 29 - 0.00333 * mod(numFrame, 30);
    else
        % On augmente les Z jusqu'à 0.1
        Z = Z + 0.00333 * mod(numFrame, 30);
    end

    % Coordinates of the points of the 3D plane created on the paper sheet
    X3D = [0 1 0 1 0.55 0.125];
    Y3D = [0 0 1 1 0.45 0.5];
    Z3D = [0 0 0 0 0.3 0.2];

    % Compute the matrix P to create a 3d to 2d projection matrix
    P = Compute3dTo2dProjectionMatrix(X3D, Y3D, Z3D, X2D, Y2D);

    % Projection of the points of the 3D structure to the 2d plan of the paper sheet
    Coords2D = P * [X; Y; Z; ones(1, 12)]; % 12 times 1 because there is 6 points
    Coords2D = Coords2D ./ Coords2D(3, :);

    % Draw a structure to create a little boat
    color = [255; 255; 255];
    thickness = 6;

    % Coordinates of the start and end points of the lines which form the 3D struture
    X_start = [Coords2D(1, 1) Coords2D(1, 2) Coords2D(1, 3) Coords2D(1, 4) Coords2D(1, 5) Coords2D(1, 6) Coords2D(1, 7) Coords2D(1, 8) Coords2D(1, 1) Coords2D(1, 2) Coords2D(1, 3) Coords2D(1, 4) Coords2D(1, 9) Coords2D(1, 10) Coords2D(1, 11)];
    Y_start = [Coords2D(2, 1) Coords2D(2, 2) Coords2D(2, 3) Coords2D(2, 4) Coords2D(2, 5) Coords2D(2, 6) Coords2D(2, 7) Coords2D(2, 8) Coords2D(2, 1) Coords2D(2, 2) Coords2D(2, 3) Coords2D(2, 4) Coords2D(2, 9) Coords2D(2, 10) Coords2D(2, 11)];
    X_end = [Coords2D(1, 2) Coords2D(1, 3) Coords2D(1, 4) Coords2D(1, 1) Coords2D(1, 6) Coords2D(1, 7) Coords2D(1, 8) Coords2D(1, 5) Coords2D(1, 5) Coords2D(1, 6) Coords2D(1, 7) Coords2D(1, 8) Coords2D(1, 10) Coords2D(1, 11) Coords2D(1, 12)];
    Y_end = [Coords2D(2, 2) Coords2D(2, 3) Coords2D(2, 4) Coords2D(2, 1) Coords2D(2, 6) Coords2D(2, 7) Coords2D(2, 8) Coords2D(2, 5) Coords2D(2, 5) Coords2D(2, 6) Coords2D(2, 7) Coords2D(2, 8) Coords2D(2, 10) Coords2D(2, 11) Coords2D(2, 12)];

    imgVideo = DrawLines(X_start, Y_start, X_end, Y_end, thickness, imgVideo, color);

end
