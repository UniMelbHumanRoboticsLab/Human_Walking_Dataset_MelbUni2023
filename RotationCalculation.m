function ROT = RotationCalculation(DYN, CAL, Side, Corr)
% with correction for static pose
T   = size(DYN.AP, 3);

for t = 1:T
    
    % Pelvisvis
    ROT.Pelvis(:,:,t) = DYN.AP(:,:,t)*CAL.AP';
    ROT.Pelvis_Sagg(t)  = atan2(-ROT.Pelvis(3,2,t), ROT.Pelvis(3,3,t))*(180/pi); % absolute angle in the GCS
    ROT.Pelvis_Front(t)  = atan2(ROT.Pelvis(3,1,t), sqrt(ROT.Pelvis(1,1,t)^2 + ROT.Pelvis(2,1,t)^2))*(180/pi);% - CAL.Pelvisvis_Front;
    ROT.Pelvis_Trans(t)  = atan2(-ROT.Pelvis(2,1,t), ROT.Pelvis(1,1,t))*(180/pi);% - (180 - CAL.Pelvisvis_Trans);
    
    if strcmp(Corr, 'Corr_Yes')
        if strcmp(Side, 'Left')
            % right hip
            ROT.Right_Hip(:,:,t) = CAL.ART'*DYN.ART(:,:,t)*(CAL.AP'*DYN.AP(:,:,t))';
            ROT.Right_HipFlex(t) = atan2(-ROT.Right_Hip(3,2,t), ROT.Right_Hip(3,3,t))*(180/pi);% + (CAL.Right_HipFlex - CAL.Left_HipFlex);
            ROT.Right_HipAbd(t) = atan2(ROT.Right_Hip(3,1,t), sqrt(ROT.Right_Hip(1,1,t)^2 + ROT.Right_Hip(2,1,t)^2))*(180/pi);% + (CAL.Right_HipAbd - CAL.Left_HipAbd);
            ROT.Right_HipRot(t)  = atan2(-ROT.Right_Hip(2,1,t), ROT.Right_Hip(1,1,t))*(180/pi);% + (CAL.Right_HipRot - CAL.Left_HipRot);
            
            % left hip
            ROT.Left_Hip(:,:,t) = CAL.ALT'*DYN.ALT(:,:,t)*(CAL.AP'*DYN.AP(:,:,t))';
            ROT.Left_HipFlex(t) = atan2(-ROT.Left_Hip(3,2,t), ROT.Left_Hip(3,3,t))*(180/pi) + (CAL.Left_HipFlex - CAL.Right_HipFlex);
            ROT.Left_HipAbd(t) = -atan2(ROT.Left_Hip(3,1,t), sqrt(ROT.Left_Hip(1,1,t)^2 + ROT.Left_Hip(2,1,t)^2))*(180/pi) + (CAL.Left_HipAbd - CAL.Right_HipAbd);
            ROT.Left_HipRot(t)  = -atan2(-ROT.Left_Hip(2,1,t), ROT.Left_Hip(1,1,t))*(180/pi) + (CAL.Left_HipRot - CAL.Right_HipRot);
            
            % right knee
            ROT.Right_Knee(:,:,t) = CAL.ARPS'*DYN.ARPS(:,:,t)*(CAL.ART'*DYN.ART(:,:,t))';
            ROT.Right_KneeFlex(t) = -atan2(-ROT.Right_Knee(3,2,t), ROT.Right_Knee(3,3,t))*(180/pi);% + (CAL.Right_KneeFlex - CAL.Left_KneeFlex);
            ROT.Right_KneeAbd(t) = atan2(ROT.Right_Knee(3,1,t), sqrt(ROT.Right_Knee(1,1,t)^2 + ROT.Right_Knee(2,1,t)^2))*(180/pi);% + (CAL.Right_KneeAbd - CAL.Left_KneeAbd);
            ROT.Right_KneeRot(t)  = atan2(-ROT.Right_Knee(2,1,t), ROT.Right_Knee(1,1,t))*(180/pi);% + (CAL.Right_KneeRot - CAL.Left_KneeRot);
            
            % left knee
            ROT.Left_Knee(:,:,t) = CAL.ALPS'*DYN.ALPS(:,:,t)*(CAL.ALT'*DYN.ALT(:,:,t))';
            ROT.Left_KneeFlex(t) = -atan2(-ROT.Left_Knee(3,2,t), ROT.Left_Knee(3,3,t))*(180/pi) + (CAL.Left_KneeFlex - CAL.Right_KneeFlex);
            ROT.Left_KneeAbd(t) = -atan2(ROT.Left_Knee(3,1,t), sqrt(ROT.Left_Knee(1,1,t)^2 + ROT.Left_Knee(2,1,t)^2))*(180/pi) + (CAL.Left_KneeAbd - CAL.Right_KneeAbd);
            ROT.Left_KneeRot(t)  = -atan2(-ROT.Left_Knee(2,1,t), ROT.Left_Knee(1,1,t))*(180/pi) + (CAL.Left_KneeRot - CAL.Right_KneeRot);
            
            % right ankle
            ROT.Right_Ankle(:,:,t) = CAL.ARF'*DYN.ARF(:,:,t)*(CAL.ARDS'*DYN.ARDS(:,:,t))';
            ROT.Right_AnkleFlex(t) = atan2(-ROT.Right_Ankle(3,2,t), ROT.Right_Ankle(3,3,t))*(180/pi);% + (CAL.Right_AnkleFlex - CAL.Left_AnkleFlex);
            ROT.Right_AnkleAbd(t) = atan2(ROT.Right_Ankle(3,1,t), sqrt(ROT.Right_Ankle(1,1,t)^2 + ROT.Right_Ankle(2,1,t)^2))*(180/pi);% + (CAL.Right_AnkleAbd - CAL.Leftt_AnkleAbd);
            ROT.Right_AnkleRot(t)  = atan2(-ROT.Right_Ankle(2,1,t), ROT.Right_Ankle(1,1,t))*(180/pi);% + (CAL.Right_AnkleRot - CAL.Leftt_AnkleRot);
            
            % left ankle
            ROT.Left_Ankle(:,:,t) = CAL.ALF'*DYN.ALF(:,:,t)*(CAL.ALDS'*DYN.ALDS(:,:,t))';
            ROT.Left_AnkleFlex(t) = atan2(-ROT.Left_Ankle(3,2,t), ROT.Left_Ankle(3,3,t))*(180/pi) + (CAL.Left_AnkleFlex - CAL.Right_AnkleFlex);
            ROT.Left_AnkleAbd(t) = -atan2(ROT.Left_Ankle(3,1,t), sqrt(ROT.Left_Ankle(1,1,t)^2 + ROT.Left_Ankle(2,1,t)^2))*(180/pi) + (CAL.Leftt_AnkleAbd - CAL.Right_AnkleAbd);
            ROT.Left_AnkleRot(t)  = -atan2(-ROT.Left_Ankle(2,1,t), ROT.Left_Ankle(1,1,t))*(180/pi) + (CAL.Leftt_AnkleRot - CAL.Right_AnkleRot);
        elseif strcmp(Side, 'Right')
            % right hip
            ROT.Right_Hip(:,:,t) = CAL.ART'*DYN.ART(:,:,t)*(CAL.AP'*DYN.AP(:,:,t))';
            ROT.Right_HipFlex(t) = atan2(-ROT.Right_Hip(3,2,t), ROT.Right_Hip(3,3,t))*(180/pi) + (CAL.Right_HipFlex - CAL.Left_HipFlex);
            ROT.Right_HipAbd(t) = atan2(ROT.Right_Hip(3,1,t), sqrt(ROT.Right_Hip(1,1,t)^2 + ROT.Right_Hip(2,1,t)^2))*(180/pi) + (CAL.Right_HipAbd - CAL.Left_HipAbd);
            ROT.Right_HipRot(t)  = atan2(-ROT.Right_Hip(2,1,t), ROT.Right_Hip(1,1,t))*(180/pi) + (CAL.Right_HipRot - CAL.Left_HipRot);
            
            % left hip
            ROT.Left_Hip(:,:,t) = CAL.ALT'*DYN.ALT(:,:,t)*(CAL.AP'*DYN.AP(:,:,t))';
            ROT.Left_HipFlex(t) = atan2(-ROT.Left_Hip(3,2,t), ROT.Left_Hip(3,3,t))*(180/pi);% + (CAL.Left_HipFlex - CAL.Right_HipFlex);
            ROT.Left_HipAbd(t) = -atan2(ROT.Left_Hip(3,1,t), sqrt(ROT.Left_Hip(1,1,t)^2 + ROT.Left_Hip(2,1,t)^2))*(180/pi);% + (CAL.Left_HipAbd - CAL.Right_HipAbd);
            ROT.Left_HipRot(t)  = -atan2(-ROT.Left_Hip(2,1,t), ROT.Left_Hip(1,1,t))*(180/pi);% + (CAL.Left_HipRot - CAL.Right_HipRot);
            
            % right knee
            ROT.Right_Knee(:,:,t) = CAL.ARPS'*DYN.ARPS(:,:,t)*(CAL.ART'*DYN.ART(:,:,t))';
            ROT.Right_KneeFlex(t) = -atan2(-ROT.Right_Knee(3,2,t), ROT.Right_Knee(3,3,t))*(180/pi) + (CAL.Right_KneeFlex - CAL.Left_KneeFlex);
            ROT.Right_KneeAbd(t) = atan2(ROT.Right_Knee(3,1,t), sqrt(ROT.Right_Knee(1,1,t)^2 + ROT.Right_Knee(2,1,t)^2))*(180/pi) + (CAL.Right_KneeAbd - CAL.Left_KneeAbd);
            ROT.Right_KneeRot(t)  = atan2(-ROT.Right_Knee(2,1,t), ROT.Right_Knee(1,1,t))*(180/pi) + (CAL.Right_KneeRot - CAL.Left_KneeRot);
            
            % left knee
            ROT.Left_Knee(:,:,t) = CAL.ALPS'*DYN.ALPS(:,:,t)*(CAL.ALT'*DYN.ALT(:,:,t))';
            ROT.Left_KneeFlex(t) = -atan2(-ROT.Left_Knee(3,2,t), ROT.Left_Knee(3,3,t))*(180/pi);% + (CAL.Left_KneeFlex - CAL.Right_KneeFlex);
            ROT.Left_KneeAbd(t) = -atan2(ROT.Left_Knee(3,1,t), sqrt(ROT.Left_Knee(1,1,t)^2 + ROT.Left_Knee(2,1,t)^2))*(180/pi);% + (CAL.Left_KneeAbd - CAL.Right_KneeAbd);
            ROT.Left_KneeRot(t)  = -atan2(-ROT.Left_Knee(2,1,t), ROT.Left_Knee(1,1,t))*(180/pi);% + (CAL.Left_KneeRot - CAL.Right_KneeRot);
            
            % right ankle
            ROT.Right_Ankle(:,:,t) = CAL.ARF'*DYN.ARF(:,:,t)*(CAL.ARDS'*DYN.ARDS(:,:,t))';
            ROT.Right_AnkleFlex(t) = atan2(-ROT.Right_Ankle(3,2,t), ROT.Right_Ankle(3,3,t))*(180/pi) + (CAL.Right_AnkleFlex - CAL.Left_AnkleFlex);
            ROT.Right_AnkleAbd(t) = atan2(ROT.Right_Ankle(3,1,t), sqrt(ROT.Right_Ankle(1,1,t)^2 + ROT.Right_Ankle(2,1,t)^2))*(180/pi) + (CAL.Right_AnkleAbd - CAL.Leftt_AnkleAbd);
            ROT.Right_AnkleRot(t)  = atan2(-ROT.Right_Ankle(2,1,t), ROT.Right_Ankle(1,1,t))*(180/pi) + (CAL.Right_AnkleRot - CAL.Leftt_AnkleRot);
            
            % left ankle
            ROT.Left_Ankle(:,:,t) = CAL.ALF'*DYN.ALF(:,:,t)*(CAL.ALDS'*DYN.ALDS(:,:,t))';
            ROT.Left_AnkleFlex(t) = atan2(-ROT.Left_Ankle(3,2,t), ROT.Left_Ankle(3,3,t))*(180/pi);% + (CAL.Right_AnkleFlex - CAL.Left_AnkleFlex);
            ROT.Left_AnkleAbd(t) = -atan2(ROT.Left_Ankle(3,1,t), sqrt(ROT.Left_Ankle(1,1,t)^2 + ROT.Left_Ankle(2,1,t)^2))*(180/pi);% + (CAL.Right_AnkleAbd - CAL.Leftt_AnkleAbd);
            ROT.Left_AnkleRot(t)  = -atan2(-ROT.Left_Ankle(2,1,t), ROT.Left_Ankle(1,1,t))*(180/pi);% + (CAL.Right_AnkleRot - CAL.Leftt_AnkleRot);
        elseif strcmp(Side, 'Both')
            % right hip
            ROT.Right_Hip(:,:,t) = CAL.ART'*DYN.ART(:,:,t)*(CAL.AP'*DYN.AP(:,:,t))';
            ROT.Right_HipFlex(t) = atan2(-ROT.Right_Hip(3,2,t), ROT.Right_Hip(3,3,t))*(180/pi) - CAL.Right_HipFlex;
            ROT.Right_HipAbd(t) = atan2(ROT.Right_Hip(3,1,t), sqrt(ROT.Right_Hip(1,1,t)^2 + ROT.Right_Hip(2,1,t)^2))*(180/pi) + (CAL.Right_HipAbd - CAL.Left_HipAbd);
            ROT.Right_HipRot(t)  = atan2(-ROT.Right_Hip(2,1,t), ROT.Right_Hip(1,1,t))*(180/pi) + (CAL.Right_HipRot - CAL.Left_HipRot);
            
            % left hip
            ROT.Left_Hip(:,:,t) = CAL.ALT'*DYN.ALT(:,:,t)*(CAL.AP'*DYN.AP(:,:,t))';
            ROT.Left_HipFlex(t) = atan2(-ROT.Left_Hip(3,2,t), ROT.Left_Hip(3,3,t))*(180/pi) - CAL.Left_HipFlex;
            ROT.Left_HipAbd(t) = -atan2(ROT.Left_Hip(3,1,t), sqrt(ROT.Left_Hip(1,1,t)^2 + ROT.Left_Hip(2,1,t)^2))*(180/pi) + (CAL.Left_HipAbd - CAL.Right_HipAbd);
            ROT.Left_HipRot(t)  = -atan2(-ROT.Left_Hip(2,1,t), ROT.Left_Hip(1,1,t))*(180/pi) + (CAL.Left_HipRot - CAL.Right_HipRot);
            
            % right knee
            ROT.Right_Knee(:,:,t) = CAL.ARPS'*DYN.ARPS(:,:,t)*(CAL.ART'*DYN.ART(:,:,t))';
            ROT.Right_KneeFlex(t) = -atan2(-ROT.Right_Knee(3,2,t), ROT.Right_Knee(3,3,t))*(180/pi) - CAL.Right_KneeFlex;
            ROT.Right_KneeAbd(t) = atan2(ROT.Right_Knee(3,1,t), sqrt(ROT.Right_Knee(1,1,t)^2 + ROT.Right_Knee(2,1,t)^2))*(180/pi) + (CAL.Right_KneeAbd - CAL.Left_KneeAbd);
            ROT.Right_KneeRot(t)  = atan2(-ROT.Right_Knee(2,1,t), ROT.Right_Knee(1,1,t))*(180/pi) + (CAL.Right_KneeRot - CAL.Left_KneeRot);
            
            % left knee
            ROT.Left_Knee(:,:,t) = CAL.ALPS'*DYN.ALPS(:,:,t)*(CAL.ALT'*DYN.ALT(:,:,t))';
            ROT.Left_KneeFlex(t) = -atan2(-ROT.Left_Knee(3,2,t), ROT.Left_Knee(3,3,t))*(180/pi) - CAL.Left_KneeFlex;
            ROT.Left_KneeAbd(t) = -atan2(ROT.Left_Knee(3,1,t), sqrt(ROT.Left_Knee(1,1,t)^2 + ROT.Left_Knee(2,1,t)^2))*(180/pi) + (CAL.Left_KneeAbd - CAL.Right_KneeAbd);
            ROT.Left_KneeRot(t)  = -atan2(-ROT.Left_Knee(2,1,t), ROT.Left_Knee(1,1,t))*(180/pi) + (CAL.Left_KneeRot - CAL.Right_KneeRot);
            
            % right ankle
            ROT.Right_Ankle(:,:,t) = CAL.ARF'*DYN.ARF(:,:,t)*(CAL.ARDS'*DYN.ARDS(:,:,t))';
            ROT.Right_AnkleFlex(t) = atan2(-ROT.Right_Ankle(3,2,t), ROT.Right_Ankle(3,3,t))*(180/pi) - CAL.Right_AnkleFlex;
            ROT.Right_AnkleAbd(t) = atan2(ROT.Right_Ankle(3,1,t), sqrt(ROT.Right_Ankle(1,1,t)^2 + ROT.Right_Ankle(2,1,t)^2))*(180/pi) + (CAL.Right_AnkleAbd - CAL.Leftt_AnkleAbd);
            ROT.Right_AnkleRot(t)  = atan2(-ROT.Right_Ankle(2,1,t), ROT.Right_Ankle(1,1,t))*(180/pi) + (CAL.Right_AnkleRot - CAL.Leftt_AnkleRot);
            
            % left ankle
            ROT.Left_Ankle(:,:,t) = CAL.ALF'*DYN.ALF(:,:,t)*(CAL.ALDS'*DYN.ALDS(:,:,t))';
            ROT.Left_AnkleFlex(t) = atan2(-ROT.Left_Ankle(3,2,t), ROT.Left_Ankle(3,3,t))*(180/pi) - CAL.Right_AnkleFlex;
            ROT.Left_AnkleAbd(t) = -atan2(ROT.Left_Ankle(3,1,t), sqrt(ROT.Left_Ankle(1,1,t)^2 + ROT.Left_Ankle(2,1,t)^2))*(180/pi) + (CAL.Right_AnkleAbd - CAL.Leftt_AnkleAbd);
            ROT.Left_AnkleRot(t)  = -atan2(-ROT.Left_Ankle(2,1,t), ROT.Left_Ankle(1,1,t))*(180/pi) + (CAL.Right_AnkleRot - CAL.Leftt_AnkleRot);
        end
    else 
        % right hip
        ROT.Right_Hip(:,:,t) = CAL.ART'*DYN.ART(:,:,t)*(CAL.AP'*DYN.AP(:,:,t))';
        ROT.Right_HipFlex(t) = atan2(-ROT.Right_Hip(3,2,t), ROT.Right_Hip(3,3,t))*(180/pi);
        ROT.Right_HipAbd(t) = atan2(ROT.Right_Hip(3,1,t), sqrt(ROT.Right_Hip(1,1,t)^2 + ROT.Right_Hip(2,1,t)^2))*(180/pi);
        ROT.Right_HipRot(t)  = atan2(-ROT.Right_Hip(2,1,t), ROT.Right_Hip(1,1,t))*(180/pi);
        
        % left hip
        ROT.Left_Hip(:,:,t) = CAL.ALT'*DYN.ALT(:,:,t)*(CAL.AP'*DYN.AP(:,:,t))';
        ROT.Left_HipFlex(t) = atan2(-ROT.Left_Hip(3,2,t), ROT.Left_Hip(3,3,t))*(180/pi);
        ROT.Left_HipAbd(t) = -atan2(ROT.Left_Hip(3,1,t), sqrt(ROT.Left_Hip(1,1,t)^2 + ROT.Left_Hip(2,1,t)^2))*(180/pi);
        ROT.Left_HipRot(t)  = -atan2(-ROT.Left_Hip(2,1,t), ROT.Left_Hip(1,1,t))*(180/pi);
        
        % right knee
        ROT.Right_Knee(:,:,t) = CAL.ARPS'*DYN.ARPS(:,:,t)*(CAL.ART'*DYN.ART(:,:,t))';
        ROT.Right_KneeFlex(t) = -atan2(-ROT.Right_Knee(3,2,t), ROT.Right_Knee(3,3,t))*(180/pi);
        ROT.Right_KneeAbd(t) = atan2(ROT.Right_Knee(3,1,t), sqrt(ROT.Right_Knee(1,1,t)^2 + ROT.Right_Knee(2,1,t)^2))*(180/pi);
        ROT.Right_KneeRot(t)  = atan2(-ROT.Right_Knee(2,1,t), ROT.Right_Knee(1,1,t))*(180/pi);
        
        % left knee
        ROT.Left_Knee(:,:,t) = CAL.ALPS'*DYN.ALPS(:,:,t)*(CAL.ALT'*DYN.ALT(:,:,t))';
        ROT.Left_KneeFlex(t) = -atan2(-ROT.Left_Knee(3,2,t), ROT.Left_Knee(3,3,t))*(180/pi);
        ROT.Left_KneeAbd(t) = -atan2(ROT.Left_Knee(3,1,t), sqrt(ROT.Left_Knee(1,1,t)^2 + ROT.Left_Knee(2,1,t)^2))*(180/pi);
        ROT.Left_KneeRot(t)  = -atan2(-ROT.Left_Knee(2,1,t), ROT.Left_Knee(1,1,t))*(180/pi);
        
        % right ankle
        ROT.Right_Ankle(:,:,t) = CAL.ARF'*DYN.ARF(:,:,t)*(CAL.ARDS'*DYN.ARDS(:,:,t))';
        ROT.Right_AnkleFlex(t) = atan2(-ROT.Right_Ankle(3,2,t), ROT.Right_Ankle(3,3,t))*(180/pi);
        ROT.Right_AnkleAbd(t) = atan2(ROT.Right_Ankle(3,1,t), sqrt(ROT.Right_Ankle(1,1,t)^2 + ROT.Right_Ankle(2,1,t)^2))*(180/pi);
        ROT.Right_AnkleRot(t)  = atan2(-ROT.Right_Ankle(2,1,t), ROT.Right_Ankle(1,1,t))*(180/pi);
        
        % left ankle
        ROT.Left_Ankle(:,:,t) = CAL.ALF'*DYN.ALF(:,:,t)*(CAL.ALDS'*DYN.ALDS(:,:,t))';
        ROT.Left_AnkleFlex(t) = atan2(-ROT.Left_Ankle(3,2,t), ROT.Left_Ankle(3,3,t))*(180/pi);
        ROT.Left_AnkleAbd(t) = -atan2(ROT.Left_Ankle(3,1,t), sqrt(ROT.Left_Ankle(1,1,t)^2 + ROT.Left_Ankle(2,1,t)^2))*(180/pi);
        ROT.Left_AnkleRot(t)  = -atan2(-ROT.Left_Ankle(2,1,t), ROT.Left_Ankle(1,1,t))*(180/pi);
    end
end

end

