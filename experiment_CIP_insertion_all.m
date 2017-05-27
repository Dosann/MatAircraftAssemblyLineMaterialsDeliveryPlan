clear;clc;
global Case Paras
format compact
Paras=LoadParas();
conn=database('thesis','cdb_outerroot','Aa123456','com.mysql.jdbc.Driver','jdbc:mysql://590ab5bb84735.sh.cdb.myqcloud.com:14803/thesis');

while true
    feasibility=zeros(2,500); %第一行是否feasible，第二行空间冲突space_confli
    cursor=exec(conn,sprintf('select id,data,result_insertion from cases where CIP_insertion_feasib is null limit %d',500));
    cases=fetch(cursor);
    cases=cases.Data;
    datalength=size(cases,1);
    for i=1:datalength
        cases{i,1}
        Case=jsondecode(cases{i,2});
        result=jsondecode(cases{i,3});
        result.arriv_time=result.place_pos(1,:)';
        [~,conclusion]=CheckIfPossible(result.arriv_time');
        feasibility(:,i)=[conclusion.feasib;conclusion.space_confli];
        exec(conn,sprintf('update cases set CIP_insertion_feasib=%d,CIP_insertion_space_confli=%d where id=%d',conclusion.feasib,conclusion.space_confli,cases{i,1}));
    end
    if datalength<500
        break;
    end
end

close(conn);