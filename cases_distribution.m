clear;clc;format compact;close all;
Paras=LoadParas();
conn=database('thesis','cdb_outerroot','Aa123456','com.mysql.jdbc.Driver','jdbc:mysql://590ab5bb84735.sh.cdb.myqcloud.com:14803/thesis');

current=0;

for n=30:30:300
    for m_ub=5:1:12
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
figure(1);hold on;
color=[(0.9:-0.1:0)',ones(10,1)*0.5,(0:0.1:0.9)'];
for i=1:10
    subcases=round(N/30)==i;
    order=randperm(length(subcases));
    subcases=subcases(order(1:round(length(subcases)/5)));
    plot(density(subcases),crowdness(subcases),'o','Color',color(i,:));
end
% for i=1:length(density)
%     plot(density(i),crowdness(i),'o','Color',[0.6,density(i)/2.5,0.2]);
% end


figure(2);
hist(crowdness);

close(conn)

% DrawCuboids(result.place_pos);

% feasib=CheckIfConflicting(result.place_pos)