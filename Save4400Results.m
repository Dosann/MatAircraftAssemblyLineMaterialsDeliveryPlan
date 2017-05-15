global Paras
Paras=LoadParas();
conn=database('thesis','cdb_outerroot','Aa123456','com.mysql.jdbc.Driver','jdbc:mysql://590ab5bb84735.sh.cdb.myqcloud.com:14803/thesis');

for i=1:4400
    i
    result=results{i};
    re.bestObj_hist=result.bestObj_hist;
    re.batches=result.batches;
    re.actual_depar_vehid=result.actual_depar_vehid;
    re.arriv_time=result.arriv_time;
    re.place_pos=result.place_pos;
    re.occupy_rate=result.occupy_rate;
    re.feasib=result.feasib;
    re.space_confli=result.space_confli;
    re_json=jsonencode(re);
    exec(conn,sprintf('update cases set result_aco=''%s'' where id=%d',re_json,i));
end

close(conn)