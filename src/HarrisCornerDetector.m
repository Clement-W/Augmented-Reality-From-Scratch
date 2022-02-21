% This function apply the Harris corner detector to the image
% We first compute the covariance matrix of the image's gradients by Gaussian averaging
% Then, we apply the Haris corner detector formula :
% D(x,y) = Det(Cov(x,y)) - k*Trace(Cov(x,y))^2
% also equal to D(x,y) = (Cxx*Cyy - Cxy*Cxy) - k*(Cxx+Cyy)
% Then, when D is :
%           * positive : corner detected
%           * close to 0 : homogeneous region detected
%           * negative : contour detected

% Inputs :
% I = Image
% sigmaG = The scale parameter of the gradient
% sigmaC = The scale parameter of the covariance

% Output :
% D = The result of the Harris corner detector formula (described above)

function D = HarrisCornerDetector(I, sigmaG, sigmaC)

    % Compute the covariance matrix of the gradients by Gaussian averaging
    [Cxx, Cyy, Cxy] = GradientCovarianceMatrix(I, sigmaG, sigmaC);

    % factor
    k = 0.05;

    % Compute the Harris corner detector formula
    % D(x,y) = Det(Cov(x,y)) - k*Trace(Cov(x,y))^2
    D = (Cxx .* Cyy) - (Cxy .* Cxy) - k * (Cxx + Cyy).^2;

end
