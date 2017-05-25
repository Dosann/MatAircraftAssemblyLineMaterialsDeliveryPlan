clear;clc;format compact;close all;
Paras=LoadParas();
conn=database('thesis','cdb_outerroot','Aa123456','com.mysql.jdbc.Driver','jdbc:mysql://590ab5bb84735.sh.cdb.myqcloud.com:14803/thesis');

cursor=exec(conn,'select id,N,density,crowdness,insertion_feasib from cases');
cases=fetch(cursor);
cases=cases.Data;
cases=cell2mat(cases);

figure(1);
subplot(1,2,1);hold on;
for i=1:size(cases,1)
    feasib_ones=cases(:,5)==1;
    plot(cases(feasib_ones,2),cases(feasib_ones,3),'green.');
    plot(cases(~feasib_ones,2),cases(~feasib_ones,3),'red¡£');
end

subplot(1,2,2);hold on;
for i=1:size(cases,1)
    feasib_ones=cases(:,5)==1;
    plot(cases(feasib_ones,2),cases(feasib_ones,4),'greeno');
    plot(cases(~feasib_ones,2),cases(~feasib_ones,4),'redo');
end

close(conn);