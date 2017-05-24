% clear;clc;
global Case Paras
format compact
Paras=LoadParas();
conn=database('thesis','cdb_outerroot','Aa123456','com.mysql.jdbc.Driver','jdbc:mysql://590ab5bb84735.sh.cdb.myqcloud.com:14803/thesis');

% dirs={'Cases1/30job','Cases1/60job','Cases1/90job','Cases1/120job','Cases1/150job', ...
%     'Cases1/180job','Cases1/210job','Cases1/240job','Cases1/270job','Cases1/300job'};
% files=cell(1,length(dirs));
% for i=1:length(dirs)
%     files_temp=dir(dirs{i});
%     files{i}=cell(1,length(files_temp));
%     for j=1:length(files_temp)
%         if files_temp(j).isdir==0
%             dirs_2=split(dirs{i},'/');
%             files{i}{j}=strcat(dirs_2(2),'/',string(files_temp(j).name));
%         end
%     end
% end
% f={}
% f_num=0
% for i=1:length(files)
%     for j=1:length(files{i})
%         if length(files{i}{j})~=0
%             f_num=f_num+1;
%             f{f_num}=files{i}{j};
%         end
%     end
% end

results=cell(1,1000);
% solvable=LoadSolvable('results/results.txt');
% results_batches=cell(1,50);
cursor=exec(conn,sprintf('select id,data from cases where m_ub=11 limit %d,%d',1200,1200));
cases=fetch(cursor);
cases=cases.Data;
for i=1:size(cases,1)
%     if solvable(i)~=0
%         continue
%     end
    cases{i,1}
    Case=jsondecode(cases{i,2});
    results{i}=main_function(Case);
%     WriteIntoText(results{i},'results/results_aco_20170517.txt');
%     if mod(i,100)==0
%         results_batches=results(i-100+1:i);
%         
%     end
    SaveResult(conn,results{i},cases{i,1})
end

close(conn)