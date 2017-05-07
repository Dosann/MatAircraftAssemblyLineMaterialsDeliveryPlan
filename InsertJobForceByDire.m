function [feasibility,conflis,area,place_pos]=InsertJobForceByDire(area,place_pos,jobid,arriv_time,l,dire,mode)
% 将某个job的物料插入到area中的线边单元l中，从某一个方向开始寻找在该job摆放最晚时刻l单元有空间的位置，place_pos所有物料的摆放位置
% mode=1 则直接插入; mode=2 则只检查情况不插入（feasibility,conflis有效）。
% 输出: feasibility是否无冲突插入 conflis插入后发生冲突的物料及其信息集合
%       area插入后的area(移除了冲突物料) place_pos移除冲突物料插入物料后更新的place_pos
global Case Paras

% 找到该线边单元内该方向上第一个空出的位置。
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