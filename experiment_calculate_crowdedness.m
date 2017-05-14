clear;clc;close all;format compact;
global Case Paras

Paras=LoadParas();
casenames=LoadCaseNames();
casecount=length(casenames);
crowdedness=zeros(1,casecount);
solvability=LoadSolvable('实验数据/results.txt')
for i=1:casecount
    i
    if solvability(i)~=1
        crowdedness(i)=nan;
        continue
    end
        
    Case=LoadCase(casenames{i},999);
    crowdedness(i)=CalculateCrowdedness(2);
end

crowdedness=[1:casecount;crowdedness];
crowdedness=crowdedness(:,~isnan(crowdedness(2,:)));
crowdedness_sorted=sortrows(crowdedness',2)'