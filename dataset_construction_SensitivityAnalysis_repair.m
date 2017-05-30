clear;clc;format compact;close all;set(0,'defaultfigurecolor','white');
Paras=LoadParas();
conn=database('thesis','cdb_outerroot','Aa123456','com.mysql.jdbc.Driver','jdbc:mysql://590ab5bb84735.sh.cdb.myqcloud.com:14803/thesis');

for N=30:30:300
    for m_ub=5:1:10
        for density_cate=1:5
            cursor=exec(conn,sprintf('select id from cases where N=%d and m_ub=%d and density_cate=%d and aco_feasib=0 and CIP_ACO_feasib=1',N,m_ub,density_cate));
            cases=fetch(cursor);cases=cases.Data;ids=cell2mat(cases);
            if strcmp(ids,'No Data')
                continue
            end
            id_selected=ids(ceil(rand(1)*length(ids)))
            cursor=exec(conn,sprintf('select id,data,result_aco from cases where id=%d',id_selected));
            cases=fetch(cursor);cases=cases.Data;
            cursor=exec(conn,sprintf('insert into SA_repair(id,data,result_aco) values(%d,''%s'',''%s'')',cases{1,1},cases{1,2},cases{1,3}));
        end
    end
end

close(conn)