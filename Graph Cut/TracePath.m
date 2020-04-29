function P = TracePath(p, q)
% Tree(p) = Tree(q)
% P is always a path from s->t
% p: source
% q: sink

global Parent Tree r c d
if Tree(p) == Tree(q)
    P = [];
    return;
end

P_s = zeros(r*c*d+2, 1);
i_s = 1;
P_t = zeros(r*c*d+2, 1);
i_t = 1;

if Tree(p)==1
    % p belongs to Tree 1->source
    % q belongs to Tree 2->sink
    if p==r*c*d+1
        P_s(1) = r*c*d+1;
    else
        P_s(1) = p;
        while(Parent(p)~=r*c*d+1)
            i_s = i_s + 1;
            P_s(i_s) = Parent(p);
            p = Parent(p);
        end
        P_s(i_s+1) = r*c*d+1;
        P_s = P_s(end:-1:1);
    end
    P_s = P_s(P_s~=0);
    
    if q==r*c*d+2
        P_t(1) = r*c*d+2;
    else
        P_t(1) = q;
        while(Parent(q)~=r*c*d+2)
            i_t = i_t + 1;
            P_t(i_t) = Parent(q);
            q = Parent(q);
        end
        P_t(i_t+1) = r*c*d+2;
    end
    P_t = P_t(P_t~=0);
    P = [P_s; P_t];

else
    % p belongs to Tree 2->sink
    % q belongs to Tree 1->source
    if q==r*c*d+1
        P_s(1) = r*c*d+1;
    else
        P_s(1) = q;
        while(Parent(q)~=r*c*d+1)
            i_s = i_s + 1;
            P_s(i_s) = Parent(q);
            q = Parent(q);
        end
        P_s(i_s+1) = r*c*d+1;
        P_s = P_s(end:-1:1);
    end
    P_s = P_s(P_s~=0);
    
    if p==r*c*d+2
        P_t(1) = r*c*d+2;
    else
        P_t(1) = p;
        while(Parent(p)~=r*c*d+2)
            i_t = i_t + 1;
            P_t(i_t) = Parent(p);
            p = Parent(p);
        end
        P_t(i_t+1) = r*c*d+2;
    end
    P_t = P_t(P_t~=0);
    
    P = [P_s; P_t];
end
end