function [dmapout,nbin,nbout] = FastMarch(dmapin,maxdist,nbi,verbose)

% dmapin [r x c x d] = input distance map estimate
% maxdist [1 x 1] = the maximum distance to estimate in the narrow band
% getnb [1 x 1] is a flag for creating and returning the narrow band
% nbi [struct] is an optional input narrow band
% nbi.len [1 x 1] is the length of the narrow band
% nbi.q [3 x nbi.len] contains the xyz coordinates of the narrow band voxels
% dmapout [r x c x d] is the resulting updated distance map
% if getnb=1, nbin [struct] is the final narrow band for the foreground
% if getnb=1, nbout [struct] is the set of points in the narrow band for the background

if nargout<2
    getnb=0;
else
    getnb=1;
end
if nargin<2
    maxdist=inf;
end
    
% dmap will contain the estimated distance map
% Active gives a status for each node
%   =1 -> The distance estimate for this node is not yet finalized
%   =2 -> The distance is finalized as estimated using the ZLS border voxel
%           distance estimate.
%   =0 -> The distance is finalized as estimated using the upwind Eikonal
%           distance estimate.
global dmap Active

[r,c,d] = size(dmapin);
LSHeapInit(10000);
dmap = 3e8*ones(r,c,d);
% Initialize all foreground as active=1
Active = double(dmapin<0);

% define nb if we are outputing narrow bands
if getnb
    nb.q = zeros(2,r*c*d);
    nb.len=0;
end
% if no input narrow band, define nbi as entire image
if nargin<3 || isempty(nbi)
    nbi.q = 1:r*c*d;
    nbi.len = length(nbi.q);
end

% turn off plotting
if nargin<4
    verbose=0;
end


% Estimate ZLS border voxel distances for foreground border voxels. Push
% those voxels into the heap. Set their active status to 2.
InsertBorderVoxelsIntoHeap(dmapin,1,nbi);

% display
if verbose
    figure(2); clf;
    subplot(3,2,1);
    colormap(gray(256));
    image(dmapin(:,:,ceil(d/2))*75)
    title('Input distance map')
    hold on;
    subplot(3,2,3);
    colormap(gray(256));      
    image(dmap(:,:,ceil(d/2))*255)
    title('Distance estimates for foreground border voxels');
    hold on;
    cntr = contour(dmapin(:,:,ceil(d/2)),[0,0],'r');
end



% This while loop just pops heap nodes and runs the Upwind marching method
% Always start with the smallest distance node in the heap
[node,dist] = LSHeapPop();
%while there are nodes to process and we haven't hit our 'landmine'
%distance
while ~isempty(node)&&dist<maxdist
    if getnb
        nb.len = nb.len+1;
        nb.q(:,nb.len) = [node;dist];
    end
    if verbose
        subplot(3,2,5);
        hold off
        image(dmap(:,:,ceil(d/2))*75)
        title('Foreground distance map estimate')
        hold on;
        contour(dmapin(:,:,ceil(d/2)),[0,0],'r');
        drawnow;
    end
    
    % We've popped 'node' off the heap, so it's distance estimate is
    % finalized and it is no longer active
    Active(node)=0;
    % And we (re)estimate distances for any active=1 neighbors of 'node'
    UpwindEikonalNeighbors(node);
    % Then we get the next active=[1,2] node from the heap. It is
    % possible nodes in the heap have already been processed to active=0 
    % from a different neighbor leadint to a smaller distance estimate. So
    % we ignore those. Also, we want to not ignore Active=2 (border) nodes,
    % as they should have their neighbors processed.
    [node,dist] = LSHeapPop();
    while (~isempty(node))&&Active(node)==0
        [node,dist] = LSHeapPop();
    end
    
end

% storing foreground result
if getnb
    nbin = nb;
end
dmapinn = dmap;

%re-initializing matrices for background region
dmap = 3e8*ones(r,c,d);
Active = double(dmapin>0);

% The rest is exactly the same stuff as above but for the background.
InsertBorderVoxelsIntoHeap(dmapin,-1,nbi);

if verbose
    subplot(3,2,4);
    colormap(gray(256));      
    image(dmap(:,:,ceil(d/2))*255)
    title('Distance estimates for background border voxels');
    hold on;
    cntr = contour(dmapin(:,:,ceil(d/2)),[0,0],'r');
end


nb.len=0;
[node,dist] = LSHeapPop();
while ~isempty(node)&&dist<maxdist
    if getnb
        nb.len = nb.len+1;
        nb.q(:,nb.len) = [node;dist];
    end
    if verbose
        subplot(3,2,6);
        hold off
        image(dmap(:,:,ceil(d/2))*25)
        title('Background distance map estimate')
        hold on;
        contour(dmapin(:,:,ceil(d/2)),[0,0],'r');
        drawnow;
    end
    
    Active(node)=0;
    UpwindEikonalNeighbors(node);
    
    [node,dist] = LSHeapPop();
    while (~isempty(node))&&Active(node)==0
        [node,dist] = LSHeapPop();
    end
    
end

% combining the fore and background result into one distance map
dmapout = dmap;
dmapout(dmapin(:)<0) = -dmapinn(dmapin(:)<0);
if getnb
    nbout = nb;  
end

if verbose
    subplot(3,2,2);
    colormap(gray(256));
    image(dmapout(:,:,ceil(d/2))*75)
    title('Output distance map')
end

return;