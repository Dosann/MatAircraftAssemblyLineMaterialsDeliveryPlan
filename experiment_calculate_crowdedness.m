clear;clc;
global Case Paras
format compact
Paras=LoadParas();
conn=database('thesis','cdb_outerroot','Aa123456','com.mysql.jdbc.Driver','jdbc:mysql://590ab5bb84735.sh.cdb.myqcloud.com:14803/thesis');

sp=0;bs=500;
while true
    cursor=exec(conn,sprintf('select id,data from cases limit %d,%d',sp,bs));
    cases=fetch(cursor);
    cases=cases.Data;
    datalength=size(cases,1);
    for i=1:datalength
        cases{i,1}
        Case=jsondecode(cases{i,2});
        [density,crowdness]=CalculateCrowdedness();
        exec(conn,sprintf('update cases set density=%d,crowdness=%d where id=%d',density,crowdness,cases{i,1}));
    end
    if datalength<500
        break;
    end
    sp=sp+bs;
end
