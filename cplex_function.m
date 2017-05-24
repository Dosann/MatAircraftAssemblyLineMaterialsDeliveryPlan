function solution=cplex_function()
global Case Paras

R=ceil(Case.N/Paras.K);

x=binvar(Paras.K,R,Case.N);
s=intvar(Paras.K,R);
alpha=binvar(Paras.K,R);
l=intvar(Case.N,1);

Objective=sum(sum(alpha,2),1);
% Objective=-sum(l)

M=1000;
Constraints=[];
%约束1
Constraints=[Constraints,sum(sum(x,2),1)==1];
%约束2
x2=x;
for i=1:Case.N
    x2(:,:,i)=x(:,:,i)*Case.m(i);
end
Constraints=[Constraints,sum(x2,3)<=Paras.Q];
%约束3
Constraints=[Constraints,l-Case.a+Paras.T<=0];
%约束4
Constraints=[Constraints,s(:,2:R)-s(:,1:R-1)<=alpha(:,1:R-1)*M];
Constraints=[Constraints,s(:,2:R)-s(:,1:R-1)>=alpha(:,1:R-1)*(Paras.Tload+2*Paras.T)];
%x-alpha约束
Constraints=[Constraints,alpha-sum(x,3)<=0,alpha-sum(x,3)/M>=0];
%s-l约束

for k=1:Paras.K
    for r=1:R
        for i=1:Case.N
            Constraints=[Constraints,-(1-x(k,r,i))*M<=l(i)-s(k,r)<=(1-x(k,r,i))*M];
        end
    end
end
%变量范围约束
Constraints=[Constraints,-500<=s<=Paras.D,-500<=l<=Paras.D];

options = sdpsettings('solver','cplex','showprogress',1);
options.cplex.MaxTime=600;
sol=optimize(Constraints,Objective,options);

if strcmp(sol.info,'Successfully solved (CPLEX-IBM)')==true
    solution.feasibility='feasible'
    solution.x=value(x);
    solution.s=value(s);
    solution.alpha=value(alpha);
    solution.l=value(l);
    solution.Objective=value(Objective)
elseif strcmp(sol.info,'Maximum iterations or time limit exceeded (CPLEX-IBM)')==true
    solution.feasibility='unknown'
    solution.x=value(x);
    solution.s=value(s);
    solution.alpha=value(alpha);
    solution.l=value(l);
    solution.Objective=value(Objective)
else
    solution.feasibility='infeasible'

end
% figure(1);axis([-50,max(Paras.Data(:,4))+5,0,Case.N]);
% for i=1:Case.N
%     vehicle=sum(sum(x_value(:,:,i),2).*[1:Paras.K]');
%     rectangle('Position',[l_value(i),i-0.8,Paras.T,0.6],'LineWidth',1,'LineStyle','-','Curvature',[0.2,0.2],'facecolor',vehicle/Paras.K*[0.8,0.8,0.8]);
%     rectangle('Position',[l_value(i)+Paras.T,i-0.8,Paras.Data(i,2)-l_value(i)-Paras.T,0.6],'LineWidth',1,'LineStyle','-','Curvature',[0.2,0.2]);
%     rectangle('Position',[Paras.Data(i,2),i-0.8,Paras.Data(i,4)-Paras.Data(i,2),0.6],'LineWidth',1,'LineStyle','-','Curvature',[0.2,0.2]);
% end
end
