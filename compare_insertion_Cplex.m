clear;clc;format compact;set(0,'defaultfigurecolor','white');
Paras=LoadParas();
conn=database('thesis','cdb_outerroot','Aa123456','com.mysql.jdbc.Driver','jdbc:mysql://590ab5bb84735.sh.cdb.myqcloud.com:14803/thesis');

cursor=exec(conn,'select id,N,density,crowdness,insertion_feasib,cplex_solvable from cases where m_ub<=10 and cplex_solvable is not null');
cases=fetch(cursor);
cases=cases.Data;
datalength=size(cases,1);
for i=1:datalength
    if strcmp(cases{i,6},'feasible')
        cases{i,6}=1;
    elseif strcmp(cases{i,6},'unknown')
        cases{i,6}=0;
    else
        cases{i,6}=3;
    end
end
cases=cell2mat(cases);

figure();
%% sp1
sp1=subplot(1,2,1);hold on;
both_feasib=cases(:,5)==1 & cases(:,6)==1;
insertion_feasib=cases(:,5)==1 & cases(:,6)==0;
cplex_feasib=cases(:,5)==0 & cases(:,6)==1;
both_infeasib=cplex_feasib==0 & cases(:,6)==0;

plot(cases(both_feasib,2)+rand(sum(both_feasib==1),1)*10-5,cases(both_feasib,3),'green.');
plot(cases(insertion_feasib,2)+rand(sum(insertion_feasib==1),1)*10-5,cases(insertion_feasib,3),'blueo');
plot(cases(cplex_feasib,2)+rand(sum(cplex_feasib==1),1)*10-5,cases(cplex_feasib,3),'o','Color',[0.7,0.7,0.1]);
plot(cases(both_infeasib,2)+rand(sum(both_infeasib==1),1)*10-15,cases(both_infeasib,3),'red.');
sp1.FontName='Times New Roman';
xlabel('\fontname{����}��ҵ�� N');
ylabel('\fontname{����}�ռ��� \fontname{Times New Roman}density');
txt1=sprintf('{\\fontname{����}���ҵ����н�} {\\fontname{Times New Roman}%2.1f%%}',sum(both_feasib)/size(cases,1)*100);
leg=legend(sprintf('{\\fontname{����}���ҵ����н�} {\\fontname{Times New Roman}%2.1f%%}',sum(both_feasib)/size(cases,1)*100),sprintf('\\fontname{����}������ʽ�㷨�ҵ� \\fontname{Times New Roman}%2.1f%%',sum(insertion_feasib)/size(cases,1)*100), ...
    sprintf('\\fontname{����}��Cplex�ҵ� \\fontname{Times New Roman}%2.1f%%',sum(cplex_feasib)/size(cases,1)*100),sprintf('\\fontname{����}��δ�ҵ����н� \\fontname{Times New Roman}%2.1f%%',sum(both_infeasib)/size(cases,1)*100));
leg.FontName='Times New Roman';
sp1.FontSize=9;

%% sp2
sp2=subplot(1,2,2);hold on;
both_feasib=cases(:,5)==1 & cases(:,6)==1;
insertion_feasib=cases(:,5)==1 & cases(:,6)==0;
cplex_feasib=cases(:,5)==0 & cases(:,6)==1;
both_infeasib=cplex_feasib==0 & cases(:,6)==0;

plot(cases(both_feasib,2)+rand(sum(both_feasib==1),1)*10-5,cases(both_feasib,4),'green.');
plot(cases(insertion_feasib,2)+rand(sum(insertion_feasib==1),1)*10-5,cases(insertion_feasib,4),'blueo');
plot(cases(cplex_feasib,2)+rand(sum(cplex_feasib==1),1)*10-5,cases(cplex_feasib,4),'o','Color',[0.7,0.7,0.1]);
plot(cases(both_infeasib,2)+rand(sum(both_infeasib==1),1)*10-15,cases(both_infeasib,4),'red.');
sp2.FontName='Times New Roman';
xlabel('\fontname{����}��ҵ�� N');
ylabel('\fontname{����}�ռ�ӵ�� \fontname{Times New Roman}density');
leg=legend(sprintf('{\\fontname{����}���ҵ����н�} {\\fontname{Times New Roman}%2.1f%%}',sum(both_feasib)/size(cases,1)*100),sprintf('\\fontname{����}������ʽ�㷨�ҵ� \\fontname{Times New Roman}%2.1f%%',sum(insertion_feasib)/size(cases,1)*100), ...
    sprintf('\\fontname{����}��Cplex�ҵ� \\fontname{Times New Roman}%2.1f%%',sum(cplex_feasib)/size(cases,1)*100),sprintf('\\fontname{����}��δ�ҵ����н� \\fontname{Times New Roman}%2.1f%%',sum(both_infeasib)/size(cases,1)*100));
sp2.FontSize=9;


%% �Ƚ�both feasible��Ŀ�꺯��ֵ
both_feasib_id=cases(find(both_feasib==1),1);
caseid_str=cell(1,length(both_feasib_id));
for i=1:length(both_feasib_id)
    caseid_str{i}=num2str(both_feasib_id(i));
end
cc=join(caseid_str,',');
cursor=exec(conn,sprintf('select id,result_insertion,cplex_solution from cases where id in %s',['(',cc{1},')']));
cases=fetch(cursor);
cases=cases.Data;

figure();hold on;
objs=zeros(size(cases,1),3);
for i=1:size(cases,1);
    result_insertion=jsondecode(cases{i,2});
    result_cplex=jsondecode(cases{i,3});
    objs(i,1)=cases{i,1};
    objs(i,2)=result_insertion.obj;
    objs(i,3)=result_cplex.Objective;
end
objs

