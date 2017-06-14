% 从全算例集中选择一部分算例，将cplex_solvable设为toexper
clear;clc;
addpath('../')

casecount=importdata('casecount.txt');
global Case Paras
format compact
Paras=LoadParas();
selCasecount=zeros(5,10);
conn=database('thesis','root','Csstsari107','com.mysql.jdbc.Driver','jdbc:mysql://rm-bp10rf4zreaw5he66o.mysql.rds.aliyuncs.com:3306/thesis');
for i=1:10
%     i
    for j=1:5
%         j
        if casecount(j,i)==0
            continue
        end
        cursor=exec(conn,sprintf('select id from cases_2 where m_ub<=10 and N=%d and density_cate=%d',i*30,j));
        result=fetch(cursor);
        result=cell2mat(result.Data);
        rank=randperm(size(result,1));
        ids=result(rank(1:casecount(j,i)),1)';
        selCasecount(j,i)=length(ids);
        ids=replace(replace(replace(num2str(ids),'    ',','),'   ',','),'  ',',');
        cursor=exec(conn,sprintf('update cases_2 set cplex_solvable=''toexper'' where id in (%s)',ids));
    end
end

close(conn);

casecount
selCasecount
casecount-selCasecount