function MouseButtonDownCallback(h,e)
a = get(h,'SelectionType');
if ~strcmp(a,'normal')
 return;
end
a = get(gca,'CurrentPoint');
x = round(a(1,1));
y = round(a(1,2));
inp = guidata(h);
if inp.direction==3
 v = [x y inp.slc inp.rad];
elseif inp.direction==2
 v = [x inp.slc y inp.rad];
else
 v = [inp.slc x y inp.rad];
end
inp.pnts(end+1,:) = v;
guidata(h,inp);
end