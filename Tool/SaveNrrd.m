function SaveNrrd(img)
fid = fopen(img.filename,'wb');
if img.datatype==1
    datatype='unsigned char';
elseif img.datatype==2
    datatype='short';
elseif img.datatype==4
    datatype='float';
end
for i=1:3
    if img.orient(i)==1
        os(i).s = 'left';
    elseif img.orient(i)==-1
        os(i).s = 'right';
    elseif img.orient(i)==2
        os(i).s = 'posterior';
    elseif img.orient(i)==-2
        os(i).s = 'anterior';
    elseif img.orient(i)==3
        os(i).s = 'superior';
    elseif img.orient(i)==-3
        os(i).s = 'inferior';
    end
end
fprintf(fid,['NRRD0004\n# Complete NRRD file format specification at:\n',...
    '# http://teem.sourceforge.net/nrrd/format.html\ntype: %s\n',...
    'dimension: 3\nspace: %s-%s-%s\nsizes: %d %d %d\nspace directions:',...
    '(%f,0,0) (0,%f,0) (0,0,%f)\nkinds: domain domain domain\n',...
    'endian: little\nencoding: gzip\nspace origin: (0,0,0)\n\n'],...
   datatype,os(1).s,os(2).s,os(3).s,img.dim(1),img.dim(2),img.dim(3),...
   img.voxsz(1),img.voxsz(2),img.voxsz(3)); 

enc = zlib_matlab(1,img.dim(1)*img.dim(2)*img.dim(3),img.datatype,img.data(:));
fwrite(fid,enc,'uint8');
fclose(fid);

return;