clear;clc;
format compact
global Case Paras

Paras=LoadParas();

dirs={'Cases_15/30job','Cases_15/60job','Cases_15/90job','Cases_15/120job','Cases_15/150job', ...
    'Cases_15/180job','Cases_15/210job','Cases_15/240job','Cases_15/270job','Cases_15/300job'};
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
results=cell(1,f_num);

display(f_num);
for i=1:f_num
    i
    Case=LoadCase(strcat('Cases1/',f{i}),999);
    [results{i}.results,results{i}.conclusion]=CheckIfPossible(Case.a');
end

feasibility=zeros(2,f_num); %第一行是否feasible，第二行空间冲突space_confli
for i=1:f_num
    conclu=results{i}.conclusion;
    feasibility(:,i)=[conclu.feasib;conclu.space_confli];
end

fid=fopen('results/solvability.txt','a');
for i=1:size(feasibility,2)
    s=sprintf('%d\t%s\t%d\t%d\r\n',i,f{i}{1},feasibility(1,i),feasibility(2,i));
    fprintf(fid,s);
end
fclose(fid);