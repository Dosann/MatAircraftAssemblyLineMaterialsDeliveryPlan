function Case=LoadCase(casename,casevolume)
if nargin<2
    casevolume=999999;
end
%% 格式1
% f=fopen(['Cases/',casename],'r');
% Q=fgetl(f);Q=str2double(Q(2:length(Q)));
% T=fgetl(f);T=str2double(T(2:length(T)));
% Tload=fgetl(f);Tload=str2double(Tload(6:length(Tload)));
% D=fgetl(f);D=str2double(D(2:length(D)));
% K=fgetl(f);K=str2double(K(2:length(K)));
% R=fgetl(f);R=str2double(R(2:length(R)));
% fgetl(f);fgetl(f);
% data=zeros(1000,4);
% current=0;
% while ~feof(f)
%     current=current+1;
%     if current>casevolume
%         current=current-1
%         break
%     end
%     data(current,:)=split(fgetl(f));
% end
% data=data(1:current,:);
% for col=data
%     for row=col
%         row=str2double(row)
%     end
% end
% 
% Case.Q=Q;
% Case.T=T;
% Case.Tload=Tload;
% Case.D=D;
% Case.K=K;
% Case.R=R;
% Case.N=size(data,1)
% Case.data=data;
%% 格式2
f=fopen(strcat('Cases/',casename),'r');
fgetl(f);
data=zeros(1000,6);
current=0;
fun=@(x)str2double(x);
while ~feof(f)
    current=current+1;
    if current>casevolume
        current=current-1;
        break
    end
    row=split(fgetl(f));
    data(current,:)=arrayfun(fun,row);
end
data=data(1:current,:);
Case.postpone=50;
data(:,[2,4])=data(:,[2,4])+Case.postpone;

Case.N=size(data,1);
Case.a=data(:,2);
Case.duration=data(:,3);
Case.b=data(:,4);
Case.m=data(:,5);
Case.position=data(:,6);

fclose(f);
end