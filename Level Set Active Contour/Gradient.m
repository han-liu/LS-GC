function [G,node,xf,xb,yf,yb,zf,zb] = Gradient(I, xyz)
% I [r x c x d] is the input volume on which we want to compute ??
% xyz [3 x N] is the set of voxel coordinates at which we want the gradient
% G [3 x N] are the xyz gradients for N voxel locations.
% The rest of the outputs are [1 x N] and represent the node numbers for 
% the voxel locations of the xyz coordinates (node) as well as the node numbers 
% for the voxel locations corresponding to the forward (f) and backward (b) 
%     gradient directions for each direction (x,y,z) for each xyz voxel location, 
%     accounting for boundary conditions. For example, most locations will have 
%     yf(i) = node(i)+r and yb(i) = node(i)-r. But if xyz(2,i)==1, 
%     then yb(i) = node(i) and yf(i) = node(i)+r. Or if xyz(2,i)==c 
%     then yb(i) = node(i)-r and yf(i) = node(i).
global r c d
[r, c, d] = size(I);
node = xyz(1,:) + (xyz(2,:)-1)*r + (xyz(3,:)-1)*r*c;
xf = node + double(xyz(1,:)~=r);
xb = node - double(xyz(1,:)~=1);
yf = node + double(xyz(2,:)~=c)*r;
yb = node - double(xyz(2,:)~=1)*r;
zf = node + double(xyz(3,:)~=d)*r*c;
zb = node - double(xyz(3,:)~=1)*r*c;
G = zeros(size(xyz));
G(1,:) = I(xf)-I(xb);
G(2,:) = I(yf)-I(yb);
G(3,:) = I(zf)-I(zb);
end
