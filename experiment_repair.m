clear;clc;format compact;set(0,'defaultfigurecolor','white');
global Case Paras
Paras=LoadParas();
conn=database('thesis','cdb_outerroot','Aa123456','com.mysql.jdbc.Driver','jdbc:mysql://590ab5bb84735.sh.cdb.myqcloud.com:14803/thesis');

cursor=exec(conn,'select id,aco_feasib,result_aco,data from cases where repair_feasib is null');
cases=fetch(cursor);
cases=cases.Data;

datalength=size(cases,1);
for i=1:datalength
    cases{i,1}
    if cases{i,2}==1
        exec(conn,sprintf('update cases set repair_feasib=1 where id=%d',cases{i,1}));
    else
        aco_result=jsondecode(cases{i,3});
        Case=jsondecode(cases{i,4});
        [~,~,~,area,~]=SchedulePlacePosition(aco_result.arriv_time');
        [place_pos,feasib,space_confli(1),space_confli(2),itercount]=OptimizePlaceSchedule2_random_SA_min(aco_result.place_pos,aco_result.arriv_time,area);
        result.feasib=feasib;
        result.space_confli=space_confli;
        result.place_pos=place_pos;
        result.itercount=itercount;
        exec(conn,sprintf('update cases set result_repair=''%s'' where id=%d',jsonencode(result),cases{i,1}));
        if feasib==1
            exec(conn,sprintf('update cases set repair_feasib=1 where id=%d',cases{i,1}));
        else
            exec(conn,sprintf('update cases set repair_feasib=0 where id=%d',cases{i,1}));
        end
    end
end