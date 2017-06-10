clear;clc;format compact;close all;
Paras=LoadParas();
conn=database('thesis','root','Csstsari107','com.mysql.jdbc.Driver','jdbc:mysql://rm-bp10rf4zreaw5he66o.mysql.rds.aliyuncs.com:3306/thesis');

cursor=exec(conn,'select id,N,density,crowdness,cplex_solvable from cases where cplex_solvable is not null and m_ub<=10');
cases=fetch(cursor);
cases=cases.Data;
for i=1:size(cases,1)
    if strcmp(cases{i,5},'feasible')
        cases{i,5}=1;
    elseif strcmp(cases{i,5},'unknown')
        cases{i,5}=2;
    else
        cases{i,5}=3;
    end
end
cases=cell2mat(cases);
datalength=size(cases,1);


figure();
feasibones=cases(:,5)==1;
unknownones=cases(:,5)==2;
infeasibones=cases(:,5)==3;
sp1=subplot(1,2,1);hold on;
plot(cases(infeasibones,2)+rand(sum(infeasibones==1),1)*10-5,cases(infeasibones,3),'red.');
plot(cases(unknownones,2)+rand(sum(unknownones==1),1)*10-5,cases(unknownones,3),'.','Color',[0.3,0.1,0.9]);
plot(cases(feasibones,2)+rand(sum(feasibones==1),1)*10-5,cases(feasibones,3),'green.');
sp1.FontName='Times New Roman'
xlabel('\fontname{宋体}作业数 \fontname{Times New Roman}N')
ylabel('\fontname{宋体}空间稠度 \fontname{Times New Roman}crowdness')
sp1.FontSize=9;
if sum(infeasibones)==0
    leg=legend('\fontname{宋体}尚未求解完毕','\fontname{宋体}已求得精确解')
else
    leg=legend('\fontname{宋体}无可行解','\fontname{宋体}尚未求解完毕','\fontname{宋体}已求得精确解')
end
leg.FontName='Times New Roman'
leg.FontSize=9

sp2=subplot(1,2,2);hold on;
plot(cases(infeasibones,2)+rand(sum(infeasibones==1),1)*10-5,cases(infeasibones,4),'red.');
plot(cases(unknownones,2)+rand(sum(unknownones==1),1)*10-5,cases(unknownones,4),'.','Color',[0.3,0.1,0.9]);
plot(cases(feasibones,2)+rand(sum(feasibones==1),1)*10-5,cases(feasibones,4),'green.');
sp2.FontName='Times New Roman'
xlabel('\fontname{宋体}作业数 \fontname{Times New Roman}N')
ylabel('\fontname{宋体}空间拥挤度 \fontname{Times New Roman}crowdness')
sp2.FontSize=9;
if sum(infeasibones)==0
    leg=legend('\fontname{宋体}尚未求解完毕','\fontname{宋体}已求得精确解')
else
    leg=legend('\fontname{宋体}无可行解','\fontname{宋体}尚未求解完毕','\fontname{宋体}已求得精确解')
end
leg.FontName='Times New Roman'
leg.FontSize=9

case_count=zeros(5,10);
for i=1:10
    case_count(1,i)=sum((cases(:,2)==i*30) & infeasibones);
    case_count(2,i)=sum((cases(:,2)==i*30) & unknownones);
    case_count(3,i)=sum((cases(:,2)==i*30) & feasibones);
    case_count(4,i)=sum(case_count(1:3,i));
    case_count(5,i)=case_count(3,i)/case_count(4,i);
end
case_count(5,isnan(case_count(5,:)))=0;
case_count

f2=figure();hold on;
plot(30:30:300,case_count(5,:),'-blacko');
f2.Children.FontName='Times New Roman'
for i=1:10
    ft=text(30*i-3,case_count(5,i)+0.05,sprintf('%2.2f%%',case_count(5,i)*100));
    ft.FontSize=9;
    ft.FontName='Times New Roman'
end
plot([30,300],[0.1,0.1],'r--')
xlabel('\fontname{宋体}作业数 \fontname{Times New Roman}N')
ylabel('\fontname{宋体}求解完毕的算例占比')
axis([30,300,0,1])
f2.Children.XAxis.TickValues=30:30:300
f2.Children.FontSize=9

close(conn);