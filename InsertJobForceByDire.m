function [feasibility,conflis,area,place_pos]=InsertJobForceByDire(area,place_pos,jobid,arriv_time,l,dire,mode)
% ��ĳ��job�����ϲ��뵽area�е��߱ߵ�Ԫl�У���ĳһ������ʼѰ���ڸ�job�ڷ�����ʱ��l��Ԫ�пռ��λ�ã�place_pos�������ϵİڷ�λ��
% mode=1 ��ֱ�Ӳ���; mode=2 ��ֻ�����������루feasibility,conflis��Ч����
% ���: feasibility�Ƿ��޳�ͻ���� conflis���������ͻ�����ϼ�����Ϣ����
%       area������area(�Ƴ��˳�ͻ����) place_pos�Ƴ���ͻ���ϲ������Ϻ���µ�place_pos
global Case Paras

% �ҵ����߱ߵ�Ԫ�ڸ÷����ϵ�һ���ճ���λ�á�
if strcmp(dire,'top')
    empty_pos=find(area(Case.b(jobid),l,:)==0,1,'last');
    pos=empty_pos-Case.m(jobid)+1;
    if isempty(pos)
        pos=1;
    end
    if pos<1
        pos=1;
    end
elseif strcmp(dire,'bottom')
    empty_pos=find(area(Case.b(jobid),l,:)==0,1,'first');
    pos=empty_pos;
    if isempty(pos)
        pos=1;
    end
    if pos+Case.m(jobid)-1>Paras.C
        pos=Paras.C-Case.m(jobid)+1;
    end
end

[feasibility,conflis,area,place_pos]=InsertJobForceByPos(area,place_pos,jobid,arriv_time,l,pos,mode);


end