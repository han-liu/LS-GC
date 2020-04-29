function out = TracePath2(p)
% returns boolean if a path can be found from the given node p to its head
global Parent Tree r c d
if Tree(p)==1
    head = r*c*d+1;
elseif Tree(p)==2
    head = r*c*d+2;
else 
    out = false;
    return;
end

while p ~= head    
    p = Parent(p);
    if p ==0
        out = false;
        return;
    end
end 
out = true;
end