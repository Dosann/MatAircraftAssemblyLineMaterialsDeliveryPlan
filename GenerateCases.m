clear;clc;close all;format compact;
conn=database('thesis','cdb_outerroot','Aa123456','com.mysql.jdbc.Driver','jdbc:mysql://590ab5bb84735.sh.cdb.myqcloud.com:14803/thesis');
global Case Paras

Paras=LoadParas();
m_maxs=[6,7,8,9,11];
casescales=30:30:300;
tic
for a=m_maxs
    for b=casescales
        [a,b]
        toc
        CaseParas.casecount=10000;
        CaseParas.casescale=b;
        CaseParas.a_lambda=2;
        CaseParas.duration_max=10;
        CaseParas.m_max=a;
        CaseParas.position_max=10;

        cases=GenerateRandomCases(CaseParas);

        crowdness=zeros(1,CaseParas.casecount);
        mean_duration=zeros(1,CaseParas.casecount);
        current=zeros(1,5);
        cases_cated=cell(1,5);
        for i=1:CaseParas.casecount
            Case=cases{i};
            crowdness(i)=CalculateCrowdedness();
            if crowdness(i)<0.4
                cateid=1;
            elseif crowdness(i)<0.8
                cateid=2;
            elseif crowdness(i)<1.2
                cateid=3;
            elseif crowdness(i)<1.6
                cateid=4;
            elseif crowdness(i)<2.0
                cateid=5;
            else
                cateid=6;
            end
            if cateid==6
                continue;
            end
            if current(cateid)>=50
                continue
            end
            if sum(current(cateid))==250
                break
            end
            current(cateid)=current(cateid)+1;
            cases_cated{cateid}.case{current(cateid)}=cases{i};

            mean_duration(i)=mean(Case.duration);

        end
        % hist(mean_duration);
%         hist(crowdness);

        for i=1:5
            for j=1:current(i)
                Case=cases_cated{i}.case{j};
                clear Case1
                Case1.postpone=400;
                Case1.N=Case.N;
                Case1.a=Case.a+400;
                Case1.duration=Case.duration;
                Case1.b=Case.b+400;
                Case1.m=Case.m;
                Case1.position=Case.position;
                Case=Case1;
                Case1=jsonencode(Case1);
                casename=sprintf('%djob/%d_c%d_m%02d_%04d.txt',b,b,i,a,j);
                density=CalculateCrowdedness(1);
                crowdness=density*a;
                exec(conn,sprintf('insert into cases(casename,N,density,density_cate,m_ub,crowdness,data) values(''%s'',%d,%f,%d,%d,%f,''%s'')', ...
                    casename,b,density,i,a,crowdness,jsonencode(Case)));
%                 WriteCases('Cases1',j,i,CaseParas.m_max);
            end
        end
    end
end
close(conn);