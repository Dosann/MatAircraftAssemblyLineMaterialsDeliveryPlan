clear;clc;close all;
tic
format compact
global Case Paras
% rand('state',0)
Case=LoadCase('30job/301_1 .txt',120);
Paras=LoadParas();

remained_job_count=Case.N;
inserted_job=zeros(1,Case.N);
current_veh_id=1;
veh_capa(current_veh_id)=Paras.Q;
while remained_job_count>0
    insertable_jobs=~inserted_job & veh_capa(current_veh_id)>=Case.m';
    insertable_jobs_id=find(insertable_jobs==1);
    if isempty(insertable_jobs_id)
        current_veh_id=current_veh_id+1;
        veh_capa(current_veh_id)=Paras.Q;
        continue
    end
    insertable_jobs_count=length(insertable_jobs_id);
    
    % ����C1 C2
    C1=zeros(1,insertable_jobs_count);
    C2=zeros(1,insertable_jobs_count);
    current_veh_jobs=find(inserted_job==current_veh_id);
    current_veh_a=min(Case.a(insertable_jobs_id));
    for i=1:insertable_jobs_count
        % ����C1
        if isempty(current_veh_jobs)
            C1(i)=0;
            continue
        end
        timegap=Case.a(insertable_jobs_id(i))-current_veh_a;
        if timegap<0
            C1(i)=sum(Case.m(current_veh_jobs))*-timegap;
        else
            C1(i)=Case.m(insertable_jobs_id(i))*timegap;
        end
        
        %����C2
        m_temp=sum(Case.m(current_veh_jobs))+Case.m(insertable_jobs_id(i));
        C2(i)=(Paras.Q-m_temp)^2;
    end
    
    C=Paras.alpha_heu*C1+(1-Paras.alpha_heu)*C2;
    job_to_insert=insertable_jobs_id(find(C==min(C),1,'first'));
    remained_job_count=remained_job_count-1;
    veh_capa(current_veh_id)=veh_capa(current_veh_id)-Case.m(job_to_insert);
    inserted_job(job_to_insert)=current_veh_id;
end

[arriv_time,batches,actual_depar_vehid]=ScheduleDepartureTimeByLatestDeparTime(inserted_job);

[place_pos,feasib,space_confli,area,place_order]=SchedulePlacePosition(arriv_time);

feasib
space_confli



toc