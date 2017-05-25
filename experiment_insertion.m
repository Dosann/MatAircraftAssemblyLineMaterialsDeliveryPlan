clear;clc;format compact;close all;
global Case Paras
Paras=LoadParas();
conn=database('thesis','cdb_outerroot','Aa123456','com.mysql.jdbc.Driver','jdbc:mysql://590ab5bb84735.sh.cdb.myqcloud.com:14803/thesis');

cursor=exec(conn,'select id,data from cases where result_insertion is null');
cases=fetch(cursor);
cases=cases.Data;

datalength=size(cases,1);
for i=1:datalength
    cases{i,1}
    Case=jsondecode(cases{i,2});
    result=main_insertion_function();
    result=jsonencode(result);
    exec(conn,sprintf('update cases set result_insertion=''%s'' where id=%d',result,cases{i,1}));
end

close(conn);