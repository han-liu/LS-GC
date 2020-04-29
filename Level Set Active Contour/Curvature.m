function [kappa, G, nG] = Curvature(I, xyz)
% I [r x c x d] is the input volume on which we want to compute kappa
% xyz [3 x N] is the set of voxel coordinates at which we want the curvature
% kappa [1 x N] is the curvature estimates for each of the N voxel locations
% G [3 x N] is gradient estimates for each voxel location returned by ‘Gradient’, i.e., Gradient should be called within Curvature.
% nG [1 x N] the norm of each of the gradient estimates.
[G, node, xf, xb, yf, yb, zf, zb] = Gradient(I, xyz);
nG = sqrt(G(1,:).^2 + G(2,:).^2 + G(3,:).^2);
V = zeros(size(G));
for i = 1:size(G,2)
    if nG(i)~=0
        V(:,i) = G(:,i)./nG(i);
    end
end
key = zeros(1, 3e8);
key(node) = 1:size(G,2);
Vxf = zeros(1, size(G,2));
Vxb = zeros(1, size(G,2));
Vyf = zeros(1, size(G,2));
Vyb = zeros(1, size(G,2));
Vzf = zeros(1, size(G,2));
Vzb = zeros(1, size(G,2));

for i = 1:size(G, 2)
    if key(xf(i))~=0
        Vxf(i) = V(1, key(xf(i)));
    end
    if key(xb(i))~=0
        Vxb(i) = V(1, key(xb(i)));
    end
    if key(yf(i))~=0
        Vyf(i) = V(2, key(yf(i)));
    end
    if key(yb(i))~=0
        Vyb(i) = V(2, key(yb(i)));
    end
    if key(zf(i))~=0
        Vzf(i) = V(3, key(zf(i)));
    end
    if key(zb(i))~=0
        Vzb(i) = V(3, key(zb(i)));
    end
end

kappa = .5 * (Vxf-Vxb+Vyf-Vyb+Vzf-Vzb);
end