clear;clc;format compact;close all;set(0,'defaultfigurecolor','white');
Paras=LoadParas();
conn=database('thesis','cdb_outerroot','Aa123456','com.mysql.jdbc.Driver','jdbc:mysql://590ab5bb84735.sh.cdb.myqcloud.com:14803/thesis');

cursor=exec(conn,'select id,N,density,crowdness,insertion_feasib from cases where m_ub<=10');
cases=fetch(cursor);
cases=cases.Data;
cases=cell2mat(cases);

figure(1);
%% sp1
sp1=subplot(1,2,1);hold on;
feasib_ones=cases(:,5)==1;
plot(cases(~feasib_ones,2)+rand(sum(feasib_ones==0),1)*10-5,cases(~feasib_ones,3),'red.');
plot(cases(feasib_ones,2)+rand(sum(feasib_ones==1),1)*10-15,cases(feasib_ones,3),'green.');
sp1.FontName='Times New Roman';
xlabel('\fontname{宋体}作业数 N');
ylabel('\fontname{宋体}空间稠度 \fontname{Times New Roman}density');
leg=legend(sprintf('\\fontname{宋体}找不到可行解   \\fontname{Times New Roman}%2.1f%%',100-sum(feasib_ones)/size(cases,1)*100),sprintf('\\fontname{宋体}成功找到可行解 \\fontname{Times New Roman}%2.1f%%',sum(feasib_ones)/size(cases,1)*100));
sp1.FontSize=9;


%% sp2
sp2=subplot(1,2,2);hold on;
feasib_ones=cases(:,5)==1;
plot(cases(~feasib_ones,2)+rand(sum(feasib_ones==0),1)*10-5,cases(~feasib_ones,4),'red.');
plot(cases(feasib_ones,2)+rand(sum(feasib_ones==1),1)*10-15,cases(feasib_ones,4),'green.');
sp2.FontName='Times New Roman';
xlabel('\fontname{宋体}作业数 N');
ylabel('\fontname{宋体}空间拥挤度 \fontname{Times New Roman}crowdness');
leg=legend(sprintf('\\fontname{宋体}找不到可行解   \\fontname{Times New Roman}%2.1f%%',100-sum(feasib_ones)/size(cases,1)*100),sprintf('\\fontname{宋体}成功找到可行解 \\fontname{Times New Roman}%2.1f%%',sum(feasib_ones)/size(cases,1)*100));
sp2.FontSize=9;



% %% svm
% figure(2)
% y1=zeros(size(cases,1),1);
% y1(feasib_ones)=1;
% y1(~feasib_ones)=-1;
% X1=[ones(size(cases,1),1),cases(:,3)];
% model=svmtrain(X1,y1,'kernel_function','linear','showplot','true');
% hyperplane1=model.FigureHandles{1}.Children(1).ContourMatrix(2,end)
% X1=[ones(size(cases,1),1),cases(:,4)];
% model=svmtrain(X1,y1,'kernel_function','linear','showplot','true');
% hyperplane2=model.FigureHandles{1}.Children(1).ContourMatrix(2,end)
% close(2);
% figure(1)
% subplot(1,2,1);plot([0,350],[hyperplane1,hyperplane1],'black-');
% subplot(1,2,2);plot([0,350],[hyperplane2,hyperplane2],'black-');
% find(sort(cases(:,3))>hyperplane1,1)/size(cases,1)
% find(sort(cases(:,4))>hyperplane2,1)/size(cases,1)
% 
% close(conn);

%% classification
precision=zeros(1,200);
for i=0.01:0.01:2
    precision(round(i*100))=(sum(cases(:,3)>=i & cases(:,5)==0)+sum(cases(:,3)<i & cases(:,5)==1))/size(cases,1);
end
max(precision)
plane1=find(precision==max(precision),1)/100
subplot(1,2,1);plot([0,350],[plane1,plane1],'black--');

precision=zeros(1,2000);
for i=0.01:0.01:20
    precision(round(i*100))=(sum(cases(:,4)>=i & cases(:,5)==0)+sum(cases(:,4)<i & cases(:,5)==1))/size(cases,1);
end
max(precision)
plane2=find(precision==max(precision),1)/100
subplot(1,2,2);plot([0,350],[plane2,plane2],'black--');

find(sort(cases(:,3))>plane1,1)/size(cases,1)
find(sort(cases(:,4))>plane2,1)/size(cases,1)
    
    
    