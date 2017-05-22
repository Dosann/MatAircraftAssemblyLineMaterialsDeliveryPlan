global Paras Case
Paras=LoadParas();
conn=database('thesis','cdb_outerroot','Aa123456','com.mysql.jdbc.Driver','jdbc:mysql://590ab5bb84735.sh.cdb.myqcloud.com:14803/thesis');

cursor=exec(conn,sprintf('select id,data,result_aco from cases where id<=5900'));
cases=fetch(cursor);
cases=cases.Data;
for i=1:size(cases,1)
    i
    Case=jsondecode(cases{i,2});
    result_aco=jsondecode(cases{i,3});
    [~,conclusion]=CheckIfPossible(Case.a');
    [~,conclusion_aco]=CheckIfPossible(result_aco.arriv_time');
    exec(conn,sprintf('update cases set CIP_feasib=%d,CIP_space_confli=%d,CIP_ACO_feasib=%d,CIP_ACO_space_confli=%d where id=%d',conclusion.feasib,conclusion.space_confli,conclusion_aco.feasib,conclusion_aco.space_confli,cases{i,1}));
end