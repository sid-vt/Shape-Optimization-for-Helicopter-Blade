function [eigVecG, eigVal, kCurtailed, mCurtailed] = eigenAnalysis(FEM)

kCurtailed = FEM.kG(3:end,3:end);
mCurtailed = FEM.mG(3:end,3:end);
[eigVec, eigVal] = eig(kCurtailed,mCurtailed);
eigVal = diag(eigVal);
eigVecG(FEM.tdof,FEM.tdof-2) = 0;
eigVecG(3:end,:) = eigVec(1:end,:);