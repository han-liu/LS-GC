function DisplayMesh(M, varargin)
numvarargs = length(varargin);
if numvarargs > 2
    error('Error. Too many optional input arguments');
end
optargs = {[1, 0, 0], 1};
optargs(1:numvarargs) = varargin;
[color, opacity] = optargs{:};
% clf;
rotate3d on;
p = patch(M);
set(p, 'FaceColor', color, 'EdgeColor', 'none', 'FaceAlpha', opacity);
daspect([1,1,1]);
axis vis3d;
if isempty(findobj(gcf, 'Type', 'Light'))
    camlight headlight;
end
end