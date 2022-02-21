% This function compute the Homography matrix between two planes
% It is computed thanks to the source coordinates (corners of the image to be projected),
% and the destination coordinates (where you want the transformed image to be displayed)

% Inputs:
% X_destination = x-coordinates of the corners points in the destination plane (paper sheet in the video)
% Y_destination = y-coordinates of the corners points in the destination plane
% X_source = x-coordinates of the corners points in the source plane (image to be projected)
% Y_source = y-coordinates of the corners points in the source plane

% Output:
% The Homography matrix between the source and the destination plane. It is a 3x3 transformation matrix

function H = ComputeHomographyMatrix(X_destination, Y_destination, X_source, Y_source)

    % With A the source plane and B the destination plane, we have AH=B
    % Create the empty matrix A and B to find H
    n_rows = size(X_destination, 2) * 2;
    B = zeros(n_rows, 1);
    A = zeros(n_rows, 8);

    % Fill the matrices A and B
    index = 1; % Index to access the values of X_destination, Y_destination, X_source and Y_source

    for i = 1:n_rows
        % Fill in every other row of the matrix (depends if it's x or y)
        % Start with x and then y
        if (mod(i, 2) ~= 0)
            A(i, :) = [X_destination(index), Y_destination(index), 1, 0, 0, 0, - (X_destination(index) * X_source(index)), - (Y_destination(index) * X_source(index))];
            B(i, 1) = X_source(index);
        else
            A(i, :) = [0, 0, 0, X_destination(index), Y_destination(index), 1, - (Y_source(index) * X_destination(index)), - (Y_destination(index) * Y_source(index))];
            B(i, 1) = Y_source(index);
            index = index + 1; % Increment the index every 2 turn of the loop
        end

    end

    % When we have A and B (AH=B), compute the homography matrix H with H = A \ B
    H = A \ B;
    H = [H(1) H(2) H(3);
        H(4) H(5) H(6);
        H(7) H(8) 1;
        ];
    % We write it as a 3x3 transformation matrix
end
