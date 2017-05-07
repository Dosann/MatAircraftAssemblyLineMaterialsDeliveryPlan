function [place_pos,feasib,space_confli,area]=SchedulePlacePositionByOrder(place_order,batchDeliv)
global Case Paras
place_pos=zeros(3,Case.N);
place_order=sortrows([1:Case.N;place_order]',2)';
place_order=place_order(1,:);
area=zeros(Paras.D,Paras.L,Paras.C);
conflict_count=0;
for i=place_order
    t=batchDeliv(2,i);
    lm=batchDeliv(4,i);
    c_m1=find(area(t,lm-1,:)==0,1,'first');

    if length(c_m1)>0 && c_m1+Case.m(i)-1<=Paras.C && sum(sum(area(t:batchDeliv(3,i),lm-1,c_m1:c_m1+Case.m(i)-1)>0))==0
        area(t:batchDeliv(3,i),lm-1,c_m1:c_m1+Case.m(i)-1)=1;
        place_pos(:,i)=[t;lm-1;c_m1];
    else
        c_m2=find(area(t,lm,:)==0,1,'first');
        if length(c_m2)>0 && c_m2+Case.m(i)-1<=Paras.C && sum(sum(area(t:batchDeliv(3,i),lm,c_m2:c_m2+Case.m(i)-1)>0))==0
            area(t:batchDeliv(3,i),lm,c_m2:c_m2+Case.m(i)-1)=1;
            place_pos(:,i)=[t;lm;c_m2];
        else
            c_m3=find(area(t,lm+1,:)==0,1,'first');
            if length(c_m3)>0 && c_m3+Case.m(i)-1<=Paras.C && sum(sum(area(t:batchDeliv(3,i),lm+1,c_m3:c_m3+Case.m(i)-1)>0))==0
                area(t:batchDeliv(3,i),lm+1,c_m3:c_m3+Case.m(i)-1)=1;
                place_pos(:,i)=[t;lm+1;c_m3];
            else
                conflict_count=conflict_count+1;
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