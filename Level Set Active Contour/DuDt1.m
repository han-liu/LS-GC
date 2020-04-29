function dudt = DuDt1(v,tau,speed,nG,kappa,G,Gspeed)
% DuDt1 is the function used to compute the level set update equation for the two Caselles methods.
% v [1 x 1] is the inflation constant
% tau [1 x 1] is the weighting parameter for the additional term in the CasellesSapiro update equation.
% speed [1 x N] are the precomputed speed function (g(x)) values at N voxel locations of interest
% nG [1 x N], kappa [1 x N], and G [3 x N] are the estimates returned by ‘Curvature’ on the distance map U.
% Gspeed [3 x N] are gradients computed on the speed map at the N voxel locations of interest.
% dudt [1 x N] are the level set update amounts for the N voxel locations of interest in U.
dudt = speed .* nG .* (kappa + v) + tau * dot(G, Gspeed);
end