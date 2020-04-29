function DisplayVolume(img,direction,slc)

if nargin<2
    direction=3;
end

if nargin<3 && nargin>0
    slc = floor(img.dim(direction)/2);
    if slc==0
        slc = 1;
    end
end

hfig = gcf;
hax = gca;
xlim = get(hax,'XLim');
ylim = get(hax,'YLim');

if nargin>0
    clf;
    set(hfig,'KeyPressFcn','');
    inp.img = img;
    inp.slc = slc;
    inp.direction = direction;
    guidata(hfig,inp);
    iptaddcallback(hfig,'KeyPressFcn',@KeyboardCallback);
else
    inp = guidata(hfig);
    if ~isfield(inp,'img')
        return;
    end
end

if inp.direction==3
    image(inp.img.data(:,:,inp.slc)');
    daspect([inp.img.voxsz(2) inp.img.voxsz(1) 1]);
    xlabel('x');
    ylabel('y');
    z = 'z';
elseif inp.direction==2
    axis([1,inp.img.dim(1),1,inp.img.dim(3)]);
    hold on;
    image((squeeze(inp.img.data(:,inp.slc,:))'));
    daspect([inp.img.voxsz(3) inp.img.voxsz(1) 1]);
    xlabel('x');
    ylabel('z');
    z = 'y';
else
    axis([1,inp.img.dim(2),1,inp.img.dim(3)]);
    hold on;
    image((squeeze(inp.img.data(inp.slc,:,:))'));
    daspect([inp.img.voxsz(3) inp.img.voxsz(2) 1]);
    xlabel('y');
    ylabel('z');
    z = 'x';
end

title(['Slice ',z,' = ',num2str(inp.slc)]);

if isfield(inp,'cntrs')
    hold on
    j=1;
    c = inp.cntrs(:,:,inp.slc);
    while j<length(c) && c(2,j)>0
        len = c(2,j);
        plot(c(1,j+1:j+len),c(2,j+1:j+len),'r');
        j = j+len+1;
    end
end

if (sum(xlim==[0,1])<2)
    set(hax,'XLim',xlim);
    set(hax,'YLim',ylim);
end

if nargin>0
    drawnow;
end

return;





