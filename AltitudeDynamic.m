function [DYN] = Altitude_Dynamic(M)

T = size(M.RASI, 1);

% if markers == 24
% % markers from the csv file
%     M.RASI      = data(:,3:5);
%     M.RPSI      = data(:,6:8);
%     M.LPSI      = data(:,9:11);
%     M.LASI      = data(:,12:14);
%     M.RHIP      = data(:,15:17);
%     M.RHIPextra = data(:,18:20);
%     M.RLKN      = data(:,21:23);
%     M.RMKN      = data(:,24:26);
%     M.LHIP      = data(:,27:29);
%     M.LHIPextra = data(:,30:32);
%     M.LLKN      = data(:,33:35);
%     M.LMKN      = data(:,36:38);
%     M.RTIB      = data(:,39:41);
%     M.RTIBextra = data(:,42:44);
%     M.RLM       = data(:,45:47);
%     M.RMM       = data(:,48:50);
%     M.LTIB      = data(:,51:53);
%     M.LTIBextra = data(:,54:56);
%     M.LLM       = data(:,57:59);
%     M.LMM       = data(:,60:62);
%     M.RTOE      = data(:,63:65);
%     M.RCAL      = data(:,66:68);
%     M.LTOE      = data(:,69:71);
%     M.LCAL      = data(:,72:74);
% elseif markers == 26
% % markers from the csv file
%     M.RASI       = data(:,3:5);
%     M.RPSI       = data(:,6:8);
%     M.LPSI       = data(:,9:11);
%     M.LASI       = data(:,12:14);
%     M.RHIP       = data(:,15:17);
%     M.RHIPextra  = data(:,18:20);
%     M.RLKN       = data(:,21:23);
%     M.RMKN       = data(:,24:26);
%     M.RTIB       = data(:,27:29);
%     M.RTIBextra1 = data(:,30:32);
%     M.RTIBextra2 = data(:,33:35);
%     M.RLM        = data(:,36:38);
%     M.RMM        = data(:,39:41);
%     M.RTOE       = data(:,42:44);
%     M.RCAL       = data(:,45:47);
%     M.LHIP       = data(:,48:50);
%     M.LHIPextra  = data(:,51:53);
%     M.LLKN       = data(:,54:56);
%     M.LMKN       = data(:,57:59);
%     M.LTIB       = data(:,60:62);
%     M.LTIBextra1 = data(:,63:65);
%     M.LTIBextra2 = data(:,66:68);
%     M.LLM        = data(:,69:71);
%     M.LMM        = data(:,72:74);
%     M.LTOE       = data(:,75:77);
%     M.LCAL       = data(:,78:80);
% end

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

