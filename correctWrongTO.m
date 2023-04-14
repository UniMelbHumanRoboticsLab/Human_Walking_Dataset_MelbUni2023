function [LTO_new,RTO_new] = correctWrongTO(LHS,RHS,LTO,RTO,cntL,cntR,LeftDiff,RightDiff,leftToHs,rightToHs)

% correct left side
if cntL ~= 0
    countLup = 1;
    % find where there are too small differences in TO-HS
    LTO_index = find(LeftDiff < 0.6 * leftToHs);
    % loop as many times as there are missing steps
    while cntL > 0
        % only take the first missing step
        tempInd = LTO_index(countLup);
        % change TO event if its too close to HS
        LTO(tempInd) = LHS(tempInd+1) - leftToHs;        
        % reduce the counter
        cntL = cntL - 1;
        countLup = countLup + 1;
    end        
end

% correct right side
if cntR ~= 0
    countRup = 1;
    % find where there are too small differences in TO-HS
    RTO_index = find(RightDiff < 0.6 * rightToHs);
    % loop as many times as there are missing steps
    while cntR > 0
        % only take the first missing step
        tempInd = RTO_index(countRup);
        % change TO event if its too close to HS
        RTO(tempInd) = RHS(tempInd+1) - rightToHs;        
        % reduce the counter
        cntR = cntR - 1;
        countRup = countRup + 1;
    end        
end

LTO_new = LTO; RTO_new = RTO;