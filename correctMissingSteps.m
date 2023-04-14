function [LHS_new,RHS_new,LTO_new,RTO_new] = correctMissingSteps(LHS,RHS,LTO,RTO,cntL,cntR)

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
        LHS_index = find(LHS_diff > 1.5 * leftStep);
        % only take the first missing step
        tempInd = LHS_index(1);
        % re-calculate average stepT taking all the good steps
        leftStep = round(mean(LHS_diff(1:tempInd-1)));
        % add a single missing steps (even if multiple are missing)
        LHS(tempInd+2:length(LHS)+1) = LHS(tempInd+1:end);
        LHS(tempInd+1) = LHS(tempInd) + leftStep;
        % find where there are missing steps
        LTO_index = find(LTO_diff > 1.5 * leftStep);
        % only take the first missing step
        tempInd = LTO_index(1);
        LTO(tempInd+2:length(LTO)+1) = LTO(tempInd+1:end);
        LTO(tempInd+1) = LTO(tempInd) + leftStep;
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
        RHS_index = find(RHS_diff > 1.5 * rightStep);
        % only take the first missing step
        tempInd = RHS_index(1);
        % re-calculate average stepT taking all the good steps
        rightStep = round(mean(RHS_diff(1:tempInd-1)));
        % add a single missing steps (even if multiple are missing)
        RHS(tempInd+2:length(RHS)+1) = RHS(tempInd+1:end);
        RHS(tempInd+1) = RHS(tempInd) + rightStep;
        % find where there are missing steps
        RTO_index = find(RTO_diff > 1.5 * rightStep);
        % only take the first missing step
        tempInd = RTO_index(1);
        RTO(tempInd+2:length(RTO)+1) = RTO(tempInd+1:end);
        RTO(tempInd+1) = RTO(tempInd) + rightStep;
        cntR = cntR - 1;
    end        
end

LHS_new = LHS; RHS_new = RHS;
LTO_new = LTO; RTO_new = RTO;