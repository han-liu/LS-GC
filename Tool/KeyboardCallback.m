function KeyboardCallback(han, e)
% global midcontour 
% if midcontour == 1
%     return;
% end
h = guidata(han);
if strcmp(e.Key, 'uparrow')
    h.slc = min(h.img.dim(h.direction), h.slc+1);
elseif strcmp(e.Key, 'downarrow')
    h.slc = max(1, h.slc-1);
end
guidata(han, h);
DisplayVolume();
return;

% function KeyboardCallback(han, e)
% global midcontour Edgs EdgCosts Edg_lens r c
% if midcontour == 1
%     return;
% end
% h = guidata(han);
% if strcmp(e.Key, 'uparrow')
%     h.slc = min(h.img.dim(h.direction), h.slc+1);
% elseif strcmp(e.Key, 'downarrow')
%     h.slc = max(1, h.slc-1);
% end
% 
% clear edgecost;
% g = fspecial('gaussian', [5,5], 1);  % filter the image before edge detection
% im2 = conv2(h.img.data(:, :, h.slc), g, 'same');
% edgecost(:, :, 1) = abs(conv2(im2, [-1 0 1; -1 0 1; -1 0 1], 'same'));
% edgecost(:, :, 2) = edgecost(:, :, 1);
% edgecost(:, :, 3) = abs(conv2(im2, [-1 0 1; -1 0 1; -1 0 1], 'same'));
% edgecost(:, :, 4) = edgecost(:, :, 3);
% edgecost(:, :, 5) = abs(conv2(im2, sqrt(2)/2*[-2 -1 0; -1 0 1; 0 1 2], 'same'));
% edgecost(:, :, 6) = edgecost(:, :, 5);
% edgecost(:, :, 7) = abs(conv2(im2, sqrt(2)/2*[0 1 2; -1 0 1; -2 -1 0], 'same'));
% edgecost(:, :, 8) = edgecost(:, :, 7);
% bw = edge(h.img.data(:, :, h.slc), 'canny', 0.1);
% v = max(edgecost(:));  % max value from the sobel filter result
% for i = 1:8
% edgecost(:, :, i) = edgecost(:, :, i) + v*bw;
% end
% edgecost = max(edgecost(:)) - edgecost;
% edgecost(:, :, 5:8) = sqrt(2) * edgecost(:, :, 5:8);  % sqrt(2) for diagonal costs
% [Y, X] = meshgrid(1:c, 1:r);
% X = X(:);
% Y = Y(:);
% % fprintf('Recomputing the edge costs...\n')
% Edgs = [Y<c, Y>1, X<r, X>1, X<r&Y>1, X>1&Y<c, X>1&Y>1, X<r&Y<c].* ((repmat([1:r*c]', [1,8])) + repmat([r, -r, 1 , -1, 1-r, r-1, -r-1, 1+r], [r*c, 1]));
% EdgCosts = repmat(1+edgecost(1:r*c)', [1, 8]); % cost background: 1, foreground: 256.
% EdgCosts(:, 5:8) = EdgCosts(:, 5:8) * sqrt(2); % diagonal is sqrt(2) of the vertical and horizontal costs
% Edg_lens = sum(Edgs'~=0);
% for i = 1:r*c
%     msk = Edgs(i,:) > 0;
%     Edgs(i, 1:Edg_lens(i)) = Edgs(i, msk);
%     EdgCosts(i, 1:Edg_lens(i)) = EdgCosts(i, msk);
% end
% 
% guidata(han, h);
% DisplayVolume();
% return;