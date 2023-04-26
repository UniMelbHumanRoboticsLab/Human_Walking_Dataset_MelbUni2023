function [LHS_new,RHS_new,LTO_new,RTO_new] = correctFalsePositives(LHS,RHS,LTO,RTO,cntL,cntR)

goodSteps = 5;

% correct left side
if cntL ~= 0
    % loop as many times as there are missing steps
    while cntL > 0
        % calculate stepT
        LHS_diff = diff(LHS); LTO_diff = diff(LTO);
        % calculate average stepT assuming first goodSteps steps are ok
        leftStep = round(mean(LHS_diff(1:goodSteps)));
        % find where there are missing steps (may be >1)
        LHS_index = find(LHS_diff < 0.6 * leftStep);
        % only take the first missing step
        tempInd = LHS_index(1);
        % remove the false positive; as there are two TO and two HS events, 
        % remove the 2nd TO and 1st HS
        LHS(tempInd:end-1) = LHS(tempInd+1:end); LHS = LHS(1:end-1);
        % find where there are missing steps (may be >1)
        LTO_index = find(LTO_diff < 0.6 * leftStep);
        % only take the first missing step
        tempInd = LTO_index(1);        
        LTO(tempInd+1:end-1) = LTO(tempInd+2:end); LTO = LTO(1:end-1);
        % reduce the counter
        cntL = cntL - 1;
    end        
end

% correct right side
if cntR ~= 0
    % loop as many times as there are missing steps
    while cntR > 0
        % calculate stepT
        RHS_diff = diff(RHS); RTO_diff = diff(RTO);
        % calculate average stepT assuming first goodSteps steps are ok
        rightStep = round(mean(RHS_diff(1:goodSteps)));
        % find where there are missing steps (may be >1)
        RHS_index = find(RHS_diff < 0.6 * rightStep);
        % only take the first missing step
        tempInd = RHS_index(1);
        % remove the false positive; as there are two TO and two HS events, 
        % remove the 2nd TO and 1st HS
        RHS(tempInd:end-1) = RHS(tempInd+1:end); RHS = RHS(1:end-1);        
        % find where there are missing steps (may be >1) 
        RTO_index = find(RTO_diff < 0.6 * rightStep);
        % only take the first missing step
        tempInd = RTO_index(1);
        RTO(tempInd+1:end-1) = RTO(tempInd+2:end); RTO = RTO(1:end-1);
        % reduce the counter
        cntR = cntR - 1;
    end        
end

LHS_new = LHS; RHS_new = RHS;
LTO_new = LTO; RTO_new = RTO;
