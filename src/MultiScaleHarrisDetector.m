% This function uses 2 Harris corner detectors with 2 different scales,
% and uses them to create a Multi-scale Harris detector defined as :
% D = min(D1*|D2| , |D1|*D2)

% Inputs :
% I = Image
% sigmaG = The scale parameter of the gradient
% sigmaC1 = The scale parameter 1 of the covariance
% sigmaC2 = The scale parameter 2 of the covariance

% Output :
% D = The result of the Mutli-scale Harris corner detector formula (described above)

function D = MultiScaleHarrisDetector(I, sigmaG, sigmaC1, sigmaC2)

    D1 = HarrisCornerDetector(I, sigmaG, sigmaC1);
    D2 = HarrisCornerDetector(I, sigmaG, sigmaC2);

    D = min(D1 .* abs(D2), abs(D1) .* D2);
end
