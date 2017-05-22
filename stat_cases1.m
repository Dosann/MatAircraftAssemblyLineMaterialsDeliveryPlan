dirs={'Cases1/30job','Cases1/60job','Cases1/90job','Cases1/120job','Cases1/150job', ...
    'Cases1/180job','Cases1/210job','Cases1/240job','Cases1/270job','Cases1/300job'};
files=cell(1,length(dirs));
for i=1:length(dirs)
    files_temp=dir(dirs{i});
    files{i}=cell(1,length(files_temp));
    for j=1:length(files_temp)
        if files_temp(j).isdir==0
            dirs_2=split(dirs{i},'/');
            files{i}{j}=strcat(dirs_2(2),'/',string(files_temp(j).name));
        end
    end
end
f={}
f_num=0
for i=1:length(files)
    for j=1:length(files{i})
        if length(files{i}{j})~=0
            f_num=f_num+1;
            f{f_num}=files{i}{j};
        end
    end
end
ma=zeros(10,75);
for i=1:4400
    c=split(f{i},'/');
    c=c{2};
    s=split(c,'_');
    c=s{2};
    c=str2num(c(2));
    m=s{3};
    m=str2num(m(2:3));
    m=m/1;
    n=s{1};
    s=str2num(n);
    s=ceil(s/30);
    ma(s,m+3*(c-1))=ma(s,m+3*(c-1))+1;
end