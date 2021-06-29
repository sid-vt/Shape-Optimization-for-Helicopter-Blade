%% Clearing and setting up environment
clear; clc; close all

%% Global Variable Settings
global xiters1
global xiters2
global xiters3
global xnpiters
xiters1 =[];xiters2 =[];xiters3 =[];xnpiters=[];

%%
%     M(3) = 3.04;    M(4) = 1.67;    M(6) = 6.40;    M(7) = 7.46;
%     M(8) = 10.75;    M(9) = 5.21;    M(10) = 6.55;    M(11) = 6.6;

X0 = [6.40,7.46,10.75,6.55];
dxlb = 0*ones(size(X0));
dxub = 50*ones(size(X0));
%% Optimizer Settings
options.Display='iter';
options.MaxIter=100;
options.TolX=0.0001;
options.TolFun=0.0001;
options.TolCon=0.0001;
options.MoveLimit=0.1;
options.TrustRegion='on';
options.MaxFunEvals = 1000;

%% Optimizer
[x,f,exitflag,output] = slp_trust(@funcs,X0,options,dxlb,dxub,@grads);

disp(' ')
disp('Final Design Variables, X')
disp(x)

%% Plotting
figure(2)
iter=(0:output.iterations);
[AX,H1,H2]=plotyy(iter,output.f,iter,abs(max(output.g,[],1)),'plot','semilogy');
set(get(AX(1),'Ylabel'),'String','Objective, f(X)');
set(get(AX(2),'Ylabel'),'String','Constraint, g(X)');
set(H1,'LineStyle','-','LineWidth',1,'Marker','o');
set(H2,'LineStyle','-.','LineWidth',1,'Marker','x');
xlabel('Iteration #');
title('Iteration History');
hold on
plot(iter,xiters1, iter,xiters2, iter,xiters3)
grid on

legend('f(x)','Mass 9','Mass 10','Mass 11','g(x)')

figure(3)
xlabel('Iteration #');
title('Iteration History');
hold on
plot(iter,abs(xnpiters-164.0))
grid on 
ylabel('|xnp - x0|')

%% grads.m 
type grads

%% funcs.m
type funcs

%% setup.m
type setup

%% sensitivity.m
type sensitivity

%% modalAnalysis.m
type modalAnalysis

%% FEMsolve.m
type FEMsolve

%% eigenAnalysis.m
type eigenAnalysis