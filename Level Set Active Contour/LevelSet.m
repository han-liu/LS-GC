function dmap = LevelSet(img,dmap_init,method,verbose)
% img [r x c x d] is the volume to be segmented
% dmap_init [r x c x d] is the initial distance map
% method [struct] contains the method name and associated parameters
%   for the level set formulation to be used.
% verbose [1 x 1] is a flag for displaying the algorithm progression
% dmap [r x c x d] is the output distance map
if strcmp(method.name,'CasellesDibos') ||...
    strcmp(method.name,'CasellesSapiro')
    m = 1;
    alpha = method.alpha;
    mindist = method.mindist;
    sigma = method.sigma;
    v = method.inflation;
    tau = method.tau;
    beta = method.beta;
    epsilon = method.epsilon;
    maxiter = method.maxiter;
    convthrsh = method.convthrsh;
    reinitrate = method.reinitrate;
    visrate = method.visrate;
    dtt = 1;
elseif strcmp(method.name,'ChanVese')
    m = 2;
    mu = method.mu;
    lambda = method.lambda;
    reinitrate = method.reinitrate;
    visrate = method.visrate;
    maxiter = method.maxiter;
    mindist = method.mindist;
    convthrsh = method.convthrsh;
    dtt = 0.5;
end

if nargin<4
    verbose=1;
end

[r,c,d] = size(img);
slc = ceil(d/2);

% Compute speed function needed for Caselles methods
if m==1 
    if sigma~=0
        g = fspecial('gaussian',[5,5],sigma);
        imgblur = convn(img,g,'same');
    else
        imgblur = img;
    end
    
    [Y,X,Z] = meshgrid(1:c,1:r,1:d);
    gradim = Gradient(imgblur,[X(:)';Y(:)';Z(:)']);
    ngradim = reshape(sum(gradim.*gradim),[r,c,d]);
    speed = exp(-ngradim/(2*alpha^2)) - beta;
    speed(speed(:)<epsilon)=epsilon;
    gradspeed = Gradient(speed,[X(:)';Y(:)';Z(:)']);
    
end

% initialize data structures
dmap = dmap_init;
iter = 0;

nbinold.q=[];
nbinold.len=0;
nboutold.q=[];
nboutold.len=0;
nb = [];

% display
if verbose
    subplot(3,2,2);
    colormap(gray(256));
    image(127*img(:,:,slc)+127);
    title('noisy image with negative foreground');

    subplot(3,2,3);
    colormap(gray(256));
    if m==1
        image(speed(:,:,slc)*255);
        title('speed function');        
        hold on;
        quiver(reshape(gradspeed(2,(slc-1)*r*c+1:slc*r*c),[r,c]),reshape(gradspeed(1,(slc-1)*r*c+1:slc*r*c),[r,c]))
    else
        image(img(:,:,slc)*127+127);
        hold on;
    end
end
while iter<maxiter
    iter = iter+1;

    %Re-compute distance map/narrow bands
    if mod(iter-1,reinitrate)==0
        [dmap,nbin,nbout] = FastMarch(dmap,mindist,nb);    
    end
    
    % inspect changes to narrow bands for convergence criteria
    nb.q = [nbin.q(:,1:nbin.len),nbout.q(:,1:nbout.len)];
    nb.len = nbin.len+nbout.len;
    
    nbinone = nbin;
    nboutone = nbout;
    nbinone.len = sum(nbin.q(2,1:nbin.len)<=1);
    nboutone.len = sum(nbout.q(2,1:nbout.len)<=1);
    if iter>1
        err = sum(abs(-dmap(nbinold.q(1,1:nbinold.len))-nbinold.q(2,1:nbinold.len)))+...
            sum(abs(dmap(nboutold.q(1,1:nboutold.len))-nboutold.q(2,1:nboutold.len)));
        if err<convthrsh
            break;
        end    
    end

    nbinold = nbinone;
    nboutold = nboutone;
    
    % Compute curvature of U within narrow band
    xyz = zeros(3,nb.len);
    xyz(1,:) = mod(nb.q(1,1:nb.len)-1,r)+1;
    xyz(3,:) = floor((nb.q(1,1:nb.len)-1)/(r*c))+1;
    xyz(2,:) = floor((nb.q(1,1:nb.len)-1 - (xyz(3,:)-1)*r*c)/r)+1;
    [kappa,G,nG] = Curvature(dmap,xyz);
    
    cnode = nb.q(2,1:nb.len)<=1;
    node = nb.q(1,cnode);
    
    % Compute LS Update Du/Dt within narrow band.
    if m==1
        nG(nG==0)=epsilon;
        dudt = DuDt1(v,tau,speed(node),nG(cnode),kappa(cnode),...
            G(:,cnode),gradspeed(:,node));
    elseif m==2
        msk = dmap<=0;
        c1 = mean(img(msk(:)));
        c2 = mean(img(~msk(:)));
        dudt = DuDt2(mu,lambda,kappa(cnode),img(node),c1,c2);
    end
    if ~isempty(dudt)
        % Update U by |delta| <= 1
        dt = dtt/max(abs(dudt)); %% change
        dmap(node) = dmap(node) + dt.*dudt;        
        % Visualize progress if verbose
        if verbose && mod(iter-1,visrate)==0
            subplot(3,2,2);
            hold off
            image(127*img(:,:,slc)+127);
            hold on;
            contour(dmap(:,:,slc),[0,0],'r');    
            title('noisy image with negative foreground');  
            subplot(3,2,3);    
            hold on;
            contour(dmap(:,:,slc),[0,0],'r');  
            
            subplot(3,2,4);  
            hold off;
            colormap(gray(256));
            image(dmap(:,:,slc)*10+127);
            hold on;
            contour(dmap(:,:,slc),[0,0],'r');
            title(['distance map iter=',num2str(iter)])                
        
            subplot(3,2,5);
            colormap(gray(256));
            curvature = zeros(size(dmap));
            curvature(node) = kappa(cnode);
            image(curvature(:,:,slc)*500+127);      
            title('curvature');            
                
            subplot(3,2,6);
            colormap(gray(256));
            speedimg = zeros(size(dmap));
            speedimg(node) = dudt;
            image(speedimg(:,:,slc)*255+127);  
            title('DU/Dt');
            drawnow;
        end    
    end    
end
return;
