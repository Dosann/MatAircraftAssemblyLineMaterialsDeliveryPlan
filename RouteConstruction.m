function ants=RouteConstruction(ants,pher,visib)
global trileft Case Paras

N=Case.N;
% % ��������;�����ߵĴ���
% pass=CalculatePassCount(ants);

% �������ϴӵ�iǰ�������ת�Ƹ���
pro=((pher+0.1).^Paras.alpha).*(visib.^Paras.beta);
% pro=(pher+0.1).^Paras.alpha;
for i=1:N+1
    pro(i,1:i)=pro(i,1:i)/sum(pro(i,:));
    pro(1:i,i)=pro(i,1:i)/sum(pro(i,:));
end
for i=1:N+1
    pro(1,1)=0;
end

% ��������ϵ��ƶ�·��
ant_count=size(ants,1);
randmat=rand(ant_count,N*2);
for i=1:ant_count
    undistr_jobs=true(1,N+1);
    ant_temp=[-ones(1,2*N-1),0];
    j=N;
    k=2*N-1;
    remain_capa=Paras.Q;
    last_job=0;
    while j>0
        
        if i==7&&j==8&&k==22
            kk=1;
        end
        
        
        try
            addable_job_in_undistrjobs=[0,find(Case.m(undistr_jobs(2:N+1))<=remain_capa)']; % ��������δ��ѡ�����У������������������������(��jobid)
        catch
            kk=1;
        end
        numel_ajiu=numel(addable_job_in_undistrjobs);
%         last_job_id=find(addable_job_in_undistrjobs==last_job,1)-1;
%         if numel(last_job_id)~=0
%             addable_job_in_undistrjobs=[addable_job_in_undistrjobs(1:last_job_id-1),addable_job_in_undistrjobs(last_job_id+1:numel_ajiu)];
%             numel_ajiu=numel_ajiu-1;
%         end
        if numel_ajiu==1 % �޿�װ�ػ���
            ant_temp(k)=0;
            last_job=0;
            remain_capa=Paras.Q;
            k=k-1;
        else % �п�װ�ػ���
            undistr_jobs_index=find(undistr_jobs==true)-1; % ������δ��ѡ���ϵ�jobid
            try
                candidate_jobid=undistr_jobs_index(addable_job_in_undistrjobs+1); % �����ѡ���ϵ�jobid����������0
                probabs=pro(last_job+1,candidate_jobid+1);
            catch
                kk=1;
            end
            probabs=cumsum(probabs/sum(probabs));
%             k
%             undistr_jobs
%             j
%             probabs
            try
                next_vert_in_addablejobs_zerosincluded=find(probabs>=randmat(i,k),1);
            catch
                kk=1;
            end
            
            if next_vert_in_addablejobs_zerosincluded==1
                remain_capa=Paras.Q;
                ant_temp(k)=0;
                last_job=0;
                k=k-1;
            else
                try
                    next_vert=candidate_jobid(next_vert_in_addablejobs_zerosincluded);
                catch
                    kk=1;
                end
                try
                    ant_temp(k)=next_vert;
                catch
                    kk=1;
                end
                last_job=next_vert;
                k=k-1;
                undistr_jobs(next_vert+1)=false;
                
                try
                    remain_capa=remain_capa-Case.m(next_vert);
                catch
                    kk=1;
                end
                if remain_capa<0
                    kk=1;
                end
                j=j-1;
            end
        end
    end
    ants(i,1:2*N-k)=ant_temp(k+1:2*N);
    ants(i,2*N-k+1:2*N)=0;
end
end