function [feasibility,conflis,area,place_pos]=InsertJobForceByPos(area,place_pos,jobid,arriv_time,l,pos,mode)
% 将某个job的物料插入到area中的线边单元l中，底部c为pos，place_pos所有物料的摆放位置
% mode=1 则直接插入; mode=2 则只检查情况不插入（feasibility,conflis有效）。
% 输出: feasibility是否无冲突插入 conflis插入后发生冲突的物料及其信息集合
%       area插入后的area(移除了冲突物料) place_pos移除冲突物料插入物料后更新的place_pos
global Case Paras

%job: 1-jobid 2-左下点d坐标 3-左下点c坐标 4-右上点d坐标 5-右上点c坐标
job=[jobid,arriv_time(jobid),pos,Case.b(jobid),pos+Case.m(jobid)-1];
%place_pos_labeled: 行1-jobid 行2-d位置 行3-l位置 行4-c位置 行5-是否为未插入job
place_pos_labeled=[1:Case.N;place_pos];
%related_jobs: 行1-jobid 行2-左下点d坐标 行3-左下点c坐标 行4-右上点d坐标 行5-右上点c坐标
related_jobs=place_pos_labeled(:,place_pos_labeled(3,:)==l);
related_jobs=[related_jobs([1,2,4],:);Case.b(related_jobs(1,:))';related_jobs(4,:)+Case.m(related_jobs(1,:))'-1];

feasibility=1;

conflis=zeros(2,Case.N);
for rjob=related_jobs
    try
        if job(2)>rjob(4)||job(4)<rjob(2)||job(3)>rjob(5)||job(5)<rjob(3)
            %不重叠，跳过
        else
            feasibility=0;
            overlap_x=(job(4)-job(2)+rjob(4)-rjob(2))-(max(job(4),rjob(4))-min(job(2),rjob(2)))+1;
            overlap_y=(job(5)-job(3)+rjob(5)-rjob(3))-(max(job(5),rjob(5))-min(job(3),rjob(3)))+1;
            conflis(:,rjob(1))=[1;overlap_x*overlap_y];
        end
    catch
        kkk=1;
    end
end

% 修改area和place_pos
if mode==1
    for i=1:Case.N
        if conflis(1,i)==1
            area(arriv_time(i):Case.b(i),l,place_pos(3,i):place_pos(3,i)+Case.m(i)-1)=0;
            place_pos(:,i)=[arriv_time(i);ceil(Case.position(i)+((Case.a(i)+Case.b(i))/2)*Paras.v);1;1];
        end
    end
    area(arriv_time(jobid):Case.b(jobid),l,pos:pos+Case.m(jobid)-1)=1;
    place_pos(:,jobid)=[arriv_time(jobid);l;pos;0];
else
    
end


end
        
            