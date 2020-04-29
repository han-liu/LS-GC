function P = Grow()
% BFS using FIFO until path P connecting s->t is found
global Parent Tree Active
P = [];
while sum(Active)>0 
    p = FIFOFront();
    if Active(p)==0
        FIFOPop();
    else
        [neibs, caps] = EdgeFunc(p, 1);
        for i = 1:length(neibs)
            q = neibs(i);
            if caps(i) > 0
                if Tree(q) == 0
                    Tree(q) = Tree(p);
                    Parent(q) = p;
                    FIFOInsert(q);
                    Active(q) = 1;
                elseif Tree(q) ~= Tree(p)
                    P = TracePath(p, q);
                    return;
                end 
            end
        end
        FIFOPop();
        Active(p) = 0;
    end
end
end