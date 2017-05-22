global Case Paras

Paras=LoadParas();

conn=database('thesis','root','123456','com.mysql.jdbc.Driver','jdbc:mysql://localhost:3306/thesis')
for i=11:4400
    i
    Case=LoadCase(['Cases1/',f{i}{1}]);
    density=CalculateCrowdedness(1);
    m=split(f{i}{1},'_');
    m=m{3};
    m=str2num(m(2:3));
    cursor=exec(conn,sprintf('insert into cases values(null,"%s",%d,%f,%d,%f)',f{i},size(results{i}.place_pos,2),density,m,density*m))
end