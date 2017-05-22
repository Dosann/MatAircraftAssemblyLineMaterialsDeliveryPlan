global Case Paras

Paras=LoadParas();

conn=database('thesis','root','123456','com.mysql.jdbc.Driver','jdbc:mysql://localhost:3306/thesis');
for i=1:4400
    i
    filename=['Cases1/',f{i}{1}];
    Case=LoadCase(filename);
    case_json=jsonencode(Case);
    cursor=exec(conn,sprintf('update cases set data=''%s'' where id=%d',case_json,i));
end