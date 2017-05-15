clear;clc;
format compact
global Case Paras

Paras=LoadParas();

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