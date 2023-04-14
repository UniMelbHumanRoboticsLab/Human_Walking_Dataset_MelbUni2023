function [DYN] = AltitudeDynamic(M)

T = size(M.RASI, 1);

% attitude matrices for dynamic trial
% -----------------------------------
for t = 1:T
    
    % pelvis
    oP          = 0.5*(M.RASI(t,:) + M.LASI(t,:));
    pP          = 0.5*(M.RPSI(t,:) + M.LPSI(t,:));
    iP          = (M.RASI(t,:) - oP)./norm(M.RASI(t,:) - oP);
    hP          = (pP - oP)./norm(pP - oP);
    kP          = cross(hP, iP)./norm(cross(hP, iP));
    jP          = cross(kP, iP);
    M.AP(:,:,t) = [iP; jP; kP];
    
    % right thigh
    aRT          = norm(M.RASI(t,:) - M.LASI(t,:));
    PRHIP        = [0.36*aRT; -0.19*aRT; -0.30*aRT];
    oRT          = (oP' + M.AP(:,:,t)*PRHIP)';
    MKR          = 0.5*(M.RLKN(t,:) + M.RMKN(t,:));
    kRT          = (oRT - MKR)./norm(oRT - MKR);
    hRT          = (M.RLKN(t,:) - M.RMKN(t,:))./norm(M.RLKN(t,:) - M.RMKN(t,:));
    jRT          = cross(kRT, hRT)./norm(cross(kRT, hRT));
    iRT          = cross(jRT, kRT);
    M.ART(:,:,t) = [iRT; jRT; kRT];
    
    % left thigh
    PLHIP        = [-0.36*aRT; -0.19*aRT; -0.30*aRT];
    oLT          = (oP' + M.AP(:,:,t)*PLHIP)';
    MKL          = 0.5*(M.LLKN(t,:) + M.LMKN(t,:));
    kLT          = (oLT - MKL)./norm(oLT - MKL);
    hLT          = (M.LLKN(t,:) - M.LMKN(t,:))./norm(M.LLKN(t,:) - M.LMKN(t,:));
    jLT          = cross(hLT, kLT)./norm(cross(hLT, kLT));
    iLT          = cross(jLT, kLT);
    M.ALT(:,:,t) = [iLT; jLT; kLT];
    
    % right proximally biased shank
    oRS           = 0.5*(M.RLKN(t,:) + M.RMKN(t,:));
    MM            = 0.5*(M.RMM(t,:) + M.RLM(t,:));
    kRS           = (oRS - MM)./norm(oRS - MM);
    hRS           = (M.RLKN(t,:) - M.RMKN(t,:))./norm(M.RLKN(t,:) - M.RMKN(t,:));
    jRS           = cross(kRS, hRS)./norm(cross(kRS, hRS));
    iRS           = cross(jRS, kRS);
    M.ARPS(:,:,t) = [iRS; jRS; kRS];
    
    % right distally biased shank
    hRS           = (M.RLM(t,:) - M.RMM(t,:))./norm(M.RLM(t,:) - M.RMM(t,:));
    jRS           = cross(kRS, hRS)./norm(cross(kRS, hRS));
    iRS           = cross(jRS, kRS);
    M.ARDS(:,:,t) = [iRS; jRS; kRS];
    
    % left proximally biased shank
    oLS           = 0.5*(M.LLKN(t,:) + M.LMKN(t,:));
    MM            = 0.5*(M.LMM(t,:) + M.LLM(t,:));
    kLS           = (oLS - MM)./norm(oLS - MM);
    hLS           = (M.LLKN(t,:) - M.LMKN(t,:))./norm(M.LLKN(t,:) - M.LMKN(t,:));
    jLS           = cross(hLS, kLS)./norm(cross(hLS, kLS));
    iLS           = cross(jLS, kLS);
    M.ALPS(:,:,t) = [iLS; jLS; kLS];
    
    % left distally biased shank
    hLS           = (M.LLM(t,:) - M.LMM(t,:))./norm(M.LLM(t,:) - M.LMM(t,:));
    jLS           = cross(hLS, kLS)./norm(cross(hLS, kLS));
    iLS           = cross(jLS, kLS);
    M.ALDS(:,:,t) = [iLS; jLS; kLS];
    
    % right foot
    oRF          = M.RCAL(t,:);
    jRF          = (M.RTOE(t,:) - oRF)./norm(M.RTOE(t,:) - oRF);
    MM           = 0.5*(M.RMM(t,:) + M.RLM(t,:));
    hRF          = (MM - oRF)./norm(MM - oRF);
    iRF          = cross(jRF, hRF)./norm(cross(jRF, hRF));
    kRF          = cross(iRF, jRF);
    M.ARF(:,:,t) = [iRF; jRF; kRF];
    
    % left foot
    oLF          = M.LCAL(t,:);
    jLF          = (M.LTOE(t,:) - oLF)./norm(M.LTOE(t,:) - oLF);
    MM           = 0.5*(M.LMM(t,:) + M.LLM(t,:));
    hLF          = (MM - oLF)./norm(MM - oLF);
    iLF          = cross(jLF, hLF)./norm(cross(jLF, hLF));
    kLF          = cross(iLF, jLF);
    M.ALF(:,:,t) = [iLF; jLF; kLF];
    
end

DYN = M;

end

