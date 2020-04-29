function pnts = GetSeeds(rad, ipnts)

if nargin==0
    rad=5;
end

hfig = gcf;
inp = guidata(hfig);
inp.rad = rad;

if nargin<2
    inp.pnts = [];
else
    inp.pnts = ipnts;
end

guidata(hfig, inp);

c1 = iptaddcallback(hfig,'WindowButtonDownFcn',@MouseButtonDownCallback);
c2 = iptaddcallback(hfig,'WindowButtonMotionFcn',@MouseMoveCallback);
c3 = iptaddcallback(hfig,'KeyPressFcn',@KeyPressCallback);
c4 = iptaddcallback(hfig,'WindowScrollWheelFcn',@MouseWheelCallback);

global getseeds
getseeds=1;
while getseeds
    pause(0.5);
end

iptremovecallback(hfig,'WindowButtonDownFcn',c1);
iptremovecallback(hfig,'WindowButtonMotionFcn',c2);
iptremovecallback(hfig,'KeyPressFcn',c3);
iptremovecallback(hfig,'WindowScrollWheelFcn',c4);

inp = guidata(hfig);
pnts = inp.pnts;
return;
end
