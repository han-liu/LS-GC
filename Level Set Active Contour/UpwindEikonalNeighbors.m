function UpwindEikonalNeighbors(node)
global Active dmap r c d
[r,c,d] =size(Active);
[i, j, k] = node2coord(node);
neibs = [i<r, i>1, j<c, j>1, k<d, k>1].*[node+1, node-1, node+r, node-r, node+r*c, node-r*c];
neibs = neibs(neibs~=0);
for n = 1:length(neibs)
    q = neibs(n);
    [x, y, z] = node2coord(q);
    if Active(x,y,z) == 1
        if x == r
            U_LR = dmap(x-1, y, z);
        elseif x == 1
            U_LR = dmap(x+1, y, z);
        else
            U_LR = min([dmap(x-1, y, z), dmap(x+1, y, z)]);
        end
        
        if y == c
            U_FB = dmap(x, y-1, z);
        elseif y == 1
            U_FB = dmap(x, y+1, z);
        else
            U_FB = min([dmap(x, y-1, z), dmap(x, y+1, z)]);
        end
        
        if d > 1
            if z == d
                U_UD = dmap(x, y, z-1);
            elseif z == 1
                U_UD = dmap(x, y, z+1);
            else
                U_UD = min([dmap(x, y, z-1), dmap(x, y, z+1)]);
            end
        else
            U_UD = inf;
        end
        
        % 1st approximation
        Us = sort([U_LR, U_FB, U_UD]);
        dist = Us(1) + 1;
        
        % 2nd approximation
        if dist > Us(2)
            dist = 0.5*(Us(1)+Us(2)+sqrt(2-(Us(2)-Us(1))^2));
            % 3rd approximation
            if dist > Us(3)
                N = length(Us);
                dist = (1/N)*(sum(Us)+sqrt(N+sum(Us)^2 - N*sum(Us.^2)));
            end
        end
        if dist < dmap(x,y,z)
            LSHeapInsert(neibs(n), dist);
            dmap(x, y, z) = dist;
        end
    end
end
end

function [x,y,z] = node2coord(node)
global r c
x = mod(node-1, r)+1;
z = floor((node-1)/(r*c))+1;
y = floor((node-1-(z-1)*r*c)/r)+1;
end