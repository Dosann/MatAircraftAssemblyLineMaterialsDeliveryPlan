clear;clc;format compact;close all;set(0,'defaultfigurecolor','white');
Paras=LoadParas();
conn=database('thesis','cdb_outerroot','Aa123456','com.mysql.jdbc.Driver','jdbc:mysql://590ab5bb84735.sh.cdb.myqcloud.com:14803/thesis');

cursor=exec(conn,'select * from SA_repair');
cases=fetch(cursor);
cases=cases.Data;
for i=1:size(cases,1)
    cases{i,2}=1;
    cases{i,3}=1;
end
cases=cell2mat(cases);

solvable_rate=zeros(4,3);
for i=1:3
    for j=1:4
        column=3+((i-1)*4+j);
        solvable_rate(j,i)=sum(cases(:,column));
    end
end


close(conn)