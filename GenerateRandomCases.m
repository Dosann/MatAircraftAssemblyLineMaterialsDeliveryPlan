function cases=GenerateRandomCases(CParas)

cases=cell(1,CParas.casecount);
for i=1:CParas.casecount
    cases{i}.id=1:CParas.casescale;
    cases{i}.N=CParas.casescale;
    cases{i}.a=GenerateA(CParas.casescale,CParas.a_lambda);
    cases{i}.duration=ceil(rand(1,CParas.casescale)*CParas.duration_max);
    cases{i}.b=cases{i}.a+cases{i}.duration;
    cases{i}.m=ceil(rand(1,CParas.casescale)*CParas.m_max);
    cases{i}.position=ceil(rand(1,CParas.casescale)*CParas.position_max);
end

end

%% 生成作业开始时间a
function a=GenerateA(casescale,poisson_lambda)
a=zeros(1,casescale);
current=casescale;
t=0;
while current>0
    new_job_count=random('Poisson',poisson_lambda);
    if new_job_count>current
        new_job_count=current;
    end
    if new_job_count>0
        a(casescale-current+1:casescale-current+new_job_count)=t;
    end
    t=t+1;
    current=current-new_job_count;
end
end
