function testFastMarching
addpath(genpath('G:\eece8396\Tool'))
global r c d
load Project8.mat
img = test_dmap_init;
[r,c,d] = size(img);

tic;
dmap = FastMarch(img, inf);
toc;

vol.dim = size(img);
vol.data = img;
vol.voxsz = [1,1,1];

vol2.dim = size(img);
vol2.data = dmap_gt;
vol2.voxsz = [1,1,1];

figure(1); clf; figure(1);
colormap(gray(256));
DisplayVolume(vol)

err_fm = mean(abs(dmap(:)-dmap_fm(:)));
err_gt = mean(abs(dmap(:)-dmap_gt(:)));

fprintf('Mean absolute difference against dmap_gt: %4f\n', err_gt)
fprintf('Mean absolute difference against dmap_fm: %4f\n', err_fm)

end