function res = GraphCut3D(sigma, lambda, Pr_s, img)
global Parent Tree Active EdgeCaps Edges Edge_Lens r c d EdgeCapsO fifo Orphans inds
fprintf('** Start 3D Graph Cut **\n')
img = double(img);
[r, c, d] = size(Pr_s);
inds = 1:(r*c*d+2);

Tree = zeros(r*c*d+2, 1);
Tree(r*c*d+1) = 1; % source node
Tree(r*c*d+2) = 2; % sink node

Parent = zeros(r*c*d+2, 1);
Active = zeros(r*c*d+2, 1);
Orphans = zeros(r*c*d+2, 1);

% Edges/EdgeCaps
nodes = [1:r*c*d]';
X = mod(nodes-1, r)+1;
Z = floor((nodes-1)/(r*c))+1;
Y = floor(((nodes-1-(Z-1)*r*c))/r)+1;

Edges = [X<r, X>1, Y<c, Y>1, Z<d, Z>1].*[nodes+1, nodes-1, nodes+r, nodes-r, nodes+r*c, nodes-r*c];
Edge_Lens = sum(Edges'>0)';
EdgeCaps = zeros(r*c*d, 8);
EdgeCaps(:, 1) = reshape((1-lambda)*exp(-[img(1:end-1,:,:)-img(2:end,:,:); img(end,:,:)].^2/(2*sigma^2)), [r*c*d, 1]);
EdgeCaps(:, 2) = reshape((1-lambda)*exp(-[img(1,:,:); img(1:end-1,:,:)-img(2:end,:,:)].^2/(2*sigma^2)), [r*c*d, 1]);
EdgeCaps(:, 3) = reshape((1-lambda)*exp(-[img(:, 1:end-1,:)-img(:, 2:end,:), img(:,end,:)].^2/(2*sigma^2)), [r*c*d, 1]);
EdgeCaps(:, 4) = reshape((1-lambda)*exp(-[img(:,1,:), img(:, 1:end-1,:)-img(:, 2:end,:)].^2/(2*sigma^2)), [r*c*d, 1]);
if d==1  % 2D image
    EdgeCaps(:, 5) = zeros(r*c*d, 1);
    EdgeCaps(:, 6) = zeros(r*c*d, 1);
else  % 3D image
    EdgeCaps(:, 5) = reshape((1-lambda)*exp(-cat(3, img(:,:,1:end-1)-img(:,:,2:end), img(:,:,end)).^2/(2*sigma^2)), [r*c*d, 1]);
    EdgeCaps(:, 6) = reshape((1-lambda)*exp(-cat(3, img(:,:,1), img(:,:,1:end-1)-img(:,:,2:end)).^2/(2*sigma^2)), [r*c*d, 1]);
end

Pr_t = 1 - Pr_s;

EdgeCaps(:,7) = lambda*(-log(Pr_t(:)'));
EdgeCaps(:,8) = lambda*(-log(Pr_s(:)'));

for i =1:r*c*d
    EdgeCaps(i, 1:Edge_Lens(i)) = EdgeCaps(i, Edges(i, 1:6)>0);
    Edges(i, 1:Edge_Lens(i)) = Edges(i, Edges(i, 1:6)>0);
end

EdgeCapsO = EdgeCaps;
FIFOInit(r*c*d);
Active(:) = 0;

% option 1
% Tree(1:r*c*d) = 0;
% FIFOInsert([r*c*d+1, r*c*d+2]);
% Active([r*c*d+1, r*c*d+2]) = 1;

% option 2 - faster intialization
msk = EdgeCaps(:,7)>EdgeCaps(:,8);
Tree(1:r*c*d) = 2-msk;
Parent(msk) = r*c*d+1;
Parent(~msk) = r*c*d+2;
FIFOInsert(1:r*c*d);
Active(1:r*c*d) = 1;

cnt = 0;
while (1)
    P = Grow();
    figure(6);
    colormap(gray(256));
    if mod(cnt, 2000)==0
        disp(cnt);
    end
    if isempty(P)
        break;
    end
    Augment(P);
    Adoption();
    cnt = cnt + 1;
end

[capacity_remaining_between_trees, ...
    capacity_lessthanzero_between_trees,...
    MinCut_MaxFlow_total] = CutCheck()

res = Tree;
fprintf('** Done **\n')
end