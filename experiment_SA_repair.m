clear;clc;format compact;set(0,'defaultfigurecolor','white');
global Case Paras
Paras=LoadParas();
conn=database('thesis','cdb_outerroot','Aa123456','com.mysql.jdbc.Driver','jdbc:mysql://590ab5bb84735.sh.cdb.myqcloud.com:14803/thesis');

cursor=exec(conn,'select id,0,result_aco,data from SA_repair');
cases=fetch(cursor);
cases=cases.Data;

datalength=size(cases,1);
for T=[500,1000,2000,4000]
    for rate=[0.999]
        for i=1:datalength
            cases{i,1}
            if cases{i,2}==1
                exec(conn,sprintf('update cases set repair_feasib=1 where id=%d',cases{i,1}));
            else
                aco_result=jsondecode(cases{i,3});
                Case=jsondecode(cases{i,4});
                [~,~,~,area,~]=SchedulePlacePosition(aco_result.arriv_time');
                [place_pos,feasib,space_confli(1),space_confli(2),itercount]=OptimizePlaceSchedule2_random_SA_min_SA(aco_result.place_pos,aco_result.arriv_time,area,T,rate);
                result.feasib=feasib;
                result.space_confli=space_confli;
                result.place_pos=place_pos;
                result.itercount=itercount;
                exec(conn,sprintf('update SA_repair set feasib_%d_%d=%d where id=%d',round(rate*1000),T,result.feasib,cases{i,1}));
            end
        end
    end
end