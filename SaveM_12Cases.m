global Case Paras
Paras=LoadParas();
conn=database('thesis','cdb_root','Aa123456','com.mysql.jdbc.Driver','jdbc:mysql://590ab5bb84735.sh.cdb.myqcloud.com:14803/thesis');

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

casenames_M12={};
current=1;
for i=1:length(f)
%     Case=LoadCase(['Cases1/',f{i}{1}]);
    m=split(f{i}{1},'_');
    m=m{3};
    m=str2num(m(2:3));
    if m==12
        casenames_M12{current}=f{i}{1};
        current=current+1;
    end
end

for i=1:length(casenames_M12)
    i
    Case=LoadCase(['Cases1/',casenames_M12{i}]);
    density=CalculateCrowdedness(1);
    m=split(casenames_M12{i},'_');
    m=m{3};
    m=str2num(m(2:3));
    case_json=jsonencode(Case);
    cursor=exec(conn,sprintf('insert into cases values(null,"%s",%d,%f,%d,%f,''%s'')',casenames_M12{i},size(results{i}.place_pos,2),density,m,density*m,case_json))
end
