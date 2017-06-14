clear;clc;
addpath(',,/')

global Case Paras
format compact
Paras=LoadParas();
conn=database('thesis','root','Csstsari107','com.mysql.jdbc.Driver','jdbc:mysql://rm-bp10rf4zreaw5he66o.mysql.rds.aliyuncs.com:3306/thesis');

cases_tcpc=50;
current=0;
for n=30:30:30
    cursor=exec(conn,sprintf('select count(*) from cases_2 where cplex_solvable is not null and cplex_solvable!=''toexper'' and N=%d',n));
    if strcmp(cursor.Message,'Invalid connection.')
        conn=database('thesis','root','Csstsari107','com.mysql.jdbc.Driver','jdbc:mysql://rm-bp10rf4zreaw5he66o.mysql.rds.aliyuncs.com:3306/thesis');
        cursor=exec(conn,sprintf('select count(*) from cases_2 where cplex_solvable is not null and cplex_solvable!=''toexper'' and N=%d',n));
    end
    temp_count=fetch(cursor);
    temp_count=temp_count.Data{1};
    fprintf('This category already has %d calculated results\n',temp_count);
    if temp_count>=cases_tcpc
        current=current+cases_tcpc;
        continue
    else
        current=current+temp_count;
        left_count=cases_tcpc-temp_count;
    end

    cursor=exec(conn,sprintf('select id,data from cases_2 where cplex_solvable=''toexper'' and N=%d',n));
    if ~isempty(cursor.Message)
        disp('has reconnected to database');
        conn=database('thesis','root','Csstsari107','com.mysql.jdbc.Driver','jdbc:mysql://rm-bp10rf4zreaw5he66o.mysql.rds.aliyuncs.com:3306/thesis');
        cursor=exec(conn,sprintf('select id,data from cases_2 where cplex_solvable=''toexper'' and N=%d',n));
    end
    cases=fetch(cursor);
    cases=cases.Data;

    if strcmp(cases{1},'No Data')
        current=current+left_count;
        fprintf('No Data: %d,%d,%d',n,m_ub,d_cate);
        continue
    end

    casecount=size(cases,1);
    current=current+left_count-casecount;
    for i=1:casecount
        current=current+1;
        fprintf('current progress: %d/%d\n',current,10*cases_tcpc);
        fprintf('current Case id: %d\n',cases{i,1});

        tic

        Case=jsondecode(cases{i,2});
        result=cplex_function_complete();

        toc

        result.computetime=toc;
        cursor=exec(conn,sprintf('update cases_2 set cplex_solvable=''%s'',cplex_solution=''%s'' where id=%d',result.feasibility,jsonencode(result),cases{i,1}))
        if ~isempty(cursor.Message)
            disp('has reconnected to database');
            conn=database('thesis','root','Csstsari107','com.mysql.jdbc.Driver','jdbc:mysql://rm-bp10rf4zreaw5he66o.mysql.rds.aliyuncs.com:3306/thesis');
            exec(conn,sprintf('update cases set cplex_solvable=''%s'',cplex_solution=''%s'' where id=%d',result.feasibility,jsonencode(result),cases{i,1}))
        end
    end
end

close(conn)
% DrawCuboids(result.place_pos);
% feasib=CheckIfConflicting(result.place_pos)