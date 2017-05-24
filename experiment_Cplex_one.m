clear;clc;
global Case Paras
format compact
Paras=LoadParas();
conn=database('thesis','cdb_outerroot','Aa123456','com.mysql.jdbc.Driver','jdbc:mysql://590ab5bb84735.sh.cdb.myqcloud.com:14803/thesis');


cursor=exec(conn,sprintf('select id,data from cases where cplex_solvable=''%s''','infeasible'));
cases=fetch(cursor);
cases=cases.Data;
if strcmp(cases{1},'No Data')
    fprintf('No Data: %d,%d,%d',n,m_ub,d_cate);
end
size(cases,1)
for i=1:size(cases,1)
    cases{i,1}
    tic

    Case=jsondecode(cases{i,2});
    result=cplex_function_complete();
    toc
    result.computetime=toc;
    exec(conn,sprintf('update cases set cplex_solvable=''%s'',cplex_solution=''%s'' where id=%d',result.feasibility,jsonencode(result),cases{i,1}))
end
close(conn)
% DrawCuboids(result.place_pos);
% feasib=CheckIfConflicting(result.place_pos)