function [CAL] = Angles_Calibration(data)

M = data;

% attitude matrices for calibration pose
% --------------------------------------
% pelvis
oP   = 0.5*(M.RASI + M.LASI);
pP   = 0.5*(M.RPSI + M.LPSI);
iP   = (M.RASI - oP)./norm(M.RASI - oP);
hP   = (pP - oP)./norm(pP - oP);
kP   = cross(hP, iP)./norm(cross(hP, iP));
jP   = cross(kP, iP);
M.AP = [iP; jP; kP];

% right thigh
aRT   = norm(M.RASI - M.LASI);
PRHIP = [0.36*aRT; -0.19*aRT; -0.30*aRT];
oRT   = (oP' + M.AP*PRHIP)';
MKR   = 0.5*(M.RLKN + M.RMKN);
kRT   = (oRT - MKR)./norm(oRT - MKR);
hRT   = (M.RLKN - M.RMKN)./norm(M.RLKN - M.RMKN);
jRT   = cross(kRT, hRT)./norm(cross(kRT, hRT));
iRT   = cross(jRT, kRT);
M.ART = [iRT; jRT; kRT];

% left thigh
PLHIP = [-0.36*aRT; -0.19*aRT; -0.30*aRT];
oLT   = (oP' + M.AP*PLHIP)';
MKL   = 0.5*(M.LLKN + M.LMKN);
kLT   = (oLT - MKL)./norm(oLT - MKL);
hLT   = (M.LLKN - M.LMKN)./norm(M.LLKN - M.LMKN);
jLT   = cross(hLT, kLT)./norm(cross(hLT, kLT));
iLT   = cross(jLT, kLT);
M.ALT = [iLT; jLT; kLT];

% right proximally biased shank
oRS    = 0.5*(M.RLKN + M.RMKN);
MM     = 0.5*(M.RMM + M.RLM);
kRS    = (oRS - MM)./norm(oRS - MM);
hRS    = (M.RLKN - M.RMKN)./norm(M.RLKN - M.RMKN);
jRS    = cross(kRS, hRS)./norm(cross(kRS, hRS));
iRS    = cross(jRS, kRS);
M.ARPS = [iRS; jRS; kRS];

% right distally biased shank
hRS    = (M.RLM - M.RMM)./norm(M.RLM - M.RMM);
jRS    = cross(kRS, hRS)./norm(cross(kRS, hRS));
iRS    = cross(jRS, kRS);
M.ARDS = [iRS; jRS; kRS];

% left proximally biased shank
oLS    = 0.5*(M.LLKN + M.LMKN);
MM     = 0.5*(M.LMM + M.LLM);
kLS    = (oLS - MM)./norm(oLS - MM);
hLS    = (M.LLKN - M.LMKN)./norm(M.LLKN - M.LMKN);
jLS    = cross(hLS, kLS)./norm(cross(hLS, kLS));
iLS    = cross(jLS, kLS);
M.ALPS = [iLS; jLS; kLS];

% left distally biased shank
hLS    = (M.LLM - M.LMM)./norm(M.LLM - M.LMM);
jLS    = cross(hLS, kLS)./norm(cross(hLS, kLS));
iLS    = cross(jLS, kLS);
M.ALDS = [iLS; jLS; kLS];

% right foot
oRF   = M.RCAL;
jRF   = (M.RTOE - oRF)./norm(M.RTOE - oRF);
MM    = 0.5*(M.RMM + M.RLM);
hRF   = (MM - oRF)./norm(MM - oRF);
iRF   = cross(jRF, hRF)./norm(cross(jRF, hRF));
kRF   = cross(iRF, jRF);
M.ARF = [iRF; jRF; kRF];

% left foot
oLF   = M.LCAL;
jLF   = (M.LTOE - oLF)./norm(M.LTOE - oLF);
MM    = 0.5*(M.LMM + M.LLM);
hLF   = (MM - oLF)./norm(MM - oLF);
iLF   = cross(jLF, hLF)./norm(cross(jLF, hLF));
kLF   = cross(iLF, jLF);
M.ALF = [iLF; jLF; kLF];

% joint angles in static calibration pose
% pelvis
M.PelSag  = atan2(-M.AP(3,2), M.AP(3,3))*(180/pi);
M.PelLat  = atan2(M.AP(3,1), sqrt(M.AP(1,1)^2 + M.AP(2,1)^2))*(180/pi);
M.PelRot  = atan2(-M.AP(2,1), M.AP(1,1))*(180/pi);
    
% right hip
M.RHip = M.ART*M.AP';
M.RHipFlex = atan2(-M.RHip(3,2), M.RHip(3,3))*(180/pi);
M.RHipAbad = atan2(M.RHip(3,1), sqrt(M.RHip(1,1)^2 + M.RHip(2,1)^2))*(180/pi);
M.RHipRot  = atan2(-M.RHip(2,1), M.RHip(1,1))*(180/pi);
    
% left hip
M.LHip = M.ALT*M.AP';
M.LHipFlex = atan2(-M.LHip(3,2), M.LHip(3,3))*(180/pi);
M.LHipAbad = -atan2(M.LHip(3,1), sqrt(M.LHip(1,1)^2 + M.LHip(2,1)^2))*(180/pi);
M.LHipRot  = -atan2(-M.LHip(2,1), M.LHip(1,1))*(180/pi);
    
% right knee
M.RKnee = M.ARPS*M.ART';
M.RKneeFlex = -atan2(-M.RKnee(3,2), M.RKnee(3,3))*(180/pi);
M.RKneeAbad = atan2(M.RKnee(3,1), sqrt(M.RKnee(1,1)^2 + M.RKnee(2,1)^2))*(180/pi);
M.RKneeRot  = atan2(-M.RKnee(2,1), M.RKnee(1,1))*(180/pi);
    
% left knee
M.LKnee = M.ALPS*M.ALT';
M.LKneeFlex = -atan2(-M.LKnee(3,2), M.LKnee(3,3))*(180/pi);
M.LKneeAbad = -atan2(M.LKnee(3,1), sqrt(M.LKnee(1,1)^2 + M.LKnee(2,1)^2))*(180/pi);
M.LKneeRot  = -atan2(-M.LKnee(2,1), M.LKnee(1,1))*(180/pi);
    
% right ankle
M.RAnkle = M.ARF*M.ARDS';
M.RAnkleFlex = atan2(-M.RAnkle(3,2), M.RAnkle(3,3))*(180/pi);
M.RAnkleInev = atan2(M.RAnkle(3,1), sqrt(M.RAnkle(1,1)^2 + M.RAnkle(2,1)^2))*(180/pi);
M.RAnkleRot  = atan2(-M.RAnkle(2,1), M.RAnkle(1,1))*(180/pi);
    
% left ankle
M.LAnkle = M.ALF*M.ALDS';
M.LAnkleFlex = atan2(-M.LAnkle(3,2), M.LAnkle(3,3))*(180/pi);
M.LAnkleInev = -atan2(M.LAnkle(3,1), sqrt(M.LAnkle(1,1)^2 + M.LAnkle(2,1)^2))*(180/pi);
M.LAnkleRot  = -atan2(-M.LAnkle(2,1), M.LAnkle(1,1))*(180/pi);
    
CAL = M;

end