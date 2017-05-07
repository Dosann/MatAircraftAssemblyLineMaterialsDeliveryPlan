function [bestObj,bestAnt,bestAnts,batches,actual_depar_vehid,arriv_time,place_pos,area,space_confli,place_order]=FindBest(ants,best_count)
global Case Paras
ants_count=size(ants,1);
objs=zeros(1,ants_count);
arriv_time=cell(1,ants_count);
batches=cell(1,ants_count);
actual_depar_vehid=cell(1,ants_count);
place_pos=cell(1,ants_count);
feasib=false(1,ants_count);
space_confli=zeros(1,ants_count);
place_order=cell(1,ants_count);
for i=1:ants_count
    % 计算各ant对应的出行趟数
    lastPath=find(ants(i,:)>0,1,'last');
    objs(i)=sum(ants(i,1:lastPath)==0)+1;
    % 计算各ant对应的各配送批次的抵达时间
    [arriv_time{i},batches{i},actual_depar_vehid{i}]=ScheduleDepartureTime(ants(i,:));
    % 计算各ant对应的物料的摆放位置
    [place_pos{i},feasib(i),space_confli(i),area,place_order{i}]=SchedulePlacePosition(arriv_time{i});
    % 根据可行性对目标值进行修正惩罚
    if feasib(i)==false
        objs(i)=objs(i)+Paras.space_confli_puni*space_confli(i);
    end
    
    %增加配送方案可行性检验，若配送方案必定不可行，加入惩罚
%     [~,conclusion]=CheckIfPossible(arriv_time{i});
%     if conclusion.feasib==0
%         objs(i)=objs(i)+20.01;
%     end
    
    % 添加提前运输时间作为惩罚项
%     objs(i)=objs(i)+sum(Case.a'-arriv_time{i})*10;
end
% 选出目标值最大的best_count个ant
bestObjPairs=sortrows([1:ants_count;objs]',2);
bestObj=bestObjPairs(1,2);
bestAntId=bestObjPairs(1,1);
bestAnt=ants(bestAntId,:);
bestAnts=ants(bestObjPairs(1:best_count,1),:);
end

function [arriv_time,batches,actual_depar_vehid]=ScheduleDepartureTime(ant)
global Case Paras
% 分批，计算各批物料的最晚出发时间
lastPath=find(ant(:)>0,1,'last');
batch_count=sum(ant(1:lastPath)==0)+1;
batches=cell(1,batch_count);
zeros_pos=[0,find(ant(1:lastPath+1)==0)];
for i=1:batch_count
    batches{i}=ant(zeros_pos(i)+1:zeros_pos(i+1)-1);
end
lastest_depar_time=zeros(1,batch_count);
for i=1:batch_count
    latest_depar_time(i)=min(Case.a(batches{i}))-Paras.T;
end
%% 根据小车资源对各批次的发车时间进行启发式调度(1 按照批次从后往前排车次)
% veh_avail_time=ones(1,Paras.K)*max(Case.b);
% actual_depar_time=zeros(1,batch_count);
% actual_depar_vehid=zeros(1,batch_count);
% current_batch_id=batch_count;
% while current_batch_id>0
%     veh_avail_time_latest=max(veh_avail_time);
%     veh_avail_id_latest=find(veh_avail_time==veh_avail_time_latest,1);
%     actual_depar_time(current_batch_id)=min([latest_depar_time(current_batch_id),veh_avail_time_latest]);
%     actual_depar_vehid(current_batch_id)=veh_avail_id_latest;
%     veh_avail_time(veh_avail_id_latest)=actual_depar_time(current_batch_id)-Paras.T*2-Paras.Tload;
%     current_batch_id=current_batch_id-1;
% end
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

function [place_pos,feasib,space_confli,area,place_order]=SchedulePlacePosition(arriv_time)
global Case Paras
area=zeros(Paras.D,Paras.L,Paras.C);
lm_pos=ceil(Case.position'+((Case.a+Case.b)/2)'*Paras.v);
%time:第一行jobid,第二行arriv_time,第三行job结束时间，第四行摆放位置
batchDeliv=sortrows([1:length(arriv_time);arriv_time;Case.b';lm_pos]',2)'; 
time_uni=unique(batchDeliv(2,:));
conflict_count=0;
num_time=size(batchDeliv,2);
place_pos=zeros(4,num_time);
place_order=zeros(1,num_time);
current=0;
for t=time_uni
    time_t=batchDeliv(:,find(batchDeliv(2,:)==t,1,'first'):find(batchDeliv(2,:)==t,1,'last'));
    num_t=size(time_t,2);
    time_t=sortrows(time_t',4)';
    lm_uni=unique(time_t(4,:));
    for lm=lm_uni
        time_lm=time_t(:,find(time_t(4,:)==lm,1,'first'):find(time_t(4,:)==lm,1,'last'));
        num_lm=size(time_lm,2);
        if num_lm>1
            time_lm(5,:)=(time_lm(3,:)-time_lm(2,:)).*Case.m(time_lm(1,:))';%以时间×物料大小作为体积，并从大到小排序
            time_lm=fliplr(sortrows(time_lm',5)');
        end
        for job=time_lm
            current=current+1;
            place_order(job(1))=current;
            c_m1=find(area(t,lm-1,:)==0,1,'first');
            
            if length(c_m1)>0 && c_m1+Case.m(job(1))-1<=Paras.C && sum(sum(area(t:job(3),lm-1,c_m1:c_m1+Case.m(job(1))-1)>0))==0
                area(t:job(3),lm-1,c_m1:c_m1+Case.m(job(1))-1)=1;
                place_pos(1:3,job(1))=[t;lm-1;c_m1];
            else
                c_m2=find(area(t,lm,:)==0,1,'first');
                if length(c_m2)>0 && c_m2+Case.m(job(1))-1<=Paras.C && sum(sum(area(t:job(3),lm,c_m2:c_m2+Case.m(job(1))-1)>0))==0
                    area(t:job(3),lm,c_m2:c_m2+Case.m(job(1))-1)=1;
                    place_pos(1:3,job(1))=[t;lm;c_m2];
                else
                    c_m3=find(area(t,lm+1,:)==0,1,'first');
                    if length(c_m3)>0 && c_m3+Case.m(job(1))-1<=Paras.C && sum(sum(area(t:job(3),lm+1,c_m3:c_m3+Case.m(job(1))-1)>0))==0
                        area(t:job(3),lm+1,c_m3:c_m3+Case.m(job(1))-1)=1;
                        place_pos(1:3,job(1))=[t;lm+1;c_m3];
                    else
                        place_pos(:,job(1))=[t;lm;1;1];
                        conflict_count=conflict_count+1;
                    end
                end
            end
        end
    end
end
if conflict_count>0
    feasib=0;
else
    feasib=1;
end
space_confli=conflict_count;
end