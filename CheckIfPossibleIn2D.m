function [place,feasib,space_confli]=CheckIfPossibleIn2D(jobid,lms,m)
global Case Paras

jobcount=length(lms);
jobinfo=[jobid;lms;m];
jobinfo=sortrows(jobinfo',2)';
space_remain=Paras.C*ones(1,Paras.L);
jobs_remain=zeros(1,jobcount);
place=zeros(Case.N,Paras.L);

current=0;
for job=jobinfo
    current=current+1;
    job_remain=job(3);
    if job(2)~=1
        left_remain=space_remain(job(2)-1);
        place(job(1),job(2)-1)=min(left_remain,job_remain);
        job_remain=job_remain-place(job(1),job(2)-1);
        space_remain(job(2)-1)=space_remain(job(2)-1)-place(job(1),job(2)-1);
    end
    if job_remain>0
        mid_remain=space_remain(job(2));
        place(job(1),job(2))=min(mid_remain,job_remain);
        job_remain=job_remain-place(job(1),job(2));
        space_remain(job(2))=space_remain(job(2))-place(job(1),job(2));
    end
    if job_remain>0
        right_remain=space_remain(job(2)+1);
        place(job(1),job(2)+1)=min(right_remain,job_remain);
        job_remain=job_remain-place(job(1),job(2)+1);
        space_remain(job(2)+1)=space_remain(job(2)+1)-place(job(1),job(2)+1);
    end
    jobs_remain(current)=job_remain;
end
space_confli=sum(jobs_remain);
if space_confli>0
    feasib=0;
else
    feasib=1;
end
end