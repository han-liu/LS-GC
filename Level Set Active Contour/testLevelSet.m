function testLevelSet

% Method: 
%   1. CaselleDibos
%   2. CaselleSapiro
%   3. ChanVese
m(1).name = 'CasellesDibos';
m(1).inflation = 1;
m(1).alpha = 0.2;
m(1).beta = 0.1;
m(1).epsilon = 1e-7;
m(1).mindist = 3.1;
m(1).tau = 0;
m(1).maxiter = 1000;
m(1).convthrsh = 0.05;
m(1).reinitrate = 1;
m(1).visrate = 5;
m(2) = m(1);
m(2).name = 'CasellesSapiro';
m(2).tau = 1;
m(3).name = 'ChanVese';
m(3).mu = 1;
m(3).lambda=1;
m(3).reinitrate = 5;
m(3).visrate = 25;
m(3).maxiter = 1000;
m(3).mindist = 5;
m(3).convthrsh = 0.05;

% Test Image:
%   Circles
%   Squares
%   Concavity

t(1).gt = zeros(50,50);
rad = 5;
for i=1:50
    for j=1:50
        if (i - 25)^2+(j-15)^2<rad^2
            t(1).gt(i,j) = 1;
        end
        if (i - 25)^2+(j-35)^2<rad^2
            t(1).gt(i,j) = 1;
        end
    end
end
t(2).gt = zeros(50,50);
t(2).gt(20:30,10:20)=1;
t(2).gt(20:30,30:40)=1;
t(3).gt = zeros(50,50);
t(3).gt(15:35,15:35) = 1;
t(3).gt(21:25,10:20) = 0;
t(3).gt(10:14,25:27) = 1;


% Noise levels:
noise = [0,.1,.25,.5,1];



for k=1:3
    dmapinit = ones(size(t(k).gt));
    dmapinit(8:42,8:42)=-1;
    for j=1:length(t)
        for i=1:length(noise)
            m(k).sigma = noise(i)*5;
            img = .5 - t(j).gt;
            rng(0);
            img = img + noise(i)*randn(size(img));
            figure(1); clf; 
            subplot(3,2,1);
            colormap(gray(256));
            image(255*t(j).gt);        
            title(sprintf('Test image #%d, Method=%s, Noise=%1.2f',j,m(k).name,noise(i)));
            dmap = LevelSet(img,dmapinit,m(k));
            subplot(3,2,1);
            hold on;
            contour(dmap,[0,0],'r');
            fprintf('\nMethod: %s\tTest image: %d\tNoise: %1.2f',m(k).name,j,noise(i));
            fprintf('\n\tPress enter to continue.');
            pause
            fprintf('\nRunning...');
        end
    end
end
fprintf('\nTesting CasellesSapiro method on a 3d Volume.\n\tThis could take a few minutes.\n\tPress enter to continue...');
pause;
fprintf('\nRunning...');
load 'testimg3d.mat'
figure(1); clf; 
subplot(3,2,1);
colormap(gray(256));
image(255*img(:,:,20));
title('ground truth');
m(2).sigma = 1.25;
m(2).maxiter =100;
m(2).visrate = 1;
img = img + 0.25*randn(size(img));
dmapinit = ones(40,132,40);
dmapinit(2:39,2:131,10:30)=-1;
dmap = LevelSet(img,dmapinit,m(2));

M = isosurface(dmap,0);
figure(2); close(2); figure(2); 
DisplayMesh(M)

