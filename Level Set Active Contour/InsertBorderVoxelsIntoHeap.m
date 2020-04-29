function InsertBorderVoxelsIntoHeap(dmapi,direction,nbi)
% dmapi [r x c x d] is the initial distance map estimate
% direction [1 x 1] is +1 or -1 indicating processing the fore or
%       background border voxels
% nbi defines the narrow band around the ZLS
% This function estimates distances for border voxels, pushes those border
% voxels into the LS heap, and sets their active status to '2'.

global dmap Active
% voxsz is code needed to account for anisotropic voxel size.
voxsz = [1,1,1];
[r,c,d] = size(dmapi);
if nargin<3
    nbi=[];
end
% if no narrow band provided, set it to the whole image
if isempty(nbi)
    nbi.q = 1:r*c*d;
    nbi.len = length(nbi.q);
end
for h=1:nbi.len
    i = mod( nbi.q(1,h)-1,r)+1;
    k = floor((nbi.q(1,h)-1)/(r*c))+1;
    j = floor((nbi.q(1,h)-1-(k-1)*r*c)/r)+1;
    if dmapi(i,j,k)*direction<=0 % inside desired region
        if dmapi(i,j,k)==0
            i=i;
        end
        plus = dmapi(i,j,k)*[1,1,1];
        if i<r
            plus(1) = dmapi(i+1,j,k);
        end
        if j<c
            plus(2) = dmapi(i,j+1,k);
        end
        if k<d
            plus(3) = dmapi(i,j,k+1);
        end
        minus = dmapi(i,j,k)*[1,1,1];
        if i>1
            minus(1) = dmapi(i-1,j,k);
        end
        if j>1
            minus(2) = dmapi(i,j-1,k);
        end
        if k>1
            minus(3) = dmapi(i,j,k-1);
        end
        weight=0;
        cnt=0;
        for l=1:3
            d1 = 2*voxsz(l);
            d2 = 2*voxsz(l);
            if plus(l)*direction>0 % outside desired region
                d1 = dmapi(i,j,k)*voxsz(l)/(dmapi(i,j,k)-plus(l));  % always positive and <=1
            end
            if minus(l)*direction>0 % outside desired region
                d2 = dmapi(i,j,k)*voxsz(l)/(dmapi(i,j,k)-minus(l));
            end
            ndist = min([d1,d2]);
            if ndist < 2*voxsz(l)
                cnt=cnt+1;
                weight = weight + 1/(ndist*ndist);
            end
        end
        if cnt>0 
            % This is a border voxel of the desired region, so we have a
            % valid distance estimate for it. We need to push this node
            % into our heap and set its active status to '2'.
            ndist = 1/sqrt(weight);
            LSHeapInsert(i+(j-1)*r+(k-1)*r*c,ndist);
            dmap(i,j,k) = ndist;
            Active(i,j,k) = 2;
        end       
    end
end
return;