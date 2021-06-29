function dwdw = sensitivity(N, FEM, M, mLumped, nodalLoc)

[eigVecG, eigVal, kCurtailed, mCurtailed] = eigenAnalysis(FEM);
%% EigenVector Sensitivity

dv_check = M>0;

lambda = eigVal(2);
phi = eigVecG(3:end,2);
[m, loc] = max(abs(phi));

K_prime = zeros(size(kCurtailed));
for i = 1:size(M,2)
    M_primeG = zeros(size(mLumped));
    
    % check availibility of design variable at grid point
    if dv_check(i)
        M_primeG(2*i-1,2*i-1) = 1;
    end
    
    M_prime = M_primeG(3:end,3:end);
    lambda_prime = phi'*K_prime*phi - lambda*phi'*M_prime*phi;
    
    F = kCurtailed - lambda*mCurtailed;
    F_prime = K_prime - lambda_prime*mCurtailed - lambda*M_prime;
        
    F_temp = F;
    F_temp(loc,:)=[];
    F_temp(:,loc)=[];
    F_tilda = F_temp;
    
    Fprime_temp = F_prime;
    Fprime_temp(loc,:)=[];
    Fprime_temp(:,loc)=[];
    F_tilda_prime = Fprime_temp;
    
    phi_temp = phi;
    phi_temp(loc)=[];
    phi_tilda = phi_temp;

    V = - inv(F_tilda)*F_tilda_prime*phi_tilda;
    q = [V(1:loc-1);0;V(loc:end)];
    c = -phi'*mCurtailed*q - 0.5*phi'*M_prime*phi;

    phi_prime(:,i) = q + c*phi;
end


%% Derivatives

modeNum = 2;
np_elm = nodalLoc(2,1);
xnp = nodalLoc(2,2)-(np_elm-1)*FEM.elmL(1);

dNdx = [N.N1_prime(xnp, FEM.elmL(np_elm)), N.N2_prime(xnp, FEM.elmL(np_elm)),...
        N.N3_prime(xnp, FEM.elmL(np_elm)), N.N4_prime(xnp, FEM.elmL(np_elm))];
dwdx = dNdx * eigVecG(2*np_elm-1 : 2*np_elm + 2, modeNum);

for i=1:size(M,2)
    Nxnp = [N.N1(xnp,FEM.elmL(np_elm)), N.N2(xnp,FEM.elmL(np_elm)),...
            N.N3(xnp,FEM.elmL(np_elm)), N.N4(xnp,FEM.elmL(np_elm))];
       
    dwdv(i) = Nxnp * phi_prime((2*(np_elm-1) - 1) : 2*np_elm, i);
end
dwdx;
dwdv;
dwdw = -dwdv/dwdx;
