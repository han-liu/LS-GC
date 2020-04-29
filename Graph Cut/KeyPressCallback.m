function KeyPressCallback(h,e)
global getseeds
if (strcmp(e.Key,'escape'))
    getseeds=0;
elseif (strcmp(e.Key,'uparrow'))||(strcmp(e.Key,'downarrow'))
    MouseMoveCallback(h,e)
elseif (strcmp(e.Key,'leftarrow'))
    et.VerticalScrollCount = +1;
    MouseWheelCallback(h,et);
elseif (strcmp(e.Key,'rightarrow'))
    et.VerticalScrollCount = -1;
    MouseWheelCallback(h,et);
end
end