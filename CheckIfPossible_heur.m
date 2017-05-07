function conclusion=CheckIfPossible_heur(arriv_time)
global Case Paras
batchDeliv=[1:Case.N;arriv_time;Case.b';ceil(Case.position'+((Case.a+Case.b)/2)'*Paras.v)];
[place_pos,feasib,space_confli,area,place_order]=SchedulePlacePosition(arriv_time);
conclusion.feasib=feasib;
conclusion.space_confli=space_confli;
conclusion.place_order=place_order;
conclusion.place_pos=place_pos;
end





function [place_pos,feasib,space_confli,area,place_order]=SchedulePlacePosition(arriv_time)
global Case Paras
area=zeros(Paras.D,Paras.L,Paras.C);
lm_pos=ceil(Case.position'+((Case.a+Case.b)/2)'*Paras.v);
%time:第一行jobid,第二行arriv_time,第三行job结束时间，第四行摆放位置
batchDeliv=sortrows([1:length(arriv_time);arriv_time;Case.b';lm_pos]',2)'; 
time_uni=unique(batchDeliv(2,:));
conflict_count=0;
num_time=size(batchDeliv,2);
place_pos=zeros(4,num_time);
place_order=zeros(1,num_time);
current=0;
for t=time_uni
    time_t=batchDeliv(:,find(batchDeliv(2,:)==t,1,'first'):find(batchDeliv(2,:)==t,1,'last'));
    num_t=size(time_t,2);
    time_t=sortrows(time_t',4)';
    lm_uni=unique(time_t(4,:));
    for lm=lm_uni
        time_lm=time_t(:,find(time_t(4,:)==lm,1,'first'):find(time_t(4,:)==lm,1,'last'));
        num_lm=size(time_lm,2);
        if num_lm>1
            time_lm(5,:)=(time_lm(3,:)-time_lm(2,:)).*Case.m(time_lm(1,:))';%以时间×物料大小作为体积，并从大到小排序
            time_lm=fliplr(sortrows(time_lm',5)');
        end
        for job=time_lm
            current=current+1;
            place_order(job(1))=current;
            c_m1=find(area(t,lm-1,:)==0,1,'first');
            
            if length(c_m1)>0 && c_m1+Case.m(job(1))-1<=Paras.C && sum(sum(area(t:job(3),lm-1,c_m1:c_m1+Case.m(job(1))-1)>0))==0
                area(t:job(3),lm-1,c_m1:c_m1+Case.m(job(1))-1)=1;
                place_pos(1:3,job(1))=[t;lm-1;c_m1];
            else
                c_m2=find(area(t,lm,:)==0,1,'first');
                if length(c_m2)>0 && c_m2+Case.m(job(1))-1<=Paras.C && sum(sum(area(t:job(3),lm,c_m2:c_m2+Case.m(job(1))-1)>0))==0
                    area(t:job(3),lm,c_m2:c_m2+Case.m(job(1))-1)=1;
                    place_pos(1:3,job(1))=[t;lm;c_m2];
                else
                    c_m3=find(area(t,lm+1,:)==0,1,'first');
                    if length(c_m3)>0 && c_m3+Case.m(job(1))-1<=Paras.C && sum(sum(area(t:job(3),lm+1,c_m3:c_m3+Case.m(job(1))-1)>0))==0
                        area(t:job(3),lm+1,c_m3:c_m3+Case.m(job(1))-1)=1;
                        place_pos(1:3,job(1))=[t;lm+1;c_m3];
                    else
                        place_pos(:,job(1))=[t;lm;1;1];
                        conflict_count=conflict_count+1;
                    end
                end
            end
        end
    end
end
if conflict_count>0
    feasib=0;
else
    feasib=1;
end
space_confli=conflict_count;
end