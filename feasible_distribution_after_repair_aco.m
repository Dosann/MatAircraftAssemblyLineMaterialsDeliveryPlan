clear;clc;format compact;close all;set(0,'defaultfigurecolor','white');
Paras=LoadParas();
conn=database('thesis','cdb_outerroot','Aa123456','com.mysql.jdbc.Driver','jdbc:mysql://590ab5bb84735.sh.cdb.myqcloud.com:14803/thesis');

cursor=exec(conn,'select id,N,density,crowdness,repair_feasib,aco_feasib,CIP_ACO_feasib from cases where m_ub<=10');
cases=fetch(cursor);
cases=cases.Data;
cases=cell2mat(cases);
cases_count=size(cases,1);

feasib=cases(:,5)==1;
infeasib=cases(:,5)==0;

figure(1);
%% sp1
sp1=subplot(1,2,1);hold on;

interval_serie=0.05:0.05:2;
distribution_density=zeros(3,length(interval_serie));
f=@(x,interval_serie)(round(1/(interval_serie(2)-interval_serie(1))*x));
for i=interval_serie
    distribution_density(1,f(i,interval_serie))=sum(feasib==1 & cases(:,3)<i & cases(:,3)>+i-0.1)/cases_count;
    distribution_density(2,f(i,interval_serie))=sum(infeasib==1 & cases(:,3)<i & cases(:,3)>+i-0.1)/cases_count;
    distribution_density(3,f(i,interval_serie))=sum(cases(:,3)<i & cases(:,3)>+i-0.1)/cases_count;
end
plot(interval_serie,distribution_density(1,:)*1.0./distribution_density(3,:),'o-');
plot(interval_serie,distribution_density(2,:)*1.0./distribution_density(3,:),'+-');
% plot(interval_serie,distribution_density(3,:),'-');
leg=legend(sprintf('\\fontname{宋体}可解比例'), ...
            sprintf('\\fontname{宋体}未得到可行解比例'));
xlabel('\fontname{宋体}空间稠度 \fontname{Times New Roman}density')
ylabel('\fontname{宋体}比例')
sp1.FontSize=9;

%% sp2
sp2=subplot(1,2,2);hold on;

interval_serie=0.1:0.1:10;
distribution_density=zeros(3,length(interval_serie));
f=@(x,interval_serie)(round(1/(interval_serie(2)-interval_serie(1))*x));
for i=interval_serie
    distribution_density(1,f(i,interval_serie))=sum(feasib==1 & cases(:,4)<i & cases(:,4)>+i-0.1)/cases_count;
    distribution_density(2,f(i,interval_serie))=sum(infeasib==1 & cases(:,4)<i & cases(:,4)>+i-0.1)/cases_count;
    distribution_density(3,f(i,interval_serie))=sum(cases(:,4)<i & cases(:,4)>+i-0.1)/cases_count;
end
plot(interval_serie,distribution_density(1,:)*1.0./distribution_density(3,:),'o-');
plot(interval_serie,distribution_density(2,:)*1.0./distribution_density(3,:),'+-');
% plot(interval_serie,distribution_density(3,:),'-');
leg=legend(sprintf('\\fontname{宋体}可解比例'), ...
            sprintf('\\fontname{宋体}未得到可行解比例'));

xlabel('\fontname{宋体}空间拥挤度 \fontname{Times New Roman}crowdness')
ylabel('\fontname{宋体}比例')
sp2.FontSize=9;






close(conn);