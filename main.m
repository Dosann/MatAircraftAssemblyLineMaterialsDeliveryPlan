clear;clc;close all;
tic
format compact
global trileft Case Paras
% rand('state',0)
Case=LoadCase('120job/j12030_8.txt',120);
Paras=LoadParas();

[ants,pher,visib]=Initialize;
itercount=0;
[bestObj,bestAnt]=FindBest(ants,1);
bestObj_hist=bestObj;bestAnt_hist=bestAnt;
bestObjProcess=[bestObj;-ones(Paras.maxiter,1)];
bestObjHistProcess=[bestObj;-ones(Paras.maxiter,1)];
bestAntProcess=[bestAnt;-ones(Paras.maxiter,size(ants,2))];
trileft=tril(true(Case.N+1),-1);
while 1
    itercount=itercount+1
    
    ants=RouteConstruction(ants,pher,visib);
    [bestObj,bestAnt,bestAnts]=FindBest(ants,Paras.best_ant_count);
    pher=RenewPheromone(pher,bestAnts,bestAnt_hist);
    if bestObj<bestObj_hist
        bestObj_hist=bestObj;
        bestAnt_hist=bestAnt;
    end
    
    bestObjProcess(itercount+1)=bestObj;
    bestAntProcess(itercount+1,:)=bestAnt;
    bestObjHistProcess(itercount+1)=bestObj_hist;
    if Termination(bestObj,itercount,Paras.maxiter)
        break
    end
end

figure(1);hold on
plot(1:itercount,bestObjProcess(1:itercount));
plot(bestObjHistProcess,'r')

figure(2);axis([0,max(Case.b)+5,0,Case.N]);hold on;
[bestObj_history,bestAnt_history,bestAnts,batches,actual_depar_vehid,arriv_time,place_pos,bestArea,space_confli,place_order]=FindBest(bestAnt_hist,1);
bestBatchDeliv=[1:Case.N;arriv_time{1};Case.b';ceil(Case.position'+((Case.a+Case.b)/2)'*Paras.v);Case.m'];
bestPlaceOrder=place_order{1};
vehicle=bestObj_history
actual_depar_vehid_job=zeros(1,Case.N); 
for i=1:length(batches{1})
    for j=batches{1}{i}
        actual_depar_vehid_job(j)=actual_depar_vehid{1}(i);
    end
end
for i=1:Case.N
    rectangle('Position',[arriv_time{1}(i)-Paras.T,i-0.8,Paras.T,0.6],'LineWidth',1,'LineStyle','-','Curvature',[0.2,0.2],'facecolor',actual_depar_vehid_job(i)/Paras.K*[0.8,0.8,0.8]);
    rectangle('Position',[arriv_time{1}(i),i-0.8,Case.a(i)-arriv_time{1}(i),0.6],'LineWidth',1,'LineStyle','-','Curvature',[0.2,0.2]);
    rectangle('Position',[Case.a(i),i-0.8,Case.b(i)-Case.a(i),0.6],'LineWidth',1,'LineStyle','-','Curvature',[0.2,0.2]);
    
    plot(ones(1,2)*(arriv_time{1}(i)-Paras.T),[0,Case.N],'--')
    plot(ones(1,2)*arriv_time{1}(i),[0,Case.N],'--')
    plot(ones(1,2)*Case.a(i),[0,Case.N],'--')
    plot(ones(1,2)*Case.b(i),[0,Case.N],'--')
end
sum(sum(sum(bestArea)))/size(bestArea,1)/size(bestArea,2)/size(bestArea,3)
toc
figure(3);hold on
% colormap([0,0,0;1,1,1]);
for i=1:Case.N
    DrawCuboid(place_pos{1}(1,i)-1,place_pos{1}(2,i)-1,place_pos{1}(3,i)-1,Case.b(i)-place_pos{1}(1,i)+1,1,Case.m(i),place_pos{1}(4,i));
end

arriv_time=arriv_time{1};place_pos=place_pos{1};area=bestArea;