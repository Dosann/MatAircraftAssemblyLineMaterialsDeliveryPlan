% clear;clc;
global Case Paras
format compact
Paras=LoadParas();
conn=database('thesis','cdb_outerroot','Aa123456','com.mysql.jdbc.Driver','jdbc:mysql://590ab5bb84735.sh.cdb.myqcloud.com:14803/thesis');


cursor=exec(conn,sprintf('select id,data from SA_aco'));
cases=fetch(cursor);
cases=cases.Data;
for beta=0.1:0.1:0.4
    for pass_rate=4
        for i=1:size(cases,1)
            cases{i,1}
            
            cursor=exec(conn,sprintf('select id,%s from SA_aco where id=%d',['feasib_',int2str(round(beta*10)),'_',int2str(pass_rate)],cases{i,1}));
            cases2=fetch(cursor);
            cases2=cases2.Data;
            if ~isnan(cases2{1,2})
                disp('Case %d has been researched before.\n')
                continue
            end
            
            Paras.beta=beta;
            Paras.pass_rate=pass_rate;
            Case=jsondecode(cases{i,2});
            result=main_function(Case);
            exec(conn,sprintf('update SA_aco set %s=%d,%s=%d where id=%d',['feasib_',int2str(round(beta*10)),'_',int2str(pass_rate)],result.feasib,['obj_',int2str(round(beta*10)),'_',int2str(pass_rate)],result.bestObj_hist,cases{i,1}))
        end
    end
end

close(conn)