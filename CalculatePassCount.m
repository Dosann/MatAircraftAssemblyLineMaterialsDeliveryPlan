function pass=CalculatePassCount(ants)
[size1,size2]=size(ants);
pass=zeros(1+size2/2);
for i=1:size1
    lastPath=find(ants(i,:)>0,1,'last');
    v1=ants(i,1:lastPath);
    v2=ants(i,2:lastPath+1);
    % ����v1��v2�� v1<v2��ֵ
    v1btv2=v1<v2;
    temp=v1(v1btv2);
    v1(v1btv2)=v2(v1btv2);
    v2(v1btv2)=temp;
    v1=v1+1;
    v2=v2+1;
    % �Ը�antsȺ·����·��pass+1
    for j=1:numel(v1)
        pass(v1(j),v2(j))=pass(v1(j),v2(j))+1;
    end
    % �Է��زֿ�ʹӲֿ������·����һ���ͷ�
    pass(:,1)=pass(:,1)*0;
end
end