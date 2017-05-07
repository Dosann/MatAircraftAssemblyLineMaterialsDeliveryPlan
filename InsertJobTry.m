function [feasibility,pos,area]=InsertJobTry(area,jobid,arriv_time,l,dire)
% ��ĳ��job�����ϲ��뵽area�е��߱ߵ�Ԫl�У�����dire��ѡ'top'||'bottom'
% ���: feasibility�Ƿ���ڿ��в���λ�� pos���в��������ռ�ݵĿռ���ײ�cֵ area������area
global Case Paras
%job�ṹ job(1)����id job(2)���Ͽ�ʼ�ڷ�ʱ�� job(3)���Ͻ����ڷ�ʱ�� job(4)���ϴ�С
job=[jobid,arriv_time(jobid),Case.b(jobid),Case.m(jobid)];

feasibility=0;

c_bottom=find(area(job(3),l,:)==0,1,'first');
c_top=find(area(job(3),1,:)==0,1,'last');
% subarea: ��c_bottom��c_top��ʱ���job(2)��job(3)�ڵ�����
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
        
        
            