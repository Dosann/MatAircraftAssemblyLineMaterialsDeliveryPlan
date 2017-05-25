clear;clc;format compact;set(0,'defaultfigurecolor','white');
Paras=LoadParas();
conn=database('thesis','cdb_outerroot','Aa123456','com.mysql.jdbc.Driver','jdbc:mysql://590ab5bb84735.sh.cdb.myqcloud.com:14803/thesis');

cursor=exec(conn,'select id,N,density,crowdness,aco_feasib from cases');
cases=fetch(cursor);
cases=cases.Data;
cases=cell2mat(cases);

datalength=size(cases,1);
% for i=1:datalength
%     cases{i,1}
%     Case=jsondecode(cases{i,2});
%     exec(conn,sprintf('update cases set aco_feasib=%d where id=%d',Case.feasib,cases{i,1}));
% end

figure(2);
subplot(1,2,1);hold on;
feasib_ones=cases(:,5)==1;
plot(cases(~feasib_ones,2)+rand(sum(feasib_ones==0),1)*10-5,cases(~feasib_ones,3),'red.');
plot(cases(feasib_ones,2)+rand(sum(feasib_ones==1),1)*10-5,cases(feasib_ones,3),'green.');

subplot(1,2,2);hold on;
feasib_ones=cases(:,5)==1;
plot(cases(~feasib_ones,2)+rand(sum(feasib_ones==0),1)*10-5,cases(~feasib_ones,4),'red.');
plot(cases(feasib_ones,2)+rand(sum(feasib_ones==1),1)*10-5,cases(feasib_ones,4),'green.');

close(conn);