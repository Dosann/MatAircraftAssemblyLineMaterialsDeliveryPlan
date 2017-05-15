function WriteCases(foldername,caseid,category,m_max)
%category: 1(0.0-0.4) 2(0.4-0.8) 3(0.8-1.2) 4(1.2-1.6) 5(1.6-2.0)
global Case

casescale=Case.N;
f=fopen(sprintf('%s/%djob/%d_c%d_m%02d_%04d.txt',foldername,casescale,casescale,category,m_max,caseid),'w');
fprintf(f,'��ҵID	��ʼִ��ʱ��	��ҵʱ��	����ʱ��	������	�̶�װ��λ��\r\n');
for i=1:casescale
    fprintf(f,sprintf('%d\t%d\t%d\t%d\t%d\t%d\r\n',Case.id(i),Case.a(i),Case.duration(i),Case.b(i),Case.m(i),Case.position(i)));
end
fclose(f);
end