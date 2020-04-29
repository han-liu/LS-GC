function [totcapremain,totneg,totcutcap,totcuts,totcutt,totcutn] = CutCheck
global EdgeCaps Edges Edge_Lens Tree EdgeCapsO
totcapremain=0;
totneg=0;
totcutcap = 0;
totcuts = 0;
totcutt = 0;
totcutn = 0;
for i=1:length(Edge_Lens)
    if Tree(i)==1 % nlinks -- only in the s->t direction
        for j=1:Edge_Lens(i)
            p = i;
            q = Edges(i,j);
            if Tree(q)~=Tree(p)
                totcutn = totcutn + EdgeCapsO(p,j);
                totcapremain = totcapremain + EdgeCaps(p,j);
                totcutcap = totcutcap + EdgeCapsO(p,j);
            end
            if EdgeCaps(p,j)<0
                totneg = totneg + EdgeCaps(p,j);
            end
        end
    end
    if Tree(i)~=1
        totcuts = totcuts + EdgeCapsO(i,end-1);
        totcapremain = totcapremain + EdgeCaps(i,end-1);
        totcutcap = totcutcap + EdgeCapsO(i,end-1);
    end
    if Tree(i)~=2
        totcutt = totcutt + EdgeCapsO(i,end);
        totcapremain = totcapremain + EdgeCaps(i,end);
        totcutcap = totcutcap + EdgeCapsO(i,end);
    end
end
totneg = totneg + sum(EdgeCaps(:,5).*(EdgeCaps(:,5)<0));
totneg = totneg + sum(EdgeCaps(:,6).*(EdgeCaps(:,6)<0));