function [LHS,LTO,RHS,RTO] = GaitCycleDetection(GRF_left,GRF_right,threshold)

% treshold of XX [N] to define heel strike/toe-off
ref = repmat(threshold,length(GRF_right),1);

% find the indices where the GRF crosses the threshold
%zci = @(v) find(v(:).*circshift(v(:), -1) <= 0); 
offsetL = GRF_left - ref;
offsetR = GRF_right - ref;
prodL = offsetL .* circshift(offsetL,-1);
prodR = offsetR .* circshift(offsetR,-1);
zxL = find(prodL(1:end-1)<=0);
zxR = find(prodR(1:end-1)<=0);

% derivative of GRF to distinguish heel strike and toe-off 
dGRFl = diff(GRF_left);     
dGRFr = diff(GRF_right);
if dGRFr(zxR(1)) > 0   % if the first crossing has a positive derivative of GRF, then the odds are heel strike and the evens are toe-off or vice versa
    RHS = zxR(1:2:end);  
    RTO = zxR(2:2:end);
else
    RHS = zxR(2:2:end);  
    RTO = zxR(1:2:end);
end
if dGRFl(zxL(1)) > 0   % if the first crossing has a positive derivative of GRF, then the odds are heel strike and the evens are toe-off or vice versa
    LHS = zxL(1:2:end);  
    LTO = zxL(2:2:end);
else
    LHS = zxL(2:2:end);  
    LTO = zxL(1:2:end);
end

end

