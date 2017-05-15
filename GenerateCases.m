clear;clc;close all;format compact;

global Case Paras

Paras=LoadParas();
m_maxs=[15];
casescales=90;
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
%         current=zeros(1,5);
        current=49;
        for i=1:CaseParas.casecount
            Case=cases{i};
            cases_cated=cell(1,5);
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
%             if current(cateid)>=50
            if current>=50
                continue
            end
%             current(cateid)=current(cateid)+1;
            current=current+1;
%             cases_cated{cateid}.case{current(cateid)}=Case;

            mean_duration(i)=mean(Case.duration);

        end
        % hist(mean_duration);
%         hist(crowdness);

        for i=1:5
%             for j=1:current(i)
            for j=current
                WriteCases('Cases1',j,i,CaseParas.m_max);
            end
        end
    end
end
