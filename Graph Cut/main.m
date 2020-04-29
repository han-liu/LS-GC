clc;
clearvars;
close all;
global Parent Tree Active EdgeCaps Edges Edge_Lens r c d EdgeCapsO fifo Orphans PathLens
addpath(genpath("G:/eece8396/Tool"))

img = ReadNrrd('G:/eece8396/EECE_395/0522c0001/img.nrrd');
crp = img;
crp.data = img.data(200:320,140:225,52:80);
img = round(crp.data);
crp.data = crp.data/10+100;
crp.dim = size(crp.data);
figure(1); close(1); figure(1); colormap(gray(256));
DisplayVolume2(crp);

load mandibleseeds.mat
forepnts = mandibleseeds.forepnts;
backpnts = mandibleseeds.backpnts;

% forepnts = GetSeeds();
% backpnts = GetSeeds();
% mandibleseeds.forepnts = forepnts;
% mandibleseeds.backpnts = backpnts;

foremsk = zeros(size(img));
backmsk = zeros(size(img));
for i=1:size(img,1)
    for j=1:size(img,2)
        for k=1:size(forepnts,1)
            if (i-forepnts(k,1))^2+(j-forepnts(k,2))^2<=forepnts(k,4)^2
                foremsk(i,j, forepnts(k,3))=1;
            end
        end
        for k=1:size(backpnts,1)
            if (i-backpnts(k,1))^2+(j-backpnts(k,2))^2<=backpnts(k,4)^2
                backmsk(i,j, backpnts(k,3))=1;
            end
        end
    end
end

%% Generate histogram for foreground and background
mn = min(img(:));
mx = max(img(:));
numbins=64; % camera man: 32
img = double(img);
binsize = (mx+0.001-mn)/numbins;
bins = mn:binsize:mx;
forehist = zeros(numbins,1);
backhist = zeros(numbins,1);
for i=1:length(img(:))
    if foremsk(i)>0
        forehist(floor((img(i)-mn)/binsize)+1) = forehist(floor((img(i)-mn)/binsize+1))+1;
    end
    if backmsk(i)>0
        backhist(floor((img(i)-mn)/binsize)+1) = backhist(floor((img(i)-mn)/binsize+1))+1;
    end
end
%% Plot histograms 
backhist = backhist*sum(forehist)/sum(backhist);
figure(3); clf;
plot(bins,forehist);
hold on;
plot(bins,backhist, 'r')
pdfs = (forehist+1)./(forehist+backhist+2);
pdft = (backhist+1)./(forehist+backhist+2);

figure(4);
subplot(2,1,1);
plot(pdfs)
title('Pr(Jp|S)')
subplot(2,1,2);
plot(pdft)
title('Pr(Jp|T)')

Pr_s = pdfs(floor((img-mn)/binsize)+1);
Pr_s(foremsk>0)=1-eps;
Pr_s(backmsk>0)=eps;

Pr_s_vol = crp;
Pr_s_vol.data = Pr_s*255;
figure(5); clf; colormap(gray(256));
DisplayVolume(Pr_s_vol);
title('Foreground Probability map')

%% 3D Graph Cut
clc;
sigma = 200;
lambda = 0.025;
tic
res = GraphCut3D(sigma, lambda, Pr_s, img);
toc

%% Result visualization
tree = zeros(size(img));
tree(:) = res(1:length(tree(:)));

% show contour
figure(1);
inp = guidata(gcf);
inp.cntrs = zeros(2, 10000, size(img,3));
for i=1:size(img,3)
    cntr = contourc(tree(:, :, i)', [1.5, 1.5]);
    inp.cntrs(:, 1:size(cntr,2),i) = cntr;
end
guidata(gcf, inp);

% show 3D mesh
figure();
msh = isosurface(tree, 1.5);
msh.vertices = msh.vertices.*repmat(crp.voxsz, [length(msh.vertices),1]);
DisplayMesh(msh);

%% Quantitative evaluation - dice score
addpath('G:\eece8396\project4')
man = ReadNrrd('G:/eece8396/EECE_395/0522c0001/structures/mandible.nrrd');
man.data = man.data(200:320,140:225,52:80);
man.dim = size(man.data);
auto = man;
auto.data = tree;
auto.data(auto.data(:)==2)=0;
Dice(auto, man)

figure();
msh2 = isosurface(man.data, 0.5);
msh2.vertices = msh2.vertices.*repmat(crp.voxsz,[length(msh2.vertices),1]);
DisplayMesh(msh2)
