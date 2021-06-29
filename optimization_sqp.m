clear; clc; close all

%%

X0 = [5.21, 6.55, 6.6];
dxlb = 0*ones(size(X0));
dxub = 50*ones(size(X0));
%%

options.MoveReduction=0.0005;
options.Display='iter';
options.MaxFunEvals = 10000;

options.MaxIter=30;
options.TolX=10e-6;
options.TolFun=10e-8;
options.TolCon=10e-9;

[x,f,exitflag,output]=sqp(@funcs,X0,options,dxlb,dxub,@grads);

% history_sqp = OutputFcnSqpExample('sqp');