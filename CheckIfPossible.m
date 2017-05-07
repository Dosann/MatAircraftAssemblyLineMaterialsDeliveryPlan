function [results,conclusion]=CheckIfPossible(arriv_time)
global Case Paras

batchDeliv=[1:Case.N;arriv_time;Case.b';ceil(Case.position'+((Case.a+Case.b)/2)'*Paras.v)];
%batchDeliv:第一行jobid,第二行arriv_time,第三行job结束时间，第四行摆放位置
timelist=zeros(1,sum(batchDeliv(3,:)-batchDeliv(2,:)+1));
current=0;
for job=batchDeliv
    timelist(current+1:current+job(3)-job(2)+1)=job(2):job(3);
    current=current+job(3)-job(2)+1;
end
timelist=sort(unique(timelist));
timelistlength=length(timelist);
results=cell(1,timelistlength);
current=0;
for t=timelist
    current=current+1;
    atlineside=(batchDeliv(2,:)<=t)&(batchDeliv(3,:)>=t);
    jobid=batchDeliv(1,atlineside);
    lms=batchDeliv(4,atlineside);
    m=Case.m(atlineside)';
    results{current}.time=t;
%     [results{current}.place,results{current}.feasib,results{current}.space_confli]=CheckIfPossibleIn2D(jobid,lms,m);
    [~,results{current}.feasib,results{current}.space_confli]=CheckIfPossibleIn2D(jobid,lms,m);
end

conclusion.feasib=1;
conclusion.space_confli=0;
for i=1:timelistlength
    if results{i}.feasib==0
        conclusion.feasib=0;
        conclusion.space_confli=conclusion.space_confli+results{i}.space_confli;
    end
end

end