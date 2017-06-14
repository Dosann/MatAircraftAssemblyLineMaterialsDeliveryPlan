global Case Paras
format compact
Paras=LoadParas();
conn=database('thesis','root','Csstsari107','com.mysql.jdbc.Driver','jdbc:mysql://rm-bp10rf4zreaw5he66o.mysql.rds.aliyuncs.com:3306/thesis');

casecount_real=zeros(5,10);
for i=1:10
    for j=1:5
        cursor=exec(conn,sprintf('select count(*) from cases_2 where m_ub<=10 and N=%d and density_cate=%d',i*30,j));
        result=fetch(cursor);
        casecount_real(j,i)=result.Data{1,1};
    end
end
casecount_real
casecount=importdata('casecount.txt');
casecount_real-casecount