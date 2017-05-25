clear;clc;format compact;close all;
Paras=LoadParas();
conn=database('thesis','cdb_outerroot','Aa123456','com.mysql.jdbc.Driver','jdbc:mysql://590ab5bb84735.sh.cdb.myqcloud.com:14803/thesis');

cursor=exec(conn,'select id,N,density,crowdness,cplex_solvable from cases where cplex_solvable is not null');
cases=fetch(cursor);
cases=cases.Data;

figure(1);
subplot(1,2,1);hold on;
for i=1:size(cases,1)
    if strcmp(cases{i,5},'feasible')
        plot(cases{i,2}+rand(1)*10-5,cases{i,3},'greeno');
    elseif strcmp(cases{i,5},'unknown')
        plot(cases{i,2}+rand(1)*10-5,cases{i,3},'blueo');
    else
        plot(cases{i,2}+rand(1)*10-5,cases{i,3},'redo');
    end
end

subplot(1,2,2);hold on;
for i=1:size(cases,1)
    if strcmp(cases{i,5},'feasible')
        plot(cases{i,2}+rand(1)*10-5,cases{i,4},'greeno');
    elseif strcmp(cases{i,5},'unknown')
        plot(cases{i,2}+rand(1)*10-5,cases{i,4},'blueo');
    else
        plot(cases{i,2}+rand(1)*10-5,cases{i,4},'redo');
    end
end

close(conn);