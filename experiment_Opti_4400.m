close all;
global Case Paras
load('results_4400.mat');
id=2800;
Case=LoadCase(strcat('Cases1/',f{id}{1}));
Paras=LoadParas();
arriv_time=results{id}.arriv_time;
[place_pos,~,~,area,~]=SchedulePlacePosition(arriv_time);


[place_pos,feasib,space_confli,space_confli0]=OptimizePlaceSchedule2_random_SA_min(place_pos,arriv_time,area);