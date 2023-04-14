function [GRF_LzCyc,GRF_RzCyc,GRF_VERTCyc,GRF_APCyc,GRF_LMCyc,GRF_LyCyc,GRF_RyCyc,GRF_LxCyc,GRF_RxCyc,CoP_LxCyc,CoP_RxCyc,CoP_LyCyc,CoP_RyCyc,CoP_APCyc,CoP_LMCyc,GRF_RyCyc_RHS,GRF_RzCyc_RHS,GRF_RxCyc_RHS,GRF_VERTCyc_RHS,GRF_APCyc_RHS,GRF_LMCyc_RHS,CoP_RyCyc_RHS,CoP_RxCyc_RHS] = GRFsegmentation(LHS,RHS,LTO,RTO,GRF_Z_left,GRF_Z_right,GRF_Y_left,GRF_Y_right,GRF_X_left,GRF_X_right,CoP_X_left,CoP_X_right,CoP_Y_left,CoP_Y_right,GRF_Offset)

% add up GRF from both legs to get a total GRF in each plane
GRF_V_sum = GRF_Z_left + GRF_Z_right - GRF_Offset; % sum of the two legs (equivalent to a single-belt treadmill)
GRF_AP_sum = GRF_Y_left + GRF_Y_right; % sum of the two legs (equivalent to a single-belt treadmill)
GRF_LM_sum = GRF_X_left + GRF_X_right; % sum of the two legs (equivalent to a single-belt treadmill)

%% segment GRF per gait cycle
% independent L and R leg (measured by separate force plates)

% cycles as measured from left to left HS
GRF_LzCyc = nan(size(LHS,1) - 1, 101);
GRF_RzCyc = nan(size(RHS,1) - 1, 101);
GRF_LyCyc = nan(size(LHS,1) - 1, 101);
GRF_RyCyc = nan(size(RHS,1) - 1, 101);
GRF_LxCyc = nan(size(LHS,1) - 1, 101);
GRF_RxCyc = nan(size(RHS,1) - 1, 101);

% cycles as measured from right to right HS
GRF_RzCyc_RHS = nan(size(RHS,1) - 1, 101);
GRF_RyCyc_RHS = nan(size(RHS,1) - 1, 101);
GRF_RxCyc_RHS = nan(size(RHS,1) - 1, 101);

% remove offset from GRF_V
GRF_Z_left = GRF_Z_left - GRF_Offset;
GRF_Z_right = GRF_Z_right - GRF_Offset;

% separate into cycles
for kk = 1 : size(LHS,1) - 1 % stride always defined on the left leg
    temp = GRF_Z_left(LHS(kk):LHS(kk + 1));
    GRF_LzCyc(kk,:) = ScaleTime(temp, linspace(1,size(temp,1),101));
    GRF_LzCyc(kk,:) = max(GRF_LzCyc(kk,:),0); % correct vertical force
    
    temp1 = GRF_Y_left(LHS(kk):LHS(kk + 1));
    GRF_LyCyc(kk,:) = ScaleTime(temp1, linspace(1,size(temp1,1),101));
    
    temp2 = GRF_X_left(LHS(kk):LHS(kk + 1));
    GRF_LxCyc(kk,:) = ScaleTime(temp2, linspace(1,size(temp2,1),101));
    
    temp = GRF_Z_right(LHS(kk):LHS(kk + 1));
    GRF_RzCyc(kk,:) = ScaleTime(temp, linspace(1,size(temp,1),101));
    GRF_RzCyc(kk,:) = max(GRF_RzCyc(kk,:),0);
    
    temp1 = GRF_Y_right(LHS(kk):LHS(kk + 1));
    GRF_RyCyc(kk,:) = ScaleTime(temp1, linspace(1,size(temp1,1),101));
    
    temp2 = GRF_X_right(LHS(kk):LHS(kk + 1));
    GRF_RxCyc(kk,:) = ScaleTime(temp2, linspace(1,size(temp2,1),101));
end

% separate gait cycle starting from RHS as well
for kk = 1 : size(RHS,1) - 1 % stride always defined on the left leg
    temp = GRF_Y_right(RHS(kk):RHS(kk + 1));
    GRF_RyCyc_RHS(kk,:) = ScaleTime(temp, linspace(1,size(temp,1),101));
    
    temp = GRF_Z_right(RHS(kk):RHS(kk + 1));
    GRF_RzCyc_RHS(kk,:) = ScaleTime(temp, linspace(1,size(temp,1),101));
    GRF_RzCyc_RHS(kk,:) = max(GRF_RzCyc_RHS(kk,:),0);
    
    temp = GRF_X_right(RHS(kk):RHS(kk + 1));
    GRF_RxCyc_RHS(kk,:) = ScaleTime(temp, linspace(1,size(temp,1),101));
end

% combined L+R GRF, starting with L leg
GRF_VERTCyc = nan(size(LHS,1) - 1, 101);
GRF_APCyc = nan(size(LHS,1) - 1, 101);
GRF_LMCyc = nan(size(LHS,1) - 1, 101);
% separate GRF_sum into cycles as seen on the left leg
for nn = 1 : size(LHS,1) - 1
    temp = GRF_V_sum(LHS(nn):LHS(nn + 1));
    GRF_VERTCyc(nn,:) = ScaleTime(temp, linspace(1,size(temp,1),101));
    
    temp = GRF_AP_sum(LHS(nn):LHS(nn + 1));
    GRF_APCyc(nn,:) = ScaleTime(temp, linspace(1,size(temp,1),101));
    
    temp = GRF_LM_sum(LHS(nn):LHS(nn + 1));
    GRF_LMCyc(nn,:) = ScaleTime(temp, linspace(1,size(temp,1),101));
end

% combined L+R GRF, starting with R leg
GRF_VERTCyc_RHS = nan(size(LHS,1) - 1, 101);
GRF_APCyc_RHS = nan(size(LHS,1) - 1, 101);
GRF_LMCyc_RHS = nan(size(LHS,1) - 1, 101);
% separate GRF_sum into cycles as seen on the left leg
for nn = 1 : size(RHS,1) - 1
    temp = GRF_V_sum(RHS(nn):RHS(nn + 1));
    GRF_VERTCyc_RHS(nn,:) = ScaleTime(temp, linspace(1,size(temp,1),101));
    temp = GRF_AP_sum(RHS(nn):RHS(nn + 1));
    GRF_APCyc_RHS(nn,:) = ScaleTime(temp, linspace(1,size(temp,1),101));
    temp = GRF_LM_sum(RHS(nn):RHS(nn + 1));
    GRF_LMCyc_RHS(nn,:) = ScaleTime(temp, linspace(1,size(temp,1),101));
end

%% segment CoP per gait cycle
% each leg individually

CoP_LxCyc = nan(size(LHS,1) - 1, 101);
CoP_RxCyc = nan(size(RHS,1) - 1, 101);
CoP_LyCyc = nan(size(LHS,1) - 1, 101);
CoP_RyCyc = nan(size(RHS,1) - 1, 101);

% % set swing values to 0
for jj = 1 : size(LHS,1) - 1
    CoP_X_left(LTO(jj):LHS(jj+1)) = 0;
    CoP_Y_left(LTO(jj):LHS(jj+1)) = 0;
end
for jj = 1 : size(RHS,1) - 1
    CoP_X_right(RTO(jj):RHS(jj+1)) = 0;
    CoP_Y_right(RTO(jj):RHS(jj+1)) = 0;
end

% sum CoP from left and right 
CoP_LM_sum = CoP_X_left + CoP_X_right; % sum of the two legs (equivalent to a single-belt treadmill)
CoP_AP_sum = CoP_Y_left + CoP_Y_right; % sum of the two legs (equivalent to a single-belt treadmill)

% separate into cycles
for jj = 1 : size(LHS,1) - 1
    temp = CoP_X_left(LHS(jj):LHS(jj + 1));
    CoP_LxCyc(jj,:) = ScaleTime(temp, linspace(1,size(temp,1),101)); % [m]
    temp1 = CoP_Y_left(LHS(jj):LHS(jj + 1));
    CoP_LyCyc(jj,:) = ScaleTime(temp1, linspace(1,size(temp1,1),101)); % [m]    
    temp = CoP_X_right(LHS(jj):LHS(jj + 1));
    CoP_RxCyc(jj,:) = ScaleTime(temp, linspace(1,size(temp,1),101)); % [m]
    temp1 = CoP_Y_right(LHS(jj):LHS(jj + 1));
    CoP_RyCyc(jj,:) = ScaleTime(temp1, linspace(1,size(temp1,1),101)); % [m]
end

% set first value in first cycle to 0 (this is the case in all other cycles
% due to computational approach
CoP_LxCyc(1,1) = 0; CoP_LyCyc(1,1) = 0;

% separate using RHS
for jj = 1 : size(RHS,1) - 1
    temp = CoP_X_right(RHS(jj):RHS(jj + 1));
    CoP_RxCyc_RHS(jj,:) = ScaleTime(temp, linspace(1,size(temp,1),101)); % [m]
    temp1 = CoP_Y_right(RHS(jj):RHS(jj + 1));
    CoP_RyCyc_RHS(jj,:) = ScaleTime(temp1, linspace(1,size(temp1,1),101)); % [m]
end

% set first value in first cycle to 0 (this is the case in all other cycles
% due to computational approach
CoP_RxCyc_RHS(1,1) = 0; CoP_RyCyc_RHS(1,1) = 0;

% separate summed CoP into cycles leading with left leg
% also, position CoP into global coordinate system's origin to get
% oscillations around that assumed 0; this will allow direct comparison to
% CoM oscillations (xCoM)
CoP_APCyc = nan(size(LHS,1) - 1, 101);
CoP_LMCyc = nan(size(LHS,1) - 1, 101);
for nn = 1 : size(LHS,1) - 1
    temp = CoP_AP_sum(LHS(nn):LHS(nn + 1));
    CoP_APCyc(nn,:) = ScaleTime(temp, linspace(1,size(temp,1),101));
    CoP_APCyc(nn,:) = CoP_APCyc(nn,:) - mean(CoP_APCyc(nn,:));
    temp = CoP_LM_sum(LHS(nn):LHS(nn + 1));
    CoP_LMCyc(nn,:) = ScaleTime(temp, linspace(1,size(temp,1),101));
    CoP_LMCyc(nn,:) = CoP_LMCyc(nn,:) - mean(CoP_LMCyc(nn,:));
end

end