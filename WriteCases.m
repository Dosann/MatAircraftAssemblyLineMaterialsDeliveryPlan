function WriteCases(foldername,caseid,category,m_max)
%category: 1(0.0-0.4) 2(0.4-0.8) 3(0.8-1.2) 4(1.2-1.6) 5(1.6-2.0)
global Case

casescale=Case.N;
f=fopen(sprintf('%s/%djob/%d_c%d_m%02d_%04d.txt',foldername,casescale,casescale,category,m_max,caseid),'w');
fprintf(f,'作业ID	开始执行时间	作业时长	结束时间	物料量	固定装配位置\r\n');
for i=1:casescale
    fprintf(f,sprintf('%d\t%d\t%d\t%d\t%d\t%d\r\n',Case.id(i),Case.a(i),Case.duration(i),Case.b(i),Case.m(i),Case.position(i)));
end
fclose(f);
end