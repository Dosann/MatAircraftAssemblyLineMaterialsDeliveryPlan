function feasib=CheckIfConflicting(place_pos)
global Case Paras

if sum(place_pos(4,:))>0
    feasib=0;
    return;
end

% 物料中心摆放位置lms
lms=ceil(Case.position'+((Case.a+Case.b)/2)'*Paras.v);

area=zeros(Paras.D,Paras.L,Paras.C);

for jobid=1:Case.N
    try
        area_to_place=sum(sum(area(place_pos(1,jobid):Case.b(jobid),place_pos(2,jobid),place_pos(3,jobid):place_pos(3,jobid)+Case.m(jobid)-1)));
    catch
        kkk=1;
    end
        
    if area_to_place>0
        feasib=0;
        return
    end
    area(place_pos(1,jobid):Case.b(jobid),place_pos(2,jobid),place_pos(3,jobid):place_pos(3,jobid)+Case.m(jobid)-1)=1;
end

feasib=1;
return
end