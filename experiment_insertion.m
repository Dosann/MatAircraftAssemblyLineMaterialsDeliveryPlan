clear;clc;
format compact

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
% solvable=LoadSolvable('results/results.txt');
display(f_num);
for i=1:f_num
%     if solvable(i)~=1
%         continue
%     end
    i
    Case=LoadCase(strcat('Cases1/',f{i}),999);
    results{i}=main_insertion_function(Case);
    WriteIntoTextInsertion(results{i},'results/results_insertion_20170515.txt');
end