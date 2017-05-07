function pass=CalculatePassCount(ants)
[size1,size2]=size(ants);
pass=zeros(1+size2/2);
for i=1:size1
    lastPath=find(ants(i,:)>0,1,'last');
    v1=ants(i,1:lastPath);
    v2=ants(i,2:lastPath+1);
    % 交换v1和v2中 v1<v2的值
    v1btv2=v1<v2;
    temp=v1(v1btv2);
    v1(v1btv2)=v2(v1btv2);
    v2(v1btv2)=temp;
    v1=v1+1;
    v2=v2+1;
    % 对该ants群路过的路径pass+1
    for j=1:numel(v1)
        pass(v1(j),v2(j))=pass(v1(j),v2(j))+1;
    end
    % 对返回仓库和从仓库出发的路径加一个惩罚
    pass(:,1)=pass(:,1)*0;
end
end