function segmentedAngles = anglesSegmentation(ROT, LHS, RHS, CutOffCyc)

PelvisPlane = {'Pelvis_Sagg','Pelvis_Front','Pelvis_Trans'};
Side = {'Left_','Right_'};
Joints = {'Hip','Knee','Ankle'};
JointsPlane = {'Flex','Abd','Rot'};
VarType = {'_Mean','_Std'};

%% pelvis

% - - - - - - - - - - - 
for i = 1 : min(length(LHS),length(RHS)) - 1
    temp = ROT.Pelvis_Sagg(LHS(i):LHS(i+1));
    segmentedAngles.Pelvis_Sagg(i,:) = ScaleTime(temp, linspace(1,size(temp,2),101));
    temp = ROT.Pelvis_Front(LHS(i):LHS(i+1));
    segmentedAngles.Pelvis_Front(i,:) = ScaleTime(temp, linspace(1,size(temp,2),101));
    temp = ROT.Pelvis_Trans(LHS(i):LHS(i+1));
    segmentedAngles.Pelvis_Trans(i,:) = ScaleTime(temp, linspace(1,size(temp,2),101));  
end

% mean and std
for i = 1 : 3 % three planes
    % mean
    segmentedAngles.(strcat(PelvisPlane{i},VarType{1})) = mean(segmentedAngles.(PelvisPlane{i})(CutOffCyc:end,:));
    % std
    segmentedAngles.(strcat(PelvisPlane{i},VarType{2})) = std(segmentedAngles.(PelvisPlane{i})(CutOffCyc:end,:));    
end

%% left side

% - - - - - - - - - - - 
for i = 1 : min(length(LHS),length(RHS)) - 1
    
    % left hip
    temp = - ROT.Left_HipFlex(LHS(i):LHS(i+1));
    segmentedAngles.Left_HipFlex(i,:) = ScaleTime(temp, linspace(1,size(temp,2),101));
    temp = ROT.Left_HipAbd(LHS(i):LHS(i+1));
    segmentedAngles.Left_HipAbd(i,:) = ScaleTime(temp, linspace(1,size(temp,2),101));
    temp = ROT.Left_HipRot(LHS(i):LHS(i+1));
    segmentedAngles.Left_HipRot(i,:) = ScaleTime(temp, linspace(1,size(temp,2),101));
    
    % left knee
    temp = - ROT.Left_KneeFlex(LHS(i):LHS(i+1));
    segmentedAngles.Left_KneeFlex(i,:) = ScaleTime(temp, linspace(1,size(temp,2),101));
    temp = ROT.Left_KneeAbd(LHS(i):LHS(i+1));
    segmentedAngles.Left_KneeAbd(i,:) = ScaleTime(temp, linspace(1,size(temp,2),101));
    temp = ROT.Left_KneeRot(LHS(i):LHS(i+1));
    segmentedAngles.Left_KneeRot(i,:) = ScaleTime(temp, linspace(1,size(temp,2),101));
    
    % left ankle
    temp = ROT.Left_AnkleFlex(LHS(i):LHS(i+1));
    segmentedAngles.Left_AnkleFlex(i,:) = - ScaleTime(temp, linspace(1,size(temp,2),101));
    temp = ROT.Left_AnkleAbd(LHS(i):LHS(i+1));
    segmentedAngles.Left_AnkleAbd(i,:) = ScaleTime(temp, linspace(1,size(temp,2),101));
    temp = ROT.Left_AnkleRot(LHS(i):LHS(i+1));
    segmentedAngles.Left_AnkleRot(i,:) = ScaleTime(temp, linspace(1,size(temp,2),101));

end

% mean and std
for i = 1 : 3 % three joints
    for j = 1 : 3 % three planes
        % mean
        segmentedAngles.(strcat(Side{1},Joints{i},JointsPlane{j},VarType{1})) = mean(segmentedAngles.(strcat(Side{1},Joints{i},JointsPlane{j}))(CutOffCyc:end,:));    
        % std
        segmentedAngles.(strcat(Side{1},Joints{i},JointsPlane{j},VarType{2})) = std(segmentedAngles.(strcat(Side{1},Joints{i},JointsPlane{j}))(CutOffCyc:end,:));
    end
end

%% right side
for i = 1 : min(length(LHS),length(RHS)) - 1
    
    % right hip
    temp = - ROT.Right_HipFlex(RHS(i):RHS(i+1));
    segmentedAngles.Right_HipFlex(i,:) = ScaleTime(temp, linspace(1,size(temp,2),101));
    temp = ROT.Right_HipAbd(RHS(i):RHS(i+1));
    segmentedAngles.Right_HipAbd(i,:) = ScaleTime(temp, linspace(1,size(temp,2),101));
    temp = ROT.Right_HipRot(RHS(i):RHS(i+1));
    segmentedAngles.Right_HipRot(i,:) = ScaleTime(temp, linspace(1,size(temp,2),101));
    
    % right knee
    temp = - ROT.Right_KneeFlex(RHS(i):RHS(i+1));
    segmentedAngles.Right_KneeFlex(i,:) = ScaleTime(temp, linspace(1,size(temp,2),101));
    temp = ROT.Right_KneeAbd(RHS(i):RHS(i+1));
    segmentedAngles.Right_KneeAbd(i,:) = ScaleTime(temp, linspace(1,size(temp,2),101));
    temp = ROT.Right_KneeRot(RHS(i):RHS(i+1));
    segmentedAngles.Right_KneeRot(i,:) = ScaleTime(temp, linspace(1,size(temp,2),101));
    
    % right ankle
    temp = ROT.Right_AnkleFlex(RHS(i):RHS(i+1));
    segmentedAngles.Right_AnkleFlex(i,:) = - ScaleTime(temp, linspace(1,size(temp,2),101));
    temp = ROT.Right_AnkleAbd(RHS(i):RHS(i+1));
    segmentedAngles.Right_AnkleAbd(i,:) = ScaleTime(temp, linspace(1,size(temp,2),101));
    temp = ROT.Right_AnkleRot(RHS(i):RHS(i+1));
    segmentedAngles.Right_AnkleRot(i,:) = ScaleTime(temp, linspace(1,size(temp,2),101));
    
end

% mean and std
for i = 1 : 3 % three joints
    for j = 1 : 3 % three planes
        % mean
        segmentedAngles.(strcat(Side{2},Joints{i},JointsPlane{j},VarType{1})) = mean(segmentedAngles.(strcat(Side{2},Joints{i},JointsPlane{j}))(CutOffCyc:end,:));    
        % std
        segmentedAngles.(strcat(Side{2},Joints{i},JointsPlane{j},VarType{2})) = std(segmentedAngles.(strcat(Side{2},Joints{i},JointsPlane{j}))(CutOffCyc:end,:));
    end
end

