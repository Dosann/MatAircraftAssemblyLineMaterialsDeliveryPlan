close all;
% load('exp_data_12030_8.mat');



[place_pos,feasib,space_confli,space_confli0]=OptimizePlaceSchedule2_random_SA_min(place_pos,arriv_time,area);