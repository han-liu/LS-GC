function dudt = DuDt2(mu, lambda, kappa, img, c1, c2)
% DuDt2 is the function used to compute the level set update equation for the ChanVese method.
% mu [1 x 1] is the weighting constant for the smoothness term.
% lambda [1 x 1] is the weighting parameter for the image-based term.
% kappa [1 x N] is the curvature estimate for each of the N voxel locations of interest returned by ‘Curvature’ on the distance map U.
% img [1 x N] is the image intensity for each of the N voxel locations of interest.
% c1 [1 x 1] and c2 [1 x 1] are the mean intensities in the foreground and background of the current LS segmentation.
% dudt [1 x N] are the level set update amounts for the N voxel locations of interest in U.
dudt = mu * kappa + lambda * ((img-c1).^2 - (img-c2).^2);
end