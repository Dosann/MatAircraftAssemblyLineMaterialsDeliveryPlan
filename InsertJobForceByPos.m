function [feasibility,conflis,area,place_pos]=InsertJobForceByPos(area,place_pos,jobid,arriv_time,l,pos,mode)
% ��ĳ��job�����ϲ��뵽area�е��߱ߵ�Ԫl�У��ײ�cΪpos��place_pos�������ϵİڷ�λ��
% mode=1 ��ֱ�Ӳ���; mode=2 ��ֻ�����������루feasibility,conflis��Ч����
% ���: feasibility�Ƿ��޳�ͻ���� conflis���������ͻ�����ϼ�����Ϣ����
%       area������area(�Ƴ��˳�ͻ����) place_pos�Ƴ���ͻ���ϲ������Ϻ���µ�place_pos
global Case Paras

%job: 1-jobid 2-���µ�d���� 3-���µ�c���� 4-���ϵ�d���� 5-���ϵ�c����
job=[jobid,arriv_time(jobid),pos,Case.b(jobid),pos+Case.m(jobid)-1];
%place_pos_labeled: ��1-jobid ��2-dλ�� ��3-lλ�� ��4-cλ�� ��5-�Ƿ�Ϊδ����job
place_pos_labeled=[1:Case.N;place_pos];
%related_jobs: ��1-jobid ��2-���µ�d���� ��3-���µ�c���� ��4-���ϵ�d���� ��5-���ϵ�c����
related_jobs=place_pos_labeled(:,place_pos_labeled(3,:)==l);
related_jobs=[related_jobs([1,2,4],:);Case.b(related_jobs(1,:))';related_jobs(4,:)+Case.m(related_jobs(1,:))'-1];

feasibility=1;

conflis=zeros(2,Case.N);
for rjob=related_jobs
    try
        if job(2)>rjob(4)||job(4)<rjob(2)||job(3)>rjob(5)||job(5)<rjob(3)
            %���ص�������
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

% �޸�area��place_pos
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
        
            