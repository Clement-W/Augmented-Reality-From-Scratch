% This function compute the covariance matrix of the gradients by Gaussian averaging

% Inputs :
% I = Image
% sigmaG = The scale parameter of the gradient
% sigmaC = The scale parameter of the covariance

% Outputs :
% Cxx = Covariance matrix between the x gradients
% Cyy = Covariance matrix between the y gradients
% Cxy = Covariance matrix between x and y gradients
function [Cxx, Cyy, Cxy] = GradientCovarianceMatrix(I, sigmaG, sigmaC)

    % Three-sigma rule
    window = -sigmaG * 3:sigmaG * 3;

    % Windowing
    [X, Y] = meshgrid(window);

    % The Gaussian function and its partial derivatives of order n allow to define filters
    % with infinite impulse response which lead by convolution with a continuous image to an
    % estimate of the average of the image(when order n=0) or it's partial derivatives of order n

    % Here, we use the partial derivatives of the Gaussian function of order n=1 :
    Gx =- (X ./ (2 * pi * sigmaG^4)) .* exp(- (X.^2 + Y.^2) / (2 * sigmaG^2));
    Gy =- (Y ./ (2 * pi * sigmaG^4)) .* exp(- (X.^2 + Y.^2) / (2 * sigmaG^2));

    % Gradient estimation by Canny's approach
    % Convolution between the image and the filters described above
    Ix = conv2(I, Gx, 'same');
    Iy = conv2(I, Gy, 'same');

    % Gaussian function later used to apply a gaussian averaging
    G = (1 / (2 * pi * sigmaC^2)) * exp(- (X^2 + Y^2) / 2 * sigmaC^2);

    % Computation of the covariances (by gaussian averaging)
    Cxx = conv2(Ix .* Ix, G, "same");
    Cyy = conv2(Iy .* Iy, G, "same");
    Cxy = conv2(Ix .* Iy, G, "same");
    % We don't need to write it as a matrix like [Cxx Cxy ; Cxy Cyy] because it is not needed
    % in the computations made further

end
