function [gradf, gradg] = grads(dv)

[FEM, mLumped, N, M, Mindex] = setup(dv);
FEM = FEMsolve(FEM, mLumped);
[eigVecG, eigVal, kCurtailed, mCurtailed] = eigenAnalysis(FEM);
[nodalLoc, w] = modalAnalysis(N, FEM, eigVecG);
dwdw = sensitivity(N, FEM, M, mLumped, nodalLoc);
gradf = ones(size(Mindex))';
gradg = [dwdw(Mindex)',-dwdw(Mindex)'];