clear;clc;
global Case Paras
former_results=importdata('实验数据/results_aco.txt');
former_results_count=size(former_results,1);
infeasib_results=[];
for i=1:former_results_count
    if ~isnan(former_results(i,2)) && floor(former_results(i,2))~=former_results(i,2)
        infeasib_results=[infeasib_results;former_results(i,:)];
    end
end

cns=LoadCaseNames();
infeasib_results_count=size(infeasib_results,1)
feasib_list=zeros(1,infeasib_results_count);
space_confli_list=zeros(2,infeasib_results_count);
itercount_list=zeros(1,infeasib_results_count);
objective_list=zeros(1,infeasib_results_count);
for i=1:infeasib_results_count
    i
    caseid=infeasib_results(i,1);
    casename=cns{caseid};
    Case=LoadCase(casename,120);
%     检验该算例是否可行
    [cipresults,cipconclusion]=CheckIfPossible(Case.a');
    if cipconclusion.feasib~=1
        feasib_list(i)=nan;
        space_confli_list(:,i)=cipconclusion.space_confli;
        itercount_list(i)=0;
        continue
    end
    
    result=main_function(Case);
    objective_list(i)=result.bestObj_hist;
    [place_pos,feasib_list(i),space_confli_list(1,i),space_confli_list(2,i),itercount_list(i)]=OptimizePlaceSchedule2_random_SA_min(result.place_pos,result.arriv_time,result.area);
end
