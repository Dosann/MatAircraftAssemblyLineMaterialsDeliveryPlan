function solution=cplex_function()
global Case Paras

R=ceil(Case.N/Paras.K);

x=binvar(Paras.K,R,Case.N,'full');
s=intvar(Paras.K,R,'full');
alpha=binvar(Paras.K,R,'full');
ss=intvar(Case.N,1,'full');

Objective=sum(sum(alpha,2),1);
% Objective=-sum(l)

M=2000;
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
Constraints=[Constraints,ss-Case.a+Paras.T<=0];
%约束4
Constraints=[Constraints,s(:,2:R)-s(:,1:R-1)<=alpha(:,1:R-1)*M];
Constraints=[Constraints,s(:,2:R)-s(:,1:R-1)>=alpha(:,1:R-1)*(Paras.Tload+2*Paras.T)];
%x-alpha约束
Constraints=[Constraints,alpha-sum(x,3)<=0,alpha-sum(x,3)/M>=0];
%s-l约束

for k=1:Paras.K
    for r=1:R
        for i=1:Case.N
            Constraints=[Constraints,-(1-x(k,r,i))*M<=ss(i)-s(k,r)<=(1-x(k,r,i))*M];
        end
    end
end
% 变量范围约束
Constraints=[Constraints,-500<=s<=Paras.D,-500<=ss<=Paras.D];

% 摆放问题相关约束
lm=ceil(Case.position'+((Case.a+Case.b)/2)'*Paras.v);
d0=intvar(1,Case.N,'full');
l0=intvar(1,Case.N,'full');
c0=intvar(1,Case.N,'full');
d1_ol=binvar(Case.N,Case.N,'full');
d2_ol=binvar(Case.N,Case.N,'full');
l1_ol=binvar(Case.N,Case.N,'full');
l2_ol=binvar(Case.N,Case.N,'full');
c1_ol=binvar(Case.N,Case.N,'full');
c2_ol=binvar(Case.N,Case.N,'full');

% 约束(3)
Constraints=[Constraints,ss+Paras.T==d0'];
Constraints=[Constraints,ss>=1];
% 约束(9)
Constraints=[Constraints,-1<=l0-lm<=1];
% 约束(10)
Constraints=[Constraints,c0+Case.m'-1<=Paras.C];
% 约束(11)
Constraints=[Constraints,-(repmat(Case.b,1,Case.N)-repmat(d0,Case.N,1))/M+1+diag(ones(1,Case.N)*2)>=d1_ol*1.00001,-(repmat(Case.b,1,Case.N)-repmat(d0,Case.N,1))/M-diag(ones(1,Case.N)*2)<=d1_ol];
Constraints=[Constraints,-(repmat(Case.b,1,Case.N)-repmat(d0,Case.N,1))'/M+1+diag(ones(1,Case.N)*2)>=d2_ol*1.00001,-(repmat(Case.b,1,Case.N)-repmat(d0,Case.N,1))'/M-diag(ones(1,Case.N)*2)<=d2_ol];
Constraints=[Constraints,(repmat(l0,Case.N,1)-repmat(l0',1,Case.N))/M+diag(ones(1,Case.N)*2)+1>=l1_ol*1.00001,(repmat(l0,Case.N,1)-repmat(l0',1,Case.N))/M-diag(ones(1,Case.N)*2)<=l1_ol];
Constraints=[Constraints,-(repmat(l0,Case.N,1)-repmat(l0',1,Case.N))/M+diag(ones(1,Case.N)*2)+1>=l2_ol*1.00001,-(repmat(l0,Case.N,1)-repmat(l0',1,Case.N))/M-diag(ones(1,Case.N)*2)<=l2_ol];
Constraints=[Constraints,-((repmat(c0'+Case.m,1,Case.N)-1)-repmat(c0,Case.N,1))/M+1+diag(ones(1,Case.N)*2)>=c1_ol*1.00001,-((repmat(c0'+Case.m,1,Case.N)-1)-repmat(c0,Case.N,1))/M-diag(ones(1,Case.N)*2)<=c1_ol];
Constraints=[Constraints,-((repmat(c0'+Case.m,1,Case.N)-1)-repmat(c0,Case.N,1))'/M+1+diag(ones(1,Case.N)*2)>=c2_ol*1.00001,-((repmat(c0'+Case.m,1,Case.N)-1)-repmat(c0,Case.N,1))'/M-diag(ones(1,Case.N)*2)<=c2_ol];
Constraints=[Constraints,(d1_ol+d2_ol+l1_ol+l2_ol+c1_ol+c2_ol)>=1];
% 基本约束
Constraints=[Constraints,1<=d0<=Paras.D,1<=l0<=Paras.L,1<=c0<=Paras.C];

options = sdpsettings('solver','cplex','showprogress',1);
options.cplex.MaxTime=3600;
sol=optimize(Constraints,Objective,options);

if strcmp(sol.info,'Successfully solved (CPLEX-IBM)')==true
    solution.Objective=value(Objective);
    display(solution.Objective);
    solution.feasibility='feasible'
    solution.info=sol.info;
%     solution.x=value(x);
    solution.s=value(s);
    solution.alpha=value(alpha);
    solution.ss=value(ss);
    solution.arriv_time=round(value(d0));
    solution.place_pos=round([value(d0);value(l0);value(c0);zeros(1,Case.N)]);
    solution.solvertime=sol.solvertime;
%     solution.d1_ol=value(d1_ol);
%     solution.d2_ol=value(d2_ol);
%     solution.l1_ol=value(l1_ol);
%     solution.l2_ol=value(l2_ol);
%     solution.c1_ol=value(c1_ol);
%     solution.c2_ol=value(c2_ol);
elseif strcmp(sol.info,'Maximum iterations or time limit exceeded (CPLEX-IBM)')==true
    solution.Objective=value(Objective);
    display(solution.Objective);
    solution.feasibility='unknown'
    solution.info=sol.info;
%     solution.x=value(x);
    solution.s=value(s);
    solution.alpha=value(alpha);
    solution.ss=value(ss);
    solution.arriv_time=round(value(d0));
    solution.place_pos=round([value(d0);value(l0);value(c0);zeros(1,Case.N)]);
    solution.solvertime=sol.solvertime;
%     solution.d1_ol=value(d1_ol);
%     solution.d2_ol=value(d2_ol);
%     solution.l1_ol=value(l1_ol);
%     solution.l2_ol=value(l2_ol);
%     solution.c1_ol=value(c1_ol);
%     solution.c2_ol=value(c2_ol);
else
    solution.feasibility='infeasible';
    solution.solvertime=sol.solvertime;

end
% figure(1);axis([-50,max(Paras.Data(:,4))+5,0,Case.N]);
% for i=1:Case.N
%     vehicle=sum(sum(x_value(:,:,i),2).*[1:Paras.K]');
%     rectangle('Position',[l_value(i),i-0.8,Paras.T,0.6],'LineWidth',1,'LineStyle','-','Curvature',[0.2,0.2],'facecolor',vehicle/Paras.K*[0.8,0.8,0.8]);
%     rectangle('Position',[l_value(i)+Paras.T,i-0.8,Paras.Data(i,2)-l_value(i)-Paras.T,0.6],'LineWidth',1,'LineStyle','-','Curvature',[0.2,0.2]);
%     rectangle('Position',[Paras.Data(i,2),i-0.8,Paras.Data(i,4)-Paras.Data(i,2),0.6],'LineWidth',1,'LineStyle','-','Curvature',[0.2,0.2]);
% end
end
