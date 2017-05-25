clear;clc;

global Case Paras
format compact
Paras=LoadParas();
conn=database('thesis','cdb_outerroot','Aa123456','com.mysql.jdbc.Driver','jdbc:mysql://590ab5bb84735.sh.cdb.myqcloud.com:14803/thesis');

cases_tcpc=3;
current=0;
for n=30:30:300
    for m_ub=5:1:7
        for d_cate=1:5
            cursor=exec(conn,sprintf('select count(*) from cases where cplex_solvable is not null and N=%d and m_ub=%d and density_cate=%d',n,m_ub,d_cate));
            if strcmp(cursor.Message,'Invalid connection.')
                conn=database('thesis','cdb_outerroot','Aa123456','com.mysql.jdbc.Driver','jdbc:mysql://590ab5bb84735.sh.cdb.myqcloud.com:14803/thesis');
                cursor=exec(conn,sprintf('select count(*) from cases where cplex_solvable is not null and N=%d and m_ub=%d and density_cate=%d',n,m_ub,d_cate));
            end
            temp_count=fetch(cursor);
            temp_count=temp_count.Data{1};
            fprintf('This categories already has %d calculated results\n',temp_count);
            if temp_count>=cases_tcpc
                current=current+cases_tcpc;
                continue
            else
                current=current+temp_count;
                left_count=cases_tcpc-temp_count;
            end
            
            cursor=exec(conn,sprintf('select id,data from cases where cplex_solvable is null and N=%d and m_ub=%d and density_cate=%d limit %d',n,m_ub,d_cate,left_count));
            if strcmp(cursor.Message,'Invalid connection.')
                conn=database('thesis','cdb_outerroot','Aa123456','com.mysql.jdbc.Driver','jdbc:mysql://590ab5bb84735.sh.cdb.myqcloud.com:14803/thesis');
                cursor=exec(conn,sprintf('select id,data from cases where cplex_solvable is null and N=%d and m_ub=%d and density_cate=%d limit %d',n,m_ub,d_cate,left_count));
            end
            cases=fetch(cursor);
            cases=cases.Data;

            if strcmp(cases{1},'No Data')
                fprintf('No Data: %d,%d,%d',n,m_ub,d_cate);
                continue
            end

            
            for i=1:size(cases,1)
                current=current+1;
                fprintf('current progress: %d/%d\n',current,150*cases_tcpc);
                fprintf('current Case id: %d\n',cases{i,1});

                tic
                
                Case=jsondecode(cases{i,2});
                result=cplex_function_complete();

                toc

                result.computetime=toc;
                try
                    exec(conn,sprintf('update cases set cplex_solvable=''%s'',cplex_solution=''%s'' where id=%d',result.feasibility,jsonencode(result),cases{i,1}))
                catch
                    conn=database('thesis','cdb_outerroot','Aa123456','com.mysql.jdbc.Driver','jdbc:mysql://590ab5bb84735.sh.cdb.myqcloud.com:14803/thesis');
                    exec(conn,sprintf('update cases set cplex_solvable=''%s'',cplex_solution=''%s'' where id=%d',result.feasibility,jsonencode(result),cases{i,1}))
                end
            end
        end
    end
end

close(conn)
% DrawCuboids(result.place_pos);
% feasib=CheckIfConflicting(result.place_pos)