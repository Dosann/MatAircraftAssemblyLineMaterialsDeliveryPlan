function result=main_function(Case1)
global trileft Case Paras
Case=Case1;
Paras=LoadParas();

[ants,pher,visib]=Initialize;
itercount=0;
[bestObj,bestAnt]=FindBest(ants,1);
bestObj_hist=bestObj;bestAnt_hist=bestAnt;
bestObjProcess=[bestObj;-ones(Paras.maxiter,1)];
bestAntProcess=[bestAnt;-ones(Paras.maxiter,size(ants,2))];
trileft=tril(true(Case.N+1),-1);
while 1
    itercount=itercount+1;
    
    ants=RouteConstruction(ants,pher,visib);
    [bestObj,bestAnt,bestAnts]=FindBest(ants,Paras.best_ant_count);
    pher=RenewPheromone(pher,bestAnts,bestAnt_hist);
    if bestObj<bestObj_hist
        bestObj_hist=bestObj;
        bestAnt_hist=bestAnt;
    end
    
    bestObjProcess(itercount+1)=bestObj;
    bestAntProcess(itercount+1,:)=bestAnt;
    if Termination(bestObj,itercount,Paras.maxiter)
        break
    end
end

% figure(1)
% plot(1:itercount,bestObjProcess(1:itercount));

% figure(2);axis([0,max(Case.b)+5,0,Case.N]);hold on;
[bestObj_history,bestAnt_history,bestAnts,batches,actual_depar_vehid,arriv_time,place_pos,area,space_confli]=FindBest(bestAnt_hist,1);
actual_depar_vehid_job=zeros(1,Case.N); 
for i=1:length(batches{1})
    for j=batches{1}{i}
        actual_depar_vehid_job(j)=actual_depar_vehid{1}(i);
    end
end

result.bestObj_hist=bestObj_history;
result.bestAnt_hist=bestAnt_history;
result.batches=batches{1};
result.actual_depar_vehid=actual_depar_vehid{1};
result.arriv_time=arriv_time{1};
result.place_pos=place_pos{1};
result.occupy_rate=sum(sum(sum(area)))/size(area,1)/size(area,2)/size(area,3);
result.space_confli=space_confli(1);
result.pher=pher;
result.area=area;
% for i=1:Case.N
%     rectangle('Position',[arriv_time{1}(i)-Paras.T,i-0.8,Paras.T,0.6],'LineWidth',1,'LineStyle','-','Curvature',[0.2,0.2],'facecolor',actual_depar_vehid_job(i)/Paras.K*[0.8,0.8,0.8]);
%     rectangle('Position',[arriv_time{1}(i),i-0.8,Case.a(i)-arriv_time{1}(i),0.6],'LineWidth',1,'LineStyle','-','Curvature',[0.2,0.2]);
%     rectangle('Position',[Case.a(i),i-0.8,Case.b(i)-Case.a(i),0.6],'LineWidth',1,'LineStyle','-','Curvature',[0.2,0.2]);
%     
%     plot(ones(1,2)*(arriv_time{1}(i)-Paras.T),[0,Case.N],'--')
%     plot(ones(1,2)*arriv_time{1}(i),[0,Case.N],'--')
%     plot(ones(1,2)*Case.a(i),[0,Case.N],'--')
%     plot(ones(1,2)*Case.b(i),[0,Case.N],'--')
% end


% figure(3);hold on
% for i=1:Case.N
%     DrawCuboid(place_pos{1}(1,i)-1,place_pos{1}(2,i)-1,place_pos{1}(3,i)-1,Case.b(i)-place_pos{1}(1,i)+1,1,Case.m(i)+1);
% end