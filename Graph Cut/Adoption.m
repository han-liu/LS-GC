function Adoption()
global Parent Tree Active Orphans inds
while sum(Orphans)~=0
    orps = inds(Orphans==1);
    p = orps(1);
    Orphans(p) = 0;
    Parent(p) = 0;
    [neibs, caps] = EdgeFunc(p, -1);
    
    % searching for valid parent
    for i = 1:length(neibs)
        q = neibs(i);
        if caps(i)>0 && Tree(q)==Tree(p) && TracePath2(q)
            Parent(p) = q;
            break;
        end
    end
    
    % convert to free nodes if not adoptable
    if Parent(p)==0
        for i = 1:length(neibs)
            q = neibs(i);
            if caps(i)>0 && Tree(q)~=0 && Active(q)==0
                Active(q) = 1;
                FIFOInsert(q);
            end
            if Parent(q) == p
                Orphans(q) = 1;
                Parent(q) = 0;
            end
        end
        Active(p) = 0;
        Tree(p) = 0;
    end
end
end

