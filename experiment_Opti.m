
global Case Paras
format compact
Paras=LoadParas();
conn=database('thesis','cdb_outerroot','Aa123456','com.mysql.jdbc.Driver','jdbc:mysql://590ab5bb84735.sh.cdb.myqcloud.com:14803/thesis');




[place_pos,feasib,space_confli,space_confli0]=OptimizePlaceSchedule2_random_SA_min(place_pos,arriv_time,area);