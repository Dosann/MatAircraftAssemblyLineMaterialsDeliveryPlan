clear;clc;
format compact

dirs={'Cases/30job/','Cases/45job/','Cases/60job/','Cases/90job/','Cases/120job/'}
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
% solvable=LoadSolvable('results/results.txt');
display(f_num);
for i=1:f_num
%     if solvable(i)~=1
%         continue
%     end
    i
    Case=LoadCase(f{i},90);
    results{i}=main_insertion_function(Case);
    WriteIntoTextInsertion(results{i},'results/results_insertion_20170512.txt');
end