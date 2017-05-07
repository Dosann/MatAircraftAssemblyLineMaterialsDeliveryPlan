function [feasibility,pos,area]=InsertJobTry(area,jobid,arriv_time,l,dire)
% 将某个job的物料插入到area中的线边单元l中，方向dire可选'top'||'bottom'
% 输出: feasibility是否存在可行插入位置 pos可行插入后物料占据的空间最底部c值 area插入后的area
global Case Paras
%job结构 job(1)物料id job(2)物料开始摆放时间 job(3)物料结束摆放时间 job(4)物料大小
job=[jobid,arriv_time(jobid),Case.b(jobid),Case.m(jobid)];

feasibility=0;

c_bottom=find(area(job(3),l,:)==0,1,'first');
c_top=find(area(job(3),1,:)==0,1,'last');
% subarea: 从c_bottom至c_top、时间从job(2)到job(3)内的区域
subarea=area(job(2):job(3),l,c_bottom:c_top);
subarea_empty_d=permute(sum(subarea,1),[3,1,2])>0;

if strcmp(dire,'top')
    for c=c_top-c_bottom-job(4)+2:-1:1
        if sum(subarea_empty_d(c:c+job(4)-1)>0)==0
            feasibility=1;
            pos=c_bottom+c-1;
            area(job(2):job(3),l,pos:pos+job(4)-1)=1;
            break;
        end
    end
elseif strcmp(dire,'bottom')
    for c=1:c_top-c_bottom-job(4)+2
        if sum(subarea_empty_d(c:c+job(4)-1)>0)==0
            feasibility=1;
            pos=c_bottom+c-1;
            area(job(2):job(3),l,pos:pos+job(4)-1)=1;
            break;
        end
    end
end

if feasibility==0
    pos=nan;
end
end
        
        
            