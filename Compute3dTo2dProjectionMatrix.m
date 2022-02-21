% This function compute the projection matrix from a 3D plane to a 2D plane
% It is computed thanks to the source coordinates (points in the 3D plane),
% and the destination coordinates (where the points should be in the 2D plane)

% Inputs:
% X_3d = x-coordinates of the points from the 3d plane
% Y_3d = y-coordinates of the points from the 3d plane
% Z_3d = z-coordinates of the points from the 3d plane
% X_2d = x-coordinates of the points from the 2d plane
% Y_2d = y-coordinates of the points from the 2d plane

% Output:
% P = The Projection matrix between the 3d and the 2d plane. It is a 3x4 transformation matrix

function P = Compute3dTo2dProjectionMatrix(X_3d, Y_3d, Z_3d, X_2d, Y_2d)

    % With A the 3d plane and B the 3d plane, we have AP=B
    % Create the empty matrix A and B to find P
    n_rows = size(X_3d, 2) * 2;
    B = zeros(n_rows, 1);
    A = zeros(n_rows, 11);

    % Fill the matrices A and B
    index = 1; % Index to access the values of X_3d,Y_3d,Z_3d,X_2d and Y_2d

    for i = 1:n_rows
        % Fill in every other row of the matrix (depends if it's x or y)
        % Start with x and then y
        if (mod(i, 2) ~= 0)
            A(i, :) = [X_3d(index), Y_3d(index), Z_3d(index), 1, 0, 0, 0, 0, - (X_3d(index) * X_2d(index)), - (Y_3d(index) * X_2d(index)), - (Z_3d(index) * X_2d(index))];
            B(i, 1) = X_2d(index);
        else
            A(i, :) = [0, 0, 0, 0, X_3d(index), Y_3d(index), Z_3d(index), 1, - (Y_2d(index) * X_3d(index)), - (Y_3d(index) * Y_2d(index)), - (Z_3d(index) * Y_2d(index))];
            B(i, 1) = Y_2d(index);
            index = index + 1; % Increment the index every 2 turn of the loo
        end

    end

    % When we have A and B (AP=B), compute the projection matrix P with P = A \ B
    P = A \ B;
    P = [P(1) P(2) P(3) P(4);
        P(5) P(6) P(7) P(8);
        P(9) P(10) P(11) 1;
        ];

end
