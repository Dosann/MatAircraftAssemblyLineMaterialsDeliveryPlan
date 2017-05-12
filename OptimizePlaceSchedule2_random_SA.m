function [place_pos,feasib,space_confli,space_confli0]=OptimizePlaceSchedule2_random_SA(place_pos,arriv_time,area)
% 摆放问题局部搜索——算法2: 
global Case Paras


% 物料中心摆放位置lms
lms=ceil(Case.position'+((Case.a+Case.b)/2)'*Paras.v);

% SA参数值设定
T=1000;
rate=0.999;
K=1;

itercount=0;
maxiter=Paras.maxiter2;
modifis=cell(1,maxiter);
confli_jobs=find(place_pos(4,:)==1);
space_confli0=length(confli_jobs);
while itercount<=maxiter&&~isempty(confli_jobs)
    itercount=itercount+1;
    T=T*rate;
    disp(['current iter:',int2str(itercount)]);
    
    dires={'top','bottom'};
    dire=dires{1+(rand(1)>=0.5)};
%     dire='top';
    
    % 计算各个待插入的job各自周围的remain空间
    space_remain=zeros(1,length(confli_jobs));
    i=0;
    for jobid=confli_jobs
        i=i+1;
        if lms(jobid)~=1
            try
                space_remain(i)=space_remain(i)+sum(area(arriv_time(jobid),lms(jobid)-1,:)==0);
            catch
                kkk=1;
            end
        end
        space_remain(i)=space_remain(i)+sum(area(arriv_time(jobid),lms(jobid),:)==0);
        if lms(jobid)~=Paras.L
            space_remain(i)=space_remain(i)+sum(area(arriv_time(jobid),lms(jobid)+1,:)==0);
        end
    end
    [~,confli_jobs_rank]=sort(space_remain,'ascend');
    % 确定插入的job编号为jobid
%     jobid=confli_jobs(confli_jobs_rank(1));
    jobid=confli_jobs(randperm(length(confli_jobs),1));
    remain_jobs=confli_jobs(confli_jobs_rank(2:end));
    
    % 查看jobid物料在三个区域从上往下插入的结果：产生的新冲突数和新冲突体积
    feasibility_3=zeros(1,3);
    conflis_3=cell(1,3);
    for i=1:3
        l=lms(jobid)+i-2;
        if l<1||l>Paras.L
            feasibility_3(i)=0;
            conflis_3{i}=[999;999];
            continue
        end
        [feasibility_3(i),conflis_3{i},~,~]=InsertJobForceByDire(area,place_pos,jobid,arriv_time,l,dire,2);
    end
    try
        conflis_3_degree=[sum(conflis_3{1}(1,:)),sum(conflis_3{2}(1,:)),sum(conflis_3{3}(1,:));sum(conflis_3{1}(2,:)),sum(conflis_3{2}(2,:)),sum(conflis_3{3}(2,:))];
    catch
        kkk=1;
    end
    bestConflictItemCount=min(conflis_3_degree(1,:));
    insert_ls=find(conflis_3_degree(1,:)==bestConflictItemCount);
    if length(insert_ls)==1
        insert_l=insert_ls;
    else
        bestConflictSpace=min(conflis_3_degree(2,insert_ls));
        insert_lss=find(conflis_3_degree(2,insert_ls)==bestConflictSpace,1,'first');
        insert_l=insert_ls(insert_lss);
    end
    
    % 随机生成一个insert_l位置(1,2,3)
    insert_l_2=randperm(3,1);
%     [feasibility_2,conflis_2,~,~]=InsertJobForceByDire(area,place_pos,jobid,arriv_time,lms(jobid)+insert_l_2-2,dire,2);
%     if feasibility_2==1
%         insert_l=insert_l_2;
%     else
%         conflis_2_degree
    
    if insert_l_2~=insert_l
        if rand(1)<exp(-1/K/T)
            insert_l=insert_l_2;
        end
    end
    disp(['current exp_value:',num2str(exp(-1/K/T))]);
    
    [~,~,area,place_pos]=InsertJobForceByDire(area,place_pos,jobid,arriv_time,lms(jobid)+insert_l-2,dire,1);
    
    confli_jobs=find(place_pos(4,:)==1);
    disp(['inserted_job:',int2str(jobid)]);
    disp(['confli_job:',mat2str(confli_jobs)]);
end

% 检验最终结果是否可行
if isempty(confli_jobs)
    feasib=1;
else
    feasib=0;
end
space_confli=length(confli_jobs);

DrawCuboids(place_pos);


end
