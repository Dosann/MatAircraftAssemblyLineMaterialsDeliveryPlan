clear;clc;
global Case Paras
format compact
Paras=LoadParas();
conn=database('thesis','cdb_outerroot','Aa123456','com.mysql.jdbc.Driver','jdbc:mysql://590ab5bb84735.sh.cdb.myqcloud.com:14803/thesis');

cursor=exec(conn,'select density,m_ub,N from cases where m_ub in (5,6,7,8,9,10,11,12)');
cases=fetch(cursor);
cases=cases.Data;

ma=zeros(40,10);
for i=1:size(cases,1)
    i
    if cases{i,1}<0.4
        cate=1;
    elseif cases{i,1}<0.8
        cate=2;
    elseif cases{i,1}<1.2
        cate=3;
    elseif cases{i,1}<1.6
        cate=4;
    elseif cases{i,1}<2.0
        cate=5;
    else
        cate=6;
    end
    if cate==6
        continue
    end
    
    row=cases{i,2}-4+(cate-1)*8;
    column=round(cases{i,3}/30);
    ma(row,column)=ma(row,column)+1;
end
close(conn);