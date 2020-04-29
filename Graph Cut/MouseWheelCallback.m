function MouseWheelCallback(h,e)
inp = guidata(h);
inp.rad = inp.rad*(1 - 0.1*e.VerticalScrollCount);
guidata(h,inp);
MouseMoveCallback(h,e);
return;
