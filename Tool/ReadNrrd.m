function img = ReadNrrd(filename,onlyhdr)
if nargin<2
    onlyhdr=0;
end
img.filename = filename;
fid = fopen(filename,'rb');
if fid<0
    img = [];
    return;
end
temp = fgetl(fid);
if (~strcmp(temp,'NRRD0004'))
    return;
end
fgetl(fid);
fgetl(fid);
temp = fgetl(fid);
for i=1:length(temp)
    if (temp(i)==':')
        break;
    end
end
temp = temp(i+2:end);
if (strcmp(temp,'int'))
    img.datatype=3; 
elseif (strcmp(temp,'uchar') || strcmp(temp,'unsigned char'))
    img.datatype=1;
elseif (strcmp(temp,'short'))
    img.datatype=2;
elseif (strcmp(temp,'float'))
    img.datatype=4;
end
temp = fgetl(fid);
nd = sscanf(temp,'%*s %d');
if (nd<3)
fprintf('Not a valid 3D image file');
return;
end
temp = fgetl(fid);
temp = sscanf(temp,'%*[^:]: %s');
s(1).str = sscanf(temp,'%[^-]');
temp = sscanf(temp,'%*[^-]-%s');
s(2).str = sscanf(temp,'%[^-]');
s(3).str = sscanf(temp,'%*[^-]-%s');


for i=1:3
if (strcmp(s(i).str,'left'))
    img.orient(i)=1;
elseif (strcmp(s(i).str,'right'))
    img.orient(i)=-1;
elseif (strcmp(s(i).str,'posterior'))
    img.orient(i)=2;
elseif (strcmp(s(i).str,'anterior'))
    img.orient(i)=-2;
elseif (strcmp(s(i).str,'superior'))
    img.orient(i)=3;
elseif (strcmp(s(i).str,'inferior'))
    img.orient(i)=-3;
end
end
temp = fgetl(fid);
img.dim = sscanf(temp,'%*[^:]: %d %d %d%*[^\n]\n');
temp = fgetl(fid);
mat = reshape(sscanf(temp,'%*[^(](%f,%f,%f%*[^(](%f,%f,%f%*[^(](%f,%f,%f%*[^\n]\n'),[3,3]);
for i=1:3
if (mat(i,1)==0)
if (mat(i,2)==0)
    img.orient(i) =  3*(mat(i,3)>0);
    img.voxsz(i) = abs(mat(i,3));
else
    img.orient(i) = (mat(i,2)>0) *2;
    img.voxsz(i) = abs(mat(i,2));
end
else
    img.orient(i) = (mat(i,1)>0);
        img.voxsz(i) = abs(mat(i,1));
end
end
temp = fgetl(fid);
temp = fgetl(fid);
img.encoding = sscanf(temp,'%[^:]');
if (~strcmp(img.encoding,'encoding'))
    temp = fgetl(fid);
end
img.encoding = sscanf(temp,'%*[^:]:%s');
temp = fgetl(fid);
temp = fgetl(fid);
img.hdrsz = ftell(fid);

if onlyhdr
    img.data = [];
    return;
end

if strcmp(img.encoding,'raw')
    if img.datatype==1
            img.data = reshape(fread(fid,img.dim(1)*img.dim(2),img.dim(3),'uint8'),img.dim);
    elseif img.datatype==2
            img.data = reshape(fread(fid,img.dim(1)*img.dim(2),img.dim(3),'short'),img.dim);
    elseif img.datatype==3
            img.data = reshape(fread(fid,img.dim(1)*img.dim(2),img.dim(3),'int32'),img.dim);
    elseif img.datatype==4
            img.data = reshape(fread(fid,img.dim(1)*img.dim(2),img.dim(3),'float'),img.dim);
    end
else
    fseek(fid,0,'eof');
    flsz = ftell(fid);
    fseek(fid,img.hdrsz,'bof');
    enc = uint8(fread(fid,flsz-img.hdrsz,'uint8'));
    if img.datatype==1                
        img.data = reshape(zlib_matlab(0,img.dim(1)*img.dim(2)*img.dim(3),length(enc),1,enc),img.dim');
    elseif img.datatype==2
        img.data = reshape(zlib_matlab(0,2*img.dim(1)*img.dim(2)*img.dim(3),length(enc),2,enc),img.dim');
    elseif img.datatype>2
        img.data = reshape(zlib_matlab(0,4*img.dim(1)*img.dim(2)*img.dim(3),length(enc),4,enc),img.dim');
    end    
end
fclose(fid);
return;