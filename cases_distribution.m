clear;clc;format compact;close all;
Paras=LoadParas();
conn=database('thesis','root','Csstsari107','com.mysql.jdbc.Driver','jdbc:mysql://rm-bp10rf4zreaw5he66o.mysql.rds.aliyuncs.com:3306/thesis');

current=0;

for n=30:30:300
    for m_ub=5:1:10
        for d_cate=1:5
            cursor=exec(conn,sprintf('select id,density,crowdness,N,m_ub,density_cate from cases where N=%d and m_ub=%d and density_cate=%d limit %d',n,m_ub,d_cate,50));
            cases=fetch(cursor);
            cases=cases.Data;
            if strcmp(cases{1},'No Data')
                fprintf('No Data: %d,%d,%d\n',n,m_ub,d_cate);
                continue
            end
            

            for i=1:size(cases,1)
                current=current+1;
                id(current)=cases{i,1};
                density(current)=cases{i,2};
                crowdness(current)=cases{i,3};
                N(current)=cases{i,4};
                m_ubs(current)=cases{i,5};
                density_cate(current)=cases{i,6};
                
            end
        end
    end
end

colors={'green','red','black','blue','yellow'};
color_order=randperm(5);
set(0,'defaultfigurecolor','white');
f1=figure(1);hold on;
color=[(0.9:-0.1:0)',ones(10,1)*0.5,(0:0.1:0.9)'];
for i=1:10
    subcases=round(N/30)==i;
    order=randperm(length(subcases));
    subcases=subcases(order(1:round(length(subcases)/5)));
    plot(density(subcases),crowdness(subcases),'o','Color',color(i,:));
end
xlabel('\fontname{宋体}空间稠度 \fontname{Times New Roman}density')
ylabel('\fontname{宋体}空间拥挤度 \fontname{Times New Roman}crowdness')
f1.Children.FontSize=9
leg=legend('N=  30','N=  60','N=  90','N=120','N=150','N=180','N=210','N=240','N=270','N=300')
leg.FontName='Times New Roman'
leg.FontSize=9

% for i=1:length(density)
%     plot(density(i),crowdness(i),'o','Color',[0.6,density(i)/2.5,0.2]);
% end


f2=figure(2);
hd=hist(crowdness,20);
b=bar(hd);
b.FaceColor=[0.7,0.2,0.3];
xlabel('\fontname{宋体}空间拥挤度 \fontname{Times New Roman}crowdness')
ylabel('\fontname{宋体}算例频次')
f2.Children.FontSize=9

f3=figure(3);
data=[density',crowdness'];
% b.FaceColor=[0.7,0.2,0.3];
% xlabel('\fontname{宋体}空间拥挤度 \fontname{Times New Roman}crowdness')
% ylabel('\fontname{宋体}算例频次')
% f2.Children.FontSize=9
fre=zeros(100,200);
ser_den=0.02:0.02:2.0
ser_cro=0.1:0.1:20
for i=ser_den
    for j=ser_cro
        fre(round(i/ser_den(1)),round(j/ser_cro(1)))=sum(density>=i-0.1 & density<i & crowdness>=j-0.5 & crowdness<j);
    end
end
b3=bar3(fre(:,1:140));
colormap(jet);
b3p=b3.Parent;
b3p.XTickLabel={'2','4','6','8','10','12','14'};
b3p.YTickLabel={'0.4','0.8','1.2','1.6','2.0'};
b3p.XLabel.String='空间拥挤度';
b3p.YLabel.String='空间稠度';
b3p.ZLabel.String='出现频次';
b3p.XColor=[0,0,0];
b3p.YColor=[0,0,0];
b3p.ZColor=[0,0,0];
b3p.GridColor=[0 0 0];
b3p.CameraPosition=1e3*[-0.0659,1.0712,8.1262];
b3p.CameraTarget=[70.3818   60.0267  750.8018];
b3p.CameraViewAngle=6.2212;
zaxis_han=findobj(b3p,'tag','ZAxis');
colorbar('peer',zaxis_han)


% f4=figure(4);
% [Den,Cro]=meshgrid(ser_den,ser_cro(1:140));
% mesh(Den,Cro,fre(:,1:140)');



close(conn)

% DrawCuboids(result.place_pos);

% feasib=CheckIfConflicting(result.place_pos)