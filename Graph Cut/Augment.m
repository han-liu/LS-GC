function Augment(P)
global EdgeCaps Edges Edge_Lens Orphans Tree
if isempty(P)
    return
end
% searching for bottleneck edge capacity
bottleneckcap = min([EdgeCaps(P(2), 7), EdgeCaps(P(end-1), 8)]);
for i=2:length(P)-2
    bottleneckcap = min(bottleneckcap, EdgeCaps(P(i), Edges(P(i), 1:Edge_Lens(P(i)))==P(i+1)));
end

% source
EdgeCaps(P(2), 7) = EdgeCaps(P(2), 7)- bottleneckcap;
if EdgeCaps(P(2), 7)==0
    Orphans(P(2)) = 1;
    Parent(P(2)) = 0;
end

% sink
EdgeCaps(P(end-1), 8) = EdgeCaps(P(end-1), 8) - bottleneckcap;
if EdgeCaps(P(end-1), 8)==0
    Orphans(P(end-1)) = 1;
    Parent(P(end-1)) = 0;
end

% n-links
for j=2:length(P)-2
    p = P(j);
    q = P(j+1);
    EdgeCaps(p, Edges(p, 1:Edge_Lens(p))==q) = EdgeCaps(p, Edges(p, 1:Edge_Lens(p))==q) - bottleneckcap;
    EdgeCaps(q, Edges(q, 1:Edge_Lens(q))==p) = EdgeCaps(q, Edges(q, 1:Edge_Lens(q))==p) + bottleneckcap;
    if EdgeCaps(p, Edges(p, 1:Edge_Lens(p))==q)==0 && Tree(p)==Tree(q)
        if Tree(p) == 1
            Orphans(q)=1;
            Parent(q)=0;
        else
            Orphans(p)=1;
            Parent(p)=0;
        end
    end
end
end