clear;clc;close all;format compact;
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
casenames=f;
casecount=length(casenames);
crowdedness=zeros(1,casecount);
% solvability=LoadSolvable('实验数据/results.txt')
for i=1:casecount
    i
%     if solvability(i)~=1
%         crowdedness(i)=nan;
%         continue
%     end
        
    Case=LoadCase(['Cases1/',casenames{i}{1}],999);
    crowdedness(i)=CalculateCrowdedness(2);
end

crowdedness=[1:casecount;crowdedness];
% crowdedness=crowdedness(:,~isnan(crowdedness(2,:)));
% crowdedness_sorted=sortrows(crowdedness',2)'