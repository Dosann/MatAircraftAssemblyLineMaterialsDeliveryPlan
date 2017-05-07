function DrawCuboids(place_pos)
global Case Paras

figure;hold on;
for i=1:Case.N
    DrawCuboid(place_pos(1,i)-1,place_pos(2,i)-1,place_pos(3,i)-1,Case.b(i)-place_pos(1,i)+1,1,Case.m(i),place_pos(4,i));
end
end