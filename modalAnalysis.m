function [nodalLoc, w] = modalAnalysis(N, FEM, eigVecG)

modeNum = 3;

N1=N.N1;
N2=N.N2;
N3=N.N3;
N4=N.N4;

elmL = FEM.elmL;

cnt = 0;
for i=1:FEM.nelm
    x1 = linspace(0,elmL(i),50);
    x2 = linspace(sum(elmL(1:i-1)),sum(elmL(1:i)),50);
    w(:,i) = N1(x1,elmL(i)).*eigVecG(2*i-1,modeNum) + N2(x1,elmL(i)).*eigVecG(2*i,modeNum)...
        + N3(x1,elmL(i)).*eigVecG(2*i+1,modeNum) + N4(x1,elmL(i)).*eigVecG(2*i+2,modeNum);
    
    xnp0_ind = find(diff(sign(w(:,i))));
    if find(diff(sign(w(:,i))))
        cnt = cnt + 1;
        nodalElm = i;
        xnp = @(x) N1(x,elmL(nodalElm))*eigVecG(2*nodalElm-1,modeNum) + N2(x,elmL(nodalElm))*eigVecG(2*nodalElm,modeNum)...
            + N3(x,elmL(nodalElm))*eigVecG(2*nodalElm+1,modeNum) + N4(x,elmL(nodalElm))*eigVecG(2*nodalElm+2,modeNum);
        options = optimset('Display','off');
        xnp = fsolve(xnp,w(xnp0_ind,nodalElm),options);
        nodalLoc(cnt,:) = [nodalElm, sum(elmL(1:i-1)) + xnp];
    end
    plot(x2,w(:,i),'LineWidth',2)  
    hold on
end
grid on
title("Mode Shape")
xlabel('Length');
ylabel('Displacement');
hold on