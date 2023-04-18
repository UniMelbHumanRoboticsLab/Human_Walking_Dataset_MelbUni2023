function EMGdata = EMG_GaitCycle(LHS, RHS, EMGdata, Test, tst, Side, Muscles)

% left side 
for m = 1 : 8
    for i = 1 : length(LHS) - 1
        temp = EMGdata.RMS.(Test{tst}).(strcat(Side{1},'_',Muscles{m}))(LHS(i):LHS(i+1));
        EMGdata.Cycles.(Test{tst}).(strcat(Side{1},'_',Muscles{m}))(i,:) = ScaleTime(temp, linspace(1,length(temp),1001));
    end
end

% right side
for m = 1 : 8
    for i = 1 : length(RHS) - 1
        temp = EMGdata.RMS.(Test{tst}).(strcat(Side{2},'_',Muscles{m}))(RHS(i):RHS(i+1));
        EMGdata.Cycles.(Test{tst}).(strcat(Side{2},'_',Muscles{m}))(i,:) = ScaleTime(temp, linspace(1,length(temp),1001));
    end
end

end

