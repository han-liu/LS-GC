function MouseMoveCallback(h,e)
a = get(gca,'CurrentPoint');
x = round(a(1,1));
y = round(a(1,2));
inp = guidata(h);
if inp.direction==3
    d1 = 1;
    d2 = 2;
    d3 = 3;
elseif inp.direction==2
    d1 = 1;
    d2 = 3;
    d3 = 2;
else
    d1 = 2;
    d2 = 3;
    d3 = 1;
end
hold off;
DisplayVolume2();
hold on;
ii = [0:.05:2*pi,0];
if (x>=1) && (y>=1) && (x<=inp.img.dim(d1)) && (y<=inp.img.dim(d2))
    plot(x+inp.rad*cos(ii),y+inp.rad*sin(ii),'r');
end
if inp.pnts
    for i=1:size(inp.pnts,1)
        if inp.pnts(i,d3)==inp.slc
            plot(inp.pnts(i,d1)+inp.pnts(i,4)*cos(ii),inp.pnts(i,d2)+inp.pnts(i,4)*sin(ii),'g');
        end
    end
end
drawnow;
end