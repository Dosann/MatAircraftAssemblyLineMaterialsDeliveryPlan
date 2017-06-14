% 确定各种算例规模（N=30-300）的算例中各密度（5种密度）分别选取几个算例
clear;clc;
addpath('../');

casecount0=importdata('casecount0.txt');
casecountPerN=50;
casecount=zeros(5,10);
for i=1:10
    for j=1:5
        casecount(j,i)=ceil(sum(casecount0((j-1)*6+1:j*6,i))/casecount0(end,i)*casecountPerN);
    end
    excessCount=sum(casecount(:,i))-casecountPerN;
    disp(excessCount);
    rank=randperm(5);
    for j=5:-1:1
        j=rank(j);
        if excessCount==0
            break
        end
        excessCountToExtract=min(sum(casecount0((j-1)*6+1:j*6,i)),excessCount);
        casecount(j,i)=casecount(j,i)-excessCountToExtract;
        excessCount=excessCount-excessCountToExtract;
%         if excessCountToExtract~=0
%             disp(excessCountToExtract);
%         end
    end
end
casecount