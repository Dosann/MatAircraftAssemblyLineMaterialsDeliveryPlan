clear;clc;format compact;set(0,'defaultfigurecolor','white');
global Case Paras
Paras=LoadParas();
conn=database('thesis','cdb_outerroot','Aa123456','com.mysql.jdbc.Driver','jdbc:mysql://590ab5bb84735.sh.cdb.myqcloud.com:14803/thesis');

cursor=exec(conn,'select id,data from cases where N=90 and density>0.8 and density<1.2 limit 1');
cases=fetch(cursor);
cases=cases.Data;

Case=jsondecode(cases{1,2});
Case.a=Case.a-400;
Case.b=Case.b-400;
lms=CalculateLms();
bars=[]
ms=[]
current=1;
for i=min(lms):max(lms);
    bars(current)=sum(lms==i);
    ms(current)=sum(Case.m(lms==i))/Paras.C;
    current=current+1;
end

% b=bar(bars)
% set(b,'FaceColor',[0.4,0.3,0.3])
% xlabel('线边单元编号')
% ylabel('物料数')

figure(1);hold on;
[ax,h1,h2]=plotyy(min(lms):max(lms),bars,min(lms):max(lms),ms,@plot,@bar)
set(h1,'Color',[0.8,0.4,0.3])
set(h2,'FaceColor',[0.2,0.7,0.8])
set(ax,'YColor','black')
ylabel(ax(2),'\fontname{宋体}物料总量与线边单元容量上限之比')
ylabel(ax(1),'\fontname{宋体}物料数')
xlabel('\fontname{宋体}线边单元编号')
ax(1).YLabel.FontSize=12;
ax(2).YLabel.FontSize=12;
ax(1).XLabel.FontSize=12;
legend('\fontname{宋体}物料量','\fontname{宋体}物料总量与线边单元容量上限之比');
ax(1).FontSize=9;
ax(2).FontSize=9



close(conn)