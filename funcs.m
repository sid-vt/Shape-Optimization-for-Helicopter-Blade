function [f, g] = funcs(dv)
global xiters1
global xiters2
global xiters3 
xiters1 = [xiters1,dv(1)];
xiters2 = [xiters2,dv(2)];
xiters3 = [xiters3,dv(3)];

delta = 1.0;
x0 = 164.0;

[FEM, mLumped, N, M, Mindex] = setup(dv);
FEM = FEMsolve(FEM, mLumped);
[eigVecG, eigVal, kCurtailed, mCurtailed] = eigenAnalysis(FEM);
[nodalLoc, w] = modalAnalysis(N, FEM, eigVecG);

global xnpiters
xnpiters = [xnpiters,nodalLoc(2,2)];

f = sum(dv);
g1 = nodalLoc(2,2) - x0 - delta;
g2 = -(nodalLoc(2,2) - x0) - delta;
g = [g1,g2];


% plot(output.iterations,dv(3))