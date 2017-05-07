function [ants,pher,visib]=Initialize()
global Case Paras
% 初始化蚂蚁群路线
% ants=InitializeAnts();
pher_ini=rand(1+Case.N);
visib_ini=rand(1+Case.N);
ants=floor(rand(Paras.popsize,2*Case.N));
ants=RouteConstruction(ants,pher_ini,visib_ini);
% 初始化信息素浓度
pher=InitializePher(ants);
% 初始化可见度
visib=InitializeVisib();
end

function ants=InitializeAnts()
global Case Paras
ants=zeros(Paras.popsize,2*Case.N);
for i=1:Paras.popsize
    ant_route=randperm(Case.N);
    ant_route_comple=zeros(2*Case.N);
    
    p=Case.N;
    q=2*Case.N;
    remain_capa=Paras.Q;
    while p>0
        remain_capa=remain_capa-Case.m(ant_route(p));
        if remain_capa<0
            ant_route_comple(q)=0;
            q=q-1;
            ant_route_comple(q)=ant_route(p);
            remain_capa=Paras.Q-Case.m(ant_route(p));
            q=q-1;
            p=p-1;
        else
            ant_route_comple(q)=ant_route(p);
            q=q-1;
            p=p-1;
        end
    end
    route_length=2*Case.N-q;
    ants(i,1:route_length)=ant_route_comple(q+1:2*Case.N);
end
end

function pher=InitializePher(ants)
[bestObj,bestAnt,bestAnts]=FindBest(ants,1);
pass=CalculatePassCount(bestAnt);
pher=zeros(1+size(ants,2)/2);
pher(pass>0)=1;
end

function visib=InitializeVisib()
global Case
visib=zeros(Case.N+1);
for i=2:Case.N+1
    visib(i,2:Case.N+1)=1./(abs((Case.a(i-1)-Case.a)')+1);
end
visib(:,1)=1;
visib(1,:)=1;
end
    