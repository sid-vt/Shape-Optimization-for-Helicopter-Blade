function [FEM] = FEMsolve(FEM, mLumped)

FEM.kG = zeros(FEM.tdof, FEM.tdof);
FEM.mC = zeros(FEM.tdof, FEM.tdof);
elmL = FEM.elmL;

for i = 1:FEM.nelm
    kL = FEM.kProp(i)*[12         6*elmL(i)    -12          6*elmL(i)    ;
                   6*elmL(i)  4*elmL(i)^2  -6*elmL(i)   2*elmL(i)^2  ;
                  -12        -6*elmL(i)     12         -6*elmL(i)    ;
                   6*elmL(i)  2*elmL(i)^2  -6*elmL(i)   4*elmL(i)^2 ];
    
    mL = FEM.mProp(i)*[156         22*elmL(i)    54          -13*elmL(i)   ;
                   22*elmL(i)  4*elmL(i)^2   13*elmL(i)  -3*elmL(i)^2  ;
                   54          13*elmL(i)    156         -22*elmL(i)   ;
                  -13*elmL(i) -3*elmL(i)^2  -22*elmL(i)   4*elmL(i)^2 ];
              
    cnt = FEM.connect(:,i);
    conmat = [2*cnt(1)-1, 2*cnt(1), 2*cnt(2)-1, 2*cnt(2)];
    for j = 1:4
        for k=1:4
            FEM.kG(conmat(j),conmat(k)) = FEM.kG(conmat(j),conmat(k)) + kL(j,k);
            FEM.mC(conmat(j),conmat(k)) = FEM.mC(conmat(j),conmat(k)) + mL(j,k);
        end
    end  
end
FEM.mG = FEM.mC + mLumped;
