clear;clc;format compact;close all;
Paras=LoadParas();
conn=database('thesis','cdb_outerroot','Aa123456','com.mysql.jdbc.Driver','jdbc:mysql://590ab5bb84735.sh.cdb.myqcloud.com:14803/thesis');

cursor=exec(conn,'select id,N,density,crowdness,CIP_feasib from cases where m_ub<=10');
cases=fetch(cursor);
cases=cases.Data;
cases=cell2mat(cases);
datalength=size(cases,1);


figure(1);
unknownones=cases(:,5)==1;
infeasibones=cases(:,5)==0;
sp1=subplot(1,2,1);hold on;
plot(cases(infeasibones,2)+rand(sum(infeasibones==1),1)*10-5,cases(infeasibones,3),'redo');
plot(cases(unknownones,2)+rand(sum(unknownones==1),1)*10-5,cases(unknownones,3),'.','Color',[0.3,0.1,0.9]);
sp1.FontName='Times New Roman'
xlabel('\fontname{宋体}作业数 \fontname{Times New Roman}N')
ylabel('\fontname{宋体}空间稠度 \fontname{Times New Roman}crowdness')
sp1.FontSize=9;
leg=legend('\fontname{宋体}必然无可行解','\fontname{宋体}未知')
leg.FontName='Times New Roman'
leg.FontSize=9

unknownones=cases(:,5)==1;
infeasibones=cases(:,5)==0;
sp2=subplot(1,2,2);hold on;
plot(cases(infeasibones,2)+rand(sum(infeasibones==1),1)*10-5,cases(infeasibones,4),'redo');
plot(cases(unknownones,2)+rand(sum(unknownones==1),1)*10-5,cases(unknownones,4),'.','Color',[0.3,0.1,0.9]);
sp2.FontName='Times New Roman'
xlabel('\fontname{宋体}作业数 \fontname{Times New Roman}N')
ylabel('\fontname{宋体}空间拥挤度 \fontname{Times New Roman}crowdness')
sp2.FontSize=9;
leg=legend('\fontname{宋体}必然无可行解','\fontname{宋体}未知')
leg.FontName='Times New Roman'
leg.FontSize=9


case_count=zeros(5,10);
for i=1:10
    case_count(1,i)=sum((cases(:,2)==i*30) & infeasibones);
    case_count(2,i)=sum((cases(:,2)==i*30) & unknownones);
    case_count(4,i)=sum(case_count(1:2,i));
    case_count(4,i)=case_count(2,i)/case_count(3,i);
end
case_count(5,isnan(case_count(4,:)))=0;
case_count

f2=figure(2);hold on;
plot(30:30:300,case_count(5,:),'-blacko');
for i=1:10
    ft=text(30*i-3,case_count(5,i)+0.05,sprintf('%2.2f%%',case_count(5,i)*100));
    ft.FontSize=9;
end
plot([30,300],[0.1,0.1],'r--')
f2.Children.FontName='Times New Roman'
xlabel('\fontname{宋体}作业数 \fontname{Times New Roman}N')
ylabel('\fontname{Times New Roman}feasible \fontname{宋体}算例占比')
axis([30,300,0,1])
f2.Children.XAxis.TickValues=30:30:300
f2.Children.FontSize=9


f3=figure(3);hold on;
infeasib_cases=cases(cases(:,5)==0,:);
subplot(1,2,1);
boxplot(infeasib_cases(:,3),{'density'})
axis([0.5,1.5,0,max(cases(:,3))])
subplot(1,2,2);
boxplot(infeasib_cases(:,4),{'crowdness'})
axis([0.5,1.5,0,max(cases(:,4))])
f3.Children(1).FontName='Times New Roman'
f3.Children(2).FontName='Times New Roman'

mean(unfeasib_cases(:,3))
find(sort(cases(:,3))>mean(unfeasib_cases(:,3)),1)/size(cases,1)
max(unfeasib_cases(:,3))
find(sort(cases(:,3))>max(unfeasib_cases(:,3)),1)/size(cases,1)
min(unfeasib_cases(:,3))
find(sort(cases(:,3))>min(unfeasib_cases(:,3)),1)/size(cases,1)

mean(unfeasib_cases(:,4))
find(sort(cases(:,4))>mean(unfeasib_cases(:,4)),1)/size(cases,1)
max(unfeasib_cases(:,4))
find(sort(cases(:,4))>max(unfeasib_cases(:,4)),1)/size(cases,1)
min(unfeasib_cases(:,4))
find(sort(cases(:,4))>min(unfeasib_cases(:,4)),1)/size(cases,1)

close(conn);