function [neibs, caps] = EdgeFunc(node, dir)
global Tree EdgeCaps Edges Edge_Lens r c d
% t-link
if node==r*c*d+1
    neibs = find(EdgeCaps(:,7)>0);
    caps = EdgeCaps(neibs, 7);
elseif node == r*c*d+2
    neibs = find(EdgeCaps(:,8)>0);
    caps = EdgeCaps(neibs, 8);
% n-link
else
    neibs = [Edges(node, 1:Edge_Lens(node)), r*c*d+1, r*c*d+2];
    caps = zeros(size(neibs));
    if (Tree(node) == 1 && dir==1) || (Tree(node) == 2 && dir==-1)
        caps(1:end-2) = EdgeCaps(node, Edges(node,  1:Edge_Lens(node))==neibs(1:end-2));
        caps(end-1:end) = EdgeCaps(node, 7:8);
    end

    if (Tree(node) == 2 && dir==1) || (Tree(node) == 1 && dir==-1)
        for i =1:length(neibs)-2
            caps(i) = EdgeCaps(neibs(i), Edges(neibs(i), 1:Edge_Lens(neibs(i)))==node);
        end
        caps(end-1:end) = EdgeCaps(node, 7:8);
    end
end 