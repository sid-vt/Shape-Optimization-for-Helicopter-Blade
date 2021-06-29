function [FEM, mLumped, N, M, Mindex] = setup(dv)
    %% System Definition
    N.N1 = @(x,le) 1 - 3*x.^2./le^2 + 2*x.^3./le^3;
    N.N2 = @(x,le) x - 2*x.^2./le + x.^3./le^2;
    N.N3 = @(x,le) 3*x.^2./le^2 - 2*x.^3./le^3;
    N.N4 = @(x,le) -x.^2./le + x.^3./le^2;

    N.N1_prime = @(x,le) -6*x./le^2 + 6*x.^2./le^3;
    N.N2_prime = @(x,le) 1 - 4*x./le + 3*x.^2./le^2;
    N.N3_prime = @(x,le) 6*x./le^2 - 6*x.^2./le^3;
    N.N4_prime = @(x,le) -2*x./le + 3*x.^2./le^2;

    % number of element
    FEM.nelm = 10;

    % number of nodes
    FEM.nodes = FEM.nelm + 1;

    % number of degree of freedom per element
    FEM.ndof = 2;
    FEM.tdof = FEM.nodes*FEM.ndof;

    E = ones(1,FEM.nelm)*0.585e7;
    E(1) = 0.490e7;

    rho = ones(1,FEM.nelm)*0.07;
    FEM.elmL = ones(1,FEM.nelm)*(193/FEM.nelm);

    b = ones(1,FEM.nelm)*3.75;
    h = ones(1,FEM.nelm)*2.5;
    t = ones(1,FEM.nelm)*0.8;
    d = ones(1,FEM.nelm)*0.1;

    bh = b - 2*d;
    hh = h + 2*t;

    I = 1/12*(b.*hh.^3 - bh.*h.^3);
    A = b.*hh - bh.*h;

    FEM.kProp = (E.*I)./FEM.elmL.^3;
    FEM.mProp = (rho.*A.*FEM.elmL)/420;

    % Lumped Masses
    M = zeros(1,FEM.nodes);
    M(3) = 3.04;    M(4) = 1.67;    M(6) = 6.40;    M(7) = 7.46;
    M(8) = 10.75;    M(9) = 5.21;    M(10) = 6.55;    M(11) = 6.6;

    Mindex = [6,7,8,10];
    M(Mindex) = dv;

    for i=1:FEM.nelm
        FEM.connect(:,i) = [i;i+1];
    end

    mLumped = zeros(FEM.tdof, FEM.tdof);
    for i = 1:size(M,2)
        mLumped(2*i-1,2*i-1) = M(i);
    end
end