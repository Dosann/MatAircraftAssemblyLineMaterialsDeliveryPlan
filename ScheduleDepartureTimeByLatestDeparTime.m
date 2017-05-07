function [arriv_time,batches,actual_depar_vehid]=ScheduleDepartureTimeByLatestDeparTime(jobs_veh)
global Case Paras

%% 根据job的运送车次，计算各车的最晚离开时间
vehs=unique(jobs_veh);
batch_count=length(vehs);
batches=cell(1,batch_count);
latest_depar_time=zeros(1,batch_count);
for i=1:length(vehs)
    batches{i}=find(jobs_veh==vehs(i));
    latest_depar_time(i)=min(Case.a(batches{i}))-Paras.T;
end
%% 根据小车资源对各批次的发车时间进行启发式调度(2 按照批次对应配送时间从后往前排车次)
veh_avail_time=ones(1,Paras.K)*max(Case.b);
actual_depar_time=zeros(1,batch_count);
actual_depar_vehid=zeros(1,batch_count);

actual_depar_time_assig_status=zeros(1,batch_count);
left_batch_count=batch_count;
while left_batch_count>0
    veh_avail_time_latest=max(veh_avail_time);
    veh_avail_id_latest=find(veh_avail_time==veh_avail_time_latest,1);
    next_batch_depar_time=max(latest_depar_time(actual_depar_time_assig_status==0));
    next_batch_id_rela=find(latest_depar_time(actual_depar_time_assig_status==0)==next_batch_depar_time,1);
    next_batch_id=find(actual_depar_time_assig_status==0,next_batch_id_rela,'first');
    next_batch_id=next_batch_id(end);
    actual_depar_time(next_batch_id)=min([next_batch_depar_time,veh_avail_time_latest]);
    actual_depar_time_assig_status(next_batch_id)=1;
    actual_depar_vehid(next_batch_id)=veh_avail_id_latest;
    veh_avail_time(veh_avail_id_latest)=actual_depar_time(next_batch_id)-Paras.T*2-Paras.Tload;
    left_batch_count=left_batch_count-1;
end
%% 计算各物料的实际运达时间和摆放总时长
arriv_time=zeros(1,Case.N);
for i=1:batch_count
    for j=batches{i}
        arriv_time(j)=actual_depar_time(i)+Paras.T;
    end
end
% actual_hold_time_job=Case.b'-arriv_time
end