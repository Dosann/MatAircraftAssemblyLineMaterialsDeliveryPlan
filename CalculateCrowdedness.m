function crowdedness=CalculateCrowdedness()
global Case Paras

% 物料中心摆放位置lms
lms=ceil(Case.position'+((Case.a+Case.b)/2)'*Paras.v);

lms_lb=min(lms);
lms_ub=max(lms);
crowdedness_list=zeros(1,lms_ub-lms_lb+3);
for i=1:lms_ub-lms_lb+3
    posid=i+lms_lb-2;
    ids=(lms>=posid-1 & lms<=posid+1);
    crowdedness_list(i)=sum(ids.*Case.m')/Paras.C/3;
end
crowdedness=mean(crowdedness_list.^2);

end