function [place_pos,feasib,space_confli,space_confli0]=OptimizePlaceSchedule(place_order,arriv_time)
global Case Paras

batchDeliv=[1:Case.N;arriv_time;Case.b';ceil(Case.position'+((Case.a+Case.b)/2)'*Paras.v)];
[place_pos,feasib,space_confli,~]=SchedulePlacePositionByOrder(place_order,batchDeliv);
place_pos0=place_pos;
feasib0=feasib;
space_confli0=space_confli;

for i=2:Case.N-1
    obje_jobs=find((place_pos(2,:)>=i-1&place_pos(2,:)<=i+1)==1);
    for j1=obje_jobs
        for j2=obje_jobs
            if j1==j2
                continue
            end
            place_order_tmp=place_order;
            place_order_tmp([j1,j2])=place_order([j2,j1]);
            [place_pos1,feasib1,space_confli1,~]=SchedulePlacePositionByOrder(place_order_tmp,batchDeliv);
            if feasib1==1
                return
            elseif space_confli1<space_confli
                place_pos=place_pos1;
                feasib=feasib1;
                space_confli=space_confli1;
                place_order=place_order_tmp;
            end
        end
    end
end
end
