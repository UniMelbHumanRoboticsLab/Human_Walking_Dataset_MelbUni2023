% MAIN SCRIPT FOR DATA ANALYSIS
% loads Subject data; segments it using GRF_vertical; plots data
% provided with the paper "A biomechanics and energetics dataset of neurotypical adults walking with and without kinematic constraints"
% Author: Bacek Tomislav, The University of Melbourne
% May 2024

%% general info
% data from Belt1 corresponds to the left leg, and data from Belt2 to the right leg
% GRF data in 1 kHz; Vicon data in 100 Hz; EMG data in 2 kHz
        
% - - - - - - - - - - - - - - - - - - - -
% experimental order corresponding to T1 T2 T3 T4... T30
% (these are fixed to a certain walking condition)
% T1 = 1.1m/s -- NO orthosis -- -10%
% T2 = 1.1m/s -- NO orthosis -- -5%
% T3 = 1.1m/s -- NO orthosis -- preferred
% T4 = 1.1m/s -- NO orthosis -- +10%
% T5 = 1.1m/s -- NO orthosis -- +20%

% T6 = 0.8m/s -- NO orthosis -- -10%
% T7 = 0.8m/s -- NO orthosis -- -5%
% T8 = 0.8m/s -- NO orthosis -- preferred
% T9 = 0.8m/s -- NO orthosis -- +10%
% T10 = 0.8m/s -- NO orthosis -- +20%

% T11 = 0.4m/s -- NO orthosis -- -10%
% T12 = 0.4m/s -- NO orthosis -- -5%
% T13 = 0.4m/s -- NO orthosis -- preferred
% T14 = 0.4m/s -- NO orthosis -- +10%
% T15 = 0.4m/s -- NO orthosis -- +20%

% T16 = 1.1m/s -- orthosis -- -10%
% T17 = 1.1m/s -- orthosis -- -5%
% T18 = 1.1m/s -- orthosis -- preferred
% T19 = 1.1m/s -- orthosis -- +10%
% T20 = 1.1m/s -- orthosis -- +20%

% T21 = 0.8m/s -- orthosis -- -10%
% T22 = 0.8m/s -- orthosis -- -5%
% T23 = 0.8m/s -- orthosis -- preferred
% T24 = 0.8m/s -- orthosis -- +10%
% T25 = 0.8m/s -- orthosis -- +20%

% T26 = 0.4m/s -- orthosis -- -10%
% T27 = 0.4m/s -- orthosis -- -5%
% T28 = 0.4m/s -- orthosis -- preferred
% T29 = 0.4m/s -- orthosis -- +10%
% T30 = 0.4m/s -- orthosis -- +20%

%% initialise

clc
clear
%close all;
format short g

%% load data
% go to the folder where data are saved
message = ['Select folder where data are saved (i.e., rawMechanics)']; 
disp(message);
datafolder = uigetdir(cd, message);
addpath(genpath(datafolder))

%% * * * * * * C H O O S E !!!!!! * * * * * * * 
% Subject and Session

% - - - - - SUBJECT ID - - - - -
Subject = {'Sub1','Sub2','Sub3','Sub4','Sub5','Sub6','Sub7','Sub8','Sub9','Sub10','Sub11','Sub12','Sub13','Sub14','Sub15','Sub16','Sub17','Sub18','Sub19','Sub20','Sub21'};
Subject_ID = input('Choose the subject (1-21):');

% - - - - - SESSION ID - - - - - - - - 
% sessions
% Session1 = familiarisation; Session2 = 1st data collection session;
% Session3 = 2nd data collection session
Session = {'Session1','Session2','Session3'};
Session_ID = input('Choose the session (2 or 3):');

% - - - - - - ANGLES CORRECTION - - - - - -
% should static calibration correction be applied? (zeroing)
Correction = {'Corr_Yes','Corr_No'}; % 1 or 2
Correction_ID = 1;
% if yes, which leg side should be corrected
Side = {'Left','Right','Both'}; % 1, 2, or 3
Side_ID = 3;

%% load subject-specific data

fprintf('loading rawMechanics data...')
load(strcat(char(Subject(Subject_ID)),'_rawMechanics.mat'));
fprintf('done! \n')

load('Subjects_Info.mat');
TestOrder = SubjectInfo.(Subject{Subject_ID}).(Session{Session_ID}).TestOrder;
ConditionOrder = SubjectInfo.(Subject{Subject_ID}).(Session{Session_ID}).ConditionOrder;
WalkSpeedOrder = SubjectInfo.(Subject{Subject_ID}).(Session{Session_ID}).WalkSpeedOrder;
SpeedOrder = SubjectInfo.(Subject{Subject_ID}).(Session{Session_ID}).SpeedOrder;
SpeedW = SubjectInfo.(Subject{Subject_ID}).(Session{Session_ID}).SpeedW;
CadenceRef = SubjectInfo.(Subject{Subject_ID}).(Session{Session_ID}).CadenceRef;
LowerLimbMarkers = SubjectInfo.(Subject{Subject_ID}).(Session{Session_ID}).LowerLimbMarkers;
UpperLimbMarkers = SubjectInfo.(Subject{Subject_ID}).(Session{Session_ID}).UpperLimbMarkers;
MarkerOption = SubjectInfo.(Subject{Subject_ID}).Session2.MarkerOption;
Mass = SubjectInfo.(Subject{Subject_ID}).(Session{Session_ID}).Mass;

TotalMarkers = LowerLimbMarkers + UpperLimbMarkers;

% define mass and weight
Weight = Mass * 9.81; 

% define leg length
LegLength_vector = [0.87 0.89 0.97 0.87 0.82 0.91 0.86 0.91 0.82 0.95 0.95 0.84 0.87 0.87 0.78 0.84 0.84 0.93 0.74 0.93 0.96]; % [m]
LegLength = LegLength_vector(Subject_ID);

%% * * * * * * C H O O S E !!!!!! * * * * * * * 
% GRF parameters etc

% - - - - - - - TESTS RANGE - - - - - - - 
% Bout1: 1-5; Bout2: 6-10; Bout3: 11-16
count_start = 1; 
count_end = 5;

% - - - - - - GRF SEGMENTATION - - - - - - -
GRF_Threshold = 0.05; % percentage of weight [0-1], ie 0.1 takes 10% of weight to segment vertical GRF

% - - - - - - - GRF SIGNAL FREQ - - - - - - -
Freq_GRF = 1000; % Hz; sometimes it is 2000 Hz

% - - - - - - - MEAN DATA - - - - - - 
Cycles_Mean = 0.8; % takes (1-Cycles_Mean)*100% of data at the end of a 5-min test to calculate mean (eg 0.8 takes last 20%=1min of data)

% - - - - - - - SEGMENTS FOR DATA ANALYSIS - - - - - -
Segments10s_Total = 29; % default 30 -> in 300sec (5-min) tests, each segment is 10 sec

% - - - - - MOVING AVERAGE WINDOW - - - - - - -
movAvgWin = 5;

%% * * * * * * * * * DEFINITIONS * * * * * * * * * * *

% - - - - - BOUT ID - - - - - - - - 
Bout = {'Bout1','Bout2','Bout3'};
% Bout_ID defined later

% - - - - - ORTHOSIS ID - - - - - - - - 
Orthosis = {'without','with'};
% Orthosis_ID defined later

% - - - - - CONDITION ID - - - - - - - - 
Condition = {'free','orthosis'};
% Condition_ID defined later

% - - - - - SPEED - - - - - - - - 
WalkSpeed = {'0.4 m/s','0.8 m/s','1.1 m/s'};
% WalkSpeed_ID defined later

% - - - - - GRF/COP VECTORS - - - - - - -
ForceCoP = {'GRF_Lz','GRF_Rz','CoP_Lx','CoP_Rx','CoP_Ly','CoP_Ry'};

% - - - - - - - GRF CUT-OFF FORCE - - - - - - -
GRF_CutOff = floor(GRF_Threshold * Weight); % [N] threshold (maybe use a fixed % of body-Mass as alternative)

% - - - - - - - TESTS - - - - - - - - -
TestNmbr = length(TestOrder); % tests number [in total 30 5-min tests, 6 25-min trials]
Test = cell(TestNmbr,1);
for t = 1 : TestNmbr
    Test(t) = {strcat('T',num2str(TestOrder(t)))};
end

% - - - - - - BUTTERWORTH FILTER GRF CUT-OFF - - - - - -
LowPassCutOff_GRF = 15; % Hz

%% display a message
fprintf(strcat('running kinetics analysis for: ',char(Subject(Subject_ID)),'-',char(Session(Session_ID)),'\n'))

%% read in and manipulate walking GRF data
for tst = 1%count_start : count_end
    % go through all three bouts, 5 tests per bout
    if tst <= 5
       Bout_ID = 1;
       Condition_ID = ConditionOrder(1);
       WalkSpeed_ID = WalkSpeedOrder(1);
    elseif tst > 5 && tst <= 10
       Bout_ID = 2;
       WalkSpeed_ID = WalkSpeedOrder(2);
       Condition_ID = ConditionOrder(2);
    else
       Bout_ID = 3;
       Condition_ID = ConditionOrder(3);
       WalkSpeed_ID = WalkSpeedOrder(3);
    end
    
    % - - - - - - - - - - - - - - - - - - - -
    % extract GRF, and x-y CoP of both legs 
    % forces in [N], CoP position in [mm]
    GRF_LzRaw = rawMechanics.(Test{tst}).GRF.V_Left; % [N] 
    GRF_RzRaw = rawMechanics.(Test{tst}).GRF.V_Right; % [N] 
    GRF_LyRaw = rawMechanics.(Test{tst}).GRF.AP_Left; % [N] 
    GRF_RyRaw = rawMechanics.(Test{tst}).GRF.AP_Right; % [N] 
    GRF_LxRaw = rawMechanics.(Test{tst}).GRF.LM_Left; % [N] 
    GRF_RxRaw = rawMechanics.(Test{tst}).GRF.LM_Right; % [N] 
    CoP_LxRaw = rawMechanics.(Test{tst}).CoP.LM_Left; % [m] 
    CoP_LyRaw = rawMechanics.(Test{tst}).CoP.AP_Left; % [m] 
    CoP_RxRaw = rawMechanics.(Test{tst}).CoP.LM_Right; % [m] 
    CoP_RyRaw = rawMechanics.(Test{tst}).CoP.AP_Right; % [m] 
 
    % - - - - - - - - - - - - - - - - - - - -
    % filter GRF and CoP on both legs
    [b,a] = butter(6,LowPassCutOff_GRF/(Freq_GRF/2)); % butteworth filter, 6Hz cut-off
    GRF_LzFil = filtfilt(b,a,GRF_LzRaw);
    GRF_RzFil = filtfilt(b,a,GRF_RzRaw);
    GRF_LyFil = filtfilt(b,a,GRF_LyRaw);
    GRF_RyFil = filtfilt(b,a,GRF_RyRaw);
    GRF_LxFil = filtfilt(b,a,GRF_LxRaw);
    GRF_RxFil = filtfilt(b,a,GRF_RxRaw);
    CoP_LxFil = filtfilt(b,a,CoP_LxRaw);
    CoP_RxFil = filtfilt(b,a,CoP_RxRaw);
    CoP_LyFil = filtfilt(b,a,CoP_LyRaw);
    CoP_RyFil = filtfilt(b,a,CoP_RyRaw);

    % - - - - - - - - - - - - - - - - - - - -
    % detect heel strike and toe off events
    [LHS,LTO,RHS,RTO] = GaitCycleDetection(GRF_LzFil,GRF_RzFil,GRF_CutOff); % function that outputs HS, TO time stamps

    % - - - - - - - - - - - - - - - - - - - -
    % plot GRF data with the initial HS and TO indicators
    T = length(GRF_LzFil);
    figure()
    set(gcf,'Color','white');
    % - - - - - 
    subplot(4,2,1)
    plot(GRF_LzFil,'Linewidth',2); grid on; hold on; plot(repmat(GRF_CutOff,T,1));
    ylim([0 1000]); xlim([0 T]); plot(LHS,GRF_LzFil(LHS),'ko'); plot(LTO,GRF_LzFil(LTO),'*');
    legend('raw','cut-off','heel strike','toe-off'); title('vGRF left leg over time - before corrections','FontSize',12,'FontWeight','Bold');
    set(gca,'FontSize', 11, 'FontWeight','Bold')
    % - - - - - 
    subplot(4,2,5)
    plot(GRF_RzFil,'Linewidth',2); grid on; hold on; plot(repmat(GRF_CutOff,T,1));
    ylim([0 1000]); xlim([0 T]); plot(RHS,GRF_RzFil(RHS),'o'); plot(RTO,GRF_RzFil(RTO),'*');
    title('vGRF right leg over time - before corrections','FontSize',12,'FontWeight','Bold');
    set(gca,'FontSize', 11, 'FontWeight','Bold')
    
    fprintf('code paused. press space to continue...\n')
    pause
    
    % - - - - - - - - - - - - - - - - - - - -
    % check there are no false positives, and remove those
    LHS_diff = diff(LHS); RHS_diff = diff(RHS);
    % assuming no step is missing in the first 5 steps
    leftStep = round(mean(LHS_diff(1:5))); rightStep = round(mean(RHS_diff(1:5)));
    % if there's a false positive, stepT will be < 0.6 mean stepT
    cntL = 0; cntR = 0;
    for j = 1 : length(LHS) - 1
        if LHS_diff(j) < 0.6 * leftStep 
            cntL = cntL + 1;
        end
    end
    for j = 1 : length(RHS) - 1
        if RHS_diff(j) < 0.6 * rightStep 
            cntR = cntR + 1;
        end
    end    
    % if there are false positives (ie multiple HS when there should be
    % one) this function will remove those
    if cntR > 0 || cntL > 0
        [LHS_new,RHS_new,LTO_new,RTO_new] = correctFalsePositives(LHS,RHS,LTO,RTO,cntL,cntR);
        LHS = LHS_new; RHS = RHS_new; LTO = LTO_new; RTO = RTO_new;
        fprintf('false positives detected!\n')
    else
        fprintf('no false positives detected.\n')    
    end
    
    % - - - - - - - - - - - - - - - - - - - -
    % check that no steps are missing (i.e. stepping on the wrong belt) and add missing steps
    LHS_diff = diff(LHS); RHS_diff = diff(RHS);
    % assuming no step is missing in the first 5 steps
    leftStep = round(mean(LHS_diff(1:5))); rightStep = round(mean(RHS_diff(1:5)));
    % if there's a step missing, stepT will be more than 1.5 mean stepT
    cntL = 0; cntR = 0;
    for j = 1 : length(LHS) - 1
        if LHS_diff(j) > 1.5 * leftStep && LHS_diff(j) < 2.2 * leftStep
            cntL = cntL + 1;
        elseif LHS_diff(j) >= 2.2 * leftStep && LHS_diff(j) < 3.2 * leftStep
            cntL = cntL + 2;
        elseif LHS_diff(j) >= 3.2 * leftStep && LHS_diff(j) < 4.2 * leftStep
            cntL = cntL + 3;
        elseif LHS_diff(j) >= 4.2 * leftStep && LHS_diff(j) < 5.2 * leftStep
            cntL = cntL + 4;
        end
    end
    for j = 1 : length(RHS) - 1
        if RHS_diff(j) > 1.5 * rightStep && RHS_diff(j) < 2.2 * rightStep
            cntR = cntR + 1;
        elseif RHS_diff(j) >= 2.2 * rightStep && RHS_diff(j) < 3.2 * rightStep
            cntR = cntR + 2;
        elseif RHS_diff(j) >= 3.2 * rightStep && RHS_diff(j) < 4.2 * rightStep
            cntR = cntR + 3;
        elseif RHS_diff(j) >= 4.2 * rightStep && RHS_diff(j) < 5.2 * rightStep
            cntR = cntR + 4;
        end
    end
    % if there are missing steps, run a function that corrects it
    % this works with 1 missing steps at a time, but can handle all missing
    % steps, individual or part of a group of missing steps
    if cntR > 0 || cntL > 0
        [LHS_new,RHS_new,LTO_new,RTO_new] = correctMissingSteps(LHS,RHS,LTO,RTO,cntL,cntR);
        LHS = LHS_new; RHS = RHS_new; LTO = LTO_new; RTO = RTO_new;
        fprintf('missing steps detected!\n')
    else
        fprintf('no missing steps detected.\n')
    end
    
    % - - - - - - - - - - - - - - - - - - - -
    % make sure that all steps that we analyse later start with HS and end with TO
    if LHS(1) > LTO(1)
        LTO = LTO(2:end); % remove TO event if it preceeds HS
    end
    if LHS(end) > LTO(end)
       LHS = LHS(1:end-1); % remove HS event if it's not followed by TO 
    end
    if RHS(1) > RTO(1)
        RTO = RTO(2:end); % remove TO event if it preceeds HS
    end
    if RHS(end) > RTO(end)
       RHS = RHS(1:end-1); % remove HS event if it's not followed by TO 
    end
    
    % - - - - - - - - - - - - - - - - - - - -
    % make sure the analysis always starts with Left step
    if RHS(1) < LHS(1) % if Right step happens first
      RHS = RHS(2:end); RTO = RTO(2:end); % remove the first Right step 
    end
    
    % - - - - - - - - - - - - - - - - - - - -
    % make sure there is the same # of analysed steps left-right
    if length(LHS) > length(RHS) % more left leg steps than right
        StpDiff = length(LHS) - length(RHS);
        LHS = LHS(1:end-StpDiff); LTO = LTO(1:end-StpDiff); % remove steps at the end
    else % more right leg steps than left
        StpDiff = length(RHS) - length(LHS);
        RHS = RHS(1:end-StpDiff); RTO = RTO(1:end-StpDiff); % remove steps at the end
    end

    % - - - - - - - - - - - - - - - - - - - -
    % check that TO events are not wrongly too close to HS events
    for j = 1 : length(LHS) - 1
        LeftDiff(j) = LHS(j+1) - LTO(j);
        RightDiff(j) = RHS(j+1) - RTO(j);
    end
    % assuming no step is missing in the first 5 steps
    leftToHs = round(mean(LeftDiff(1:5))); rightToHs = round(mean(RightDiff(1:5)));
    % if there's wrong identification, TO(j) - HS(j+1) will be < 0.4 mean difference
    cntL = 0; cntR = 0;
    for j = 1 : length(LHS) - 1
        if LeftDiff(j) < 0.4 * leftToHs
            cntL = cntL + 1;
        end
    end
    for j = 1 : length(RHS) - 1
        if RightDiff(j) < 0.6 * rightToHs
            cntR = cntR + 1;
        end
    end
    % call a function to correct this 
    if cntR > 0 || cntL > 0
        [LTO_new,RTO_new] = correctWrongTO(LHS,RHS,LTO,RTO,cntL,cntR,LeftDiff,RightDiff,leftToHs,rightToHs);
        LTO = LTO_new; RTO = RTO_new;
    end

    % - - - - - - - - - - - - - - - - - - - -
    % check cadence whether it was followed (size = number of gait cycles-1)
    StepsTimeR = (RHS(2:end) - LHS(2:end)) / 1000; % time between two subsequent HS in [s], right side leading
    StepsTimeL = (LHS(2:end) - RHS(1:end-1)) / 1000; % time between two subsequent HS in [s], left side leading
    StridesTime = diff(LHS) / 1000; % time between two subsequent HS of the left leg
    
    StepsTimeRef = 60 / CadenceRef(tst); % reference step time [s]
    StridesTimeRef = 120 / CadenceRef(tst); % reference stride time [s]
    
    StepsTimeOff_R = (StepsTimeR / StepsTimeRef) * 100; % actual step time as [%] of reference
    StepsTimeOff_L = (StepsTimeL / StepsTimeRef) * 100; % actual step time as [%] of reference
    StridesTimeOff = (StridesTime / StridesTimeRef) * 100; % actual stride time as [%] of reference
        
    % save heel strike indices (original 1kHz data) [ms]
    GaitIndex.(Test{tst}).LHS_1kHz = LHS;
    GaitIndex.(Test{tst}).LTO_1kHz = LTO;
    GaitIndex.(Test{tst}).RHS_1kHz = RHS;
    GaitIndex.(Test{tst}).RTO_1kHz = RTO;
    % - - - - - - - - - - - - - - - - - - - -
    % convert heel strike indices from GRF data (1000 Hz) to VICON data
    % (100 Hz) and save [10 ms]
    GaitIndex.(Test{tst}).LHS = round(LHS/10);
    GaitIndex.(Test{tst}).LTO = round(LTO/10);
    GaitIndex.(Test{tst}).RHS = round(RHS/10);
    GaitIndex.(Test{tst}).RTO = round(RTO/10);
        
    % - - - - - - - - - - - - - - - - - - - -
    % segment GRF and CoP into cycles, both individual and combined values
    % L/R = left/right, z = vertical, y = ant-post, x = lat-med, VERT = L+R vertical, AP = L+R ant-post, LM = L+R lat-med
    % cycles include both L and R individual forces, and summed forces on
    % both L stride (left HS-to-HS) and R strides (right HS-to-HS)
    [GRF_LzCyc,GRF_RzCyc,GRF_VERTCyc,GRF_APCyc,GRF_LMCyc,GRF_LyCyc,GRF_RyCyc,GRF_LxCyc,GRF_RxCyc,...
       CoP_LxCyc,CoP_RxCyc,CoP_LyCyc,CoP_RyCyc,CoP_APCyc,CoP_LMCyc,GRF_RyCyc_RHS,GRF_RzCyc_RHS,GRF_RxCyc_RHS,...
       GRF_VERTCyc_RHS,GRF_APCyc_RHS,GRF_LMCyc_RHS,CoP_RyCyc_RHS,CoP_RxCyc_RHS] = GRFsegmentation(LHS,...
         RHS,LTO,RTO,GRF_LzFil,GRF_RzFil,GRF_LyFil,GRF_RyFil,GRF_LxFil,GRF_RxFil,CoP_LxFil,CoP_RxFil,CoP_LyFil,CoP_RyFil,GRF_CutOff);

    % - - - - - - - - - - - - - - - - - - - -
    % plot GRF data with the corrected HS and TO indicators
    % - - - - - 
    subplot(4,2,3)
    plot(GRF_LzFil,'Linewidth',2); grid on; hold on; plot(repmat(GRF_CutOff,T,1));
    ylim([0 1000]); xlim([0 T]); plot(LHS,GRF_LzFil(LHS),'ko'); plot(LTO,GRF_LzFil(LTO),'*');
    title('vGRF left leg over time - after corrections','FontSize',12,'FontWeight','Bold');
    set(gca,'FontSize', 11, 'FontWeight','Bold')
    % - - - - - 
    subplot(4,2,7)
    plot(GRF_RzFil,'Linewidth',2); grid on; hold on; plot(repmat(GRF_CutOff,T,1));
    ylim([0 1000]); xlim([0 T]); plot(RHS,GRF_RzFil(RHS),'o'); plot(RTO,GRF_RzFil(RTO),'*');
    title('vGRF right leg over time - after corrections','FontSize',12,'FontWeight','Bold');
    set(gca,'FontSize', 11, 'FontWeight','Bold')
    % - - - - - 
    subplot(4,2,[2 4])
    plot(GRF_LzCyc','black','Linewidth',2); grid on; xlim([0 100]);
    title('vGRF Left per cycle','FontSize',12,'FontWeight','Bold');
    % - - - - - 
    subplot(4,2,[6 8])
    plot(GRF_RzCyc','black','Linewidth',2); grid on; xlim([0 100]); xlabel('gait cycle [%]')
    title('vGRF Right per cycle','FontSize',12,'FontWeight','Bold');
    % the entire figure title
    set(findobj(gcf,'type','axes'),'FontWeight','Bold', 'LineWidth', 2);
    sgtitle(strcat('Ground reaction forces in Test',num2str(TestOrder(tst))),'FontSize',15,'FontWeight','Bold')

    fprintf('code paused. press space to continue...\n')
    pause

    % - - - - - - - - - - - - - - - - - - - -
    % plot GRF and CoP data
    figure()
    set(gcf,'Color','white');
    % - - - - - 
    subplot(4,3,1)
    plot(GRF_LxCyc'),hold on, plot(mean(GRF_LxCyc),'k','linewidth',2),grid on
    ylabel('force [N]'),title('Left GRF LM','FontSize',12,'FontWeight','Bold')
    % - - - - - 
    subplot(4,3,2)
    plot(GRF_LyCyc'),hold on, plot(mean(GRF_LyCyc),'k','linewidth',2),grid on
    ylabel('force [N]'),title('Left GRF AP','FontSize',12,'FontWeight','Bold')
    % - - - - - 
    subplot(4,3,3)
    plot(GRF_LzCyc'),hold on, plot(mean(GRF_LzCyc),'k','linewidth',2),grid on
    ylabel('force [N]'),title('Left GRF Vert','FontSize',12,'FontWeight','Bold')
    % - - - - - 
    subplot(4,3,4)
    plot(GRF_RxCyc'),hold on, plot(mean(GRF_RxCyc),'k','linewidth',2),grid on
    ylabel('force [N]'),title('Right GRF LM','FontSize',12,'FontWeight','Bold')
    % - - - - - 
    subplot(4,3,5)
    plot(GRF_RyCyc'),hold on, plot(mean(GRF_RyCyc),'k','linewidth',2),grid on
    ylabel('force [N]'),title('Right GRF AP','FontSize',12,'FontWeight','Bold')
    % - - - - - 
    subplot(4,3,6)
    plot(GRF_RzCyc'),hold on, plot(mean(GRF_RzCyc),'k','linewidth',2),grid on
    ylabel('force [N]'),xlabel('gait cycle [%]'),title('Right GRF Vert','FontSize',12,'FontWeight','Bold')
    % - - - - - 
    subplot(4,3,7)
    plot(CoP_LxCyc'),hold on, plot(mean(CoP_LxCyc),'k','linewidth',2),grid on
    ylabel('disp. [m]'),title('Left CoP LM','FontSize',12,'FontWeight','Bold')
    % - - - - - 
    subplot(4,3,8)
    plot(CoP_LyCyc'),hold on, plot(mean(CoP_LyCyc),'k','linewidth',2),grid on
    ylabel('disp. [m]'),title('Left CoP AP','FontSize',12,'FontWeight','Bold')
    % - - - - - 
    subplot(4,3,9)
    plot(GRF_RzCyc_RHS'),hold on, plot(mean(GRF_RzCyc_RHS),'k','linewidth',2),grid on
    ylabel('force [N]'),title('Right Vert GRF (RHS)','FontSize',12,'FontWeight','Bold')
    % - - - - - 
    subplot(4,3,10)
    plot(CoP_RxCyc'),hold on, plot(mean(CoP_RxCyc),'k','linewidth',2),grid on
    ylabel('disp. [m]'),xlabel('gait cycle [%]'),title('Right CoP LM','FontSize',12,'FontWeight','Bold')
    % - - - - - 
    subplot(4,3,11)
    plot(CoP_RyCyc'),hold on, plot(mean(CoP_RyCyc),'k','linewidth',2),grid on
    ylabel('disp. [m]'),xlabel('gait cycle [%]'),title('Right CoP AP','FontSize',12,'FontWeight','Bold')
    % - - - - - 
    subplot(4,3,12)
    plot(GRF_RyCyc_RHS'),hold on, plot(mean(GRF_RyCyc_RHS),'k','linewidth',2),grid on
    ylabel('force [N]'),title('Right AP GRF (RHS)','FontSize',12,'FontWeight','Bold'),xlabel('gait cycle [%]')

    set(findobj(gcf,'type','axes'),'FontWeight','Bold', 'LineWidth', 2);
    sgtitle(strcat('GRF and CoP in Test',num2str(TestOrder(tst))),'FontSize',15,'FontWeight','Bold')
    
    fprintf('code paused. press space to continue...\n')
    pause

    % - - - - - - - - - - - - - - - - - - - -
    % define 1min and 10s intervals
    Cycles = size(GRF_LzCyc,1); % find # of cycles; the same across L/R
    CutOffCyc = round(Cycles_Mean * Cycles); % default 0.8 -> cycles in the last min - assumes the same # of steps per minute and takes the last min of a 5-min test, which is 80-100%
    
    % define # cycles per 10 sec (in 300 seconds test, i.e., 5 min, that is 30 segments)
    vectr = floor(LHS./1000);
    Seg10s = ones(1,Segments10s_Total);
    for p = 1 : length(Seg10s) - 1
        Seg10s(p+1) = max(find(vectr<=(p*10)));
    end
    
    % find mean values for plotting
    for y = 1 : length(Seg10s) - 1
        StepT_Left_Mean10s(y,1) = mean(StepsTimeOff_L(Seg10s(y):Seg10s(y+1))); % [%] ref
        StepT_Left_Std10s(y,1) = std(StepsTimeOff_L(Seg10s(y):Seg10s(y+1))); % [%] ref
        StepT_Right_Mean10s(y,1) = mean(StepsTimeOff_R(Seg10s(y):Seg10s(y+1))); % [%] ref
        StepT_Right_Std10s(y,1) = std(StepsTimeOff_R(Seg10s(y):Seg10s(y+1))); % [%] ref
        StrideT_Mean10s(y,1) = mean(StridesTimeOff(Seg10s(y):Seg10s(y+1))); % [%] ref
        StrideT_Std10s(y,1) = std(StridesTimeOff(Seg10s(y):Seg10s(y+1))); % [%] ref
    end
    % - - - - - - - - - - - - - - - - - - - -
    % plot stride and step time as [%] of reference
    figure()
    set(gcf,'Color','white');
    % - - - - - 
    subplot(3,2,1)
    plot(StepsTimeOff_L,'linewidth',2), grid on
    ylabel('stepT left [% ref]'),xlim([0 length(StepsTimeOff_L)])
    % - - - - - 
    subplot(3,2,2)
    plot(StepT_Left_Mean10s,'linewidth',2), grid on, hold on
    crv1 = StepT_Left_Mean10s + StepT_Left_Std10s;
    crv2 = StepT_Left_Mean10s - StepT_Left_Std10s;
    plt = fill([1:length(Seg10s)-1, fliplr(1:length(Seg10s)-1)], [crv1', fliplr(crv2')],'k','LineStyle', '--', 'EdgeColor', 'b');
    alpha(plt,0.15)
    xlim([0 30])    
    % - - - - - 
    subplot(3,2,3)
    plot(StepsTimeOff_R,'linewidth',2), grid on
    ylabel('stepT right [% ref]'),xlim([0 length(StepsTimeOff_L)])
    xlabel('steps #')
    % - - - - - 
    subplot(3,2,4)
    plot(StepT_Right_Mean10s,'linewidth',2), grid on, hold on
    crv1 = StepT_Right_Mean10s + StepT_Right_Std10s;
    crv2 = StepT_Right_Mean10s - StepT_Right_Std10s;
    plt = fill([1:length(Seg10s)-1, fliplr(1:length(Seg10s)-1)], [crv1', fliplr(crv2')],'k','LineStyle', '--', 'EdgeColor', 'b');
    alpha(plt,0.15)
    xlim([0 30])  
    % - - - - - 
    subplot(3,2,5)
    plot(StridesTimeOff,'linewidth',2), grid on
    ylabel('strideT [% ref]'),xlim([0 length(StepsTimeOff_L)])
    xlabel('strides #')
    % - - - - - 
    subplot(3,2,6)
    plot(StrideT_Mean10s,'linewidth',2), grid on, hold on
    crv1 = StrideT_Mean10s + StrideT_Std10s;
    crv2 = StrideT_Mean10s - StrideT_Std10s;
    plt = fill([1:length(Seg10s)-1, fliplr(1:length(Seg10s)-1)], [crv1', fliplr(crv2')],'k','LineStyle', '--', 'EdgeColor', 'b');
    alpha(plt,0.15)
    xlim([0 30]), xlabel('10s bouts')    
    
    set(findobj(gcf,'type','axes'),'FontWeight','Bold', 'LineWidth', 2);
    sgtitle(strcat('Step/Stride T vs metronome in Test',num2str(TestOrder(tst))),'FontSize',15,'FontWeight','Bold')
    
    % - - - - - - - - - - - - - - - - - - - -
    % print number of HS and TO points = needs to be the same, i.e. #HS = #TO points on each leg separately; right and left side do not need to match
    fprintf(strcat(char(Test(tst)),'_LHS:',num2str(size(LHS,1)),'\n'))
    fprintf(strcat(char(Test(tst)),'_LTO:',num2str(size(LTO,1)),'\n\n'))
    fprintf(strcat(char(Test(tst)),'_RHS:',num2str(size(RHS,1)),'\n'))
    fprintf(strcat(char(Test(tst)),'_RTO:',num2str(size(RTO,1)),'\n\n'))
    fprintf('test finished. code paused. press space to continue to next test...\n')
    pause

    clc
end

fprintf('kinetics analysis finished. starting kinematics.\n')
fprintf('code paused. press space to continue...\n')
pause

clc

%% display a message
fprintf(strcat('running kinematics analysis for: ',char(Subject(Subject_ID)),'-',char(Session(Session_ID)),'\n'))

%% read in and manipulate markers data

% load static calibration file
MarkerData_Static = rawMechanics.StaticCalibration.(Session{Session_ID});
CalibrationAngles = AnglesCalibration(MarkerData_Static); % contains marker position and joint angles

for tst = 1%count_start : count_end
    % go through all three bouts, 5 tests per bout
    if tst <= 5
       Bout_ID = 1;
       Condition_ID = ConditionOrder(1);
       WalkSpeed_ID = WalkSpeedOrder(1);
    elseif tst > 5 && tst <= 10
       Bout_ID = 2;
       WalkSpeed_ID = WalkSpeedOrder(2);
       Condition_ID = ConditionOrder(2);
    else
       Bout_ID = 3;
       Condition_ID = ConditionOrder(3);
       WalkSpeed_ID = WalkSpeedOrder(3);
    end

    % dynamics pose captured while walking on a treadmill
    MarkerData_Dynamic = rawMechanics.(Test{tst}).Markers;
    
    % dynamic attitude matrices
    AltitudeMatrix = AltitudeDynamic(MarkerData_Dynamic);

    % rotation
    Rotation = RotationCalculation(AltitudeMatrix, CalibrationAngles, Side_ID, Correction_ID);

    % load gait events for segmentation
    LHS = GaitIndex.(Test{tst}).LHS;
    LTO = GaitIndex.(Test{tst}).LTO;
    RHS = GaitIndex.(Test{tst}).RHS;
    RTO = GaitIndex.(Test{tst}).RTO;
    
    % find total number of cycles and define cut-off
    Cycles = size(LHS,1) - 1;
    CutOffCyc = round(Cycles_Mean * Cycles); % default 0.8 -> cycles in the last min - assumes the same # of steps per minute and takes the last min of a 5-min test, which is 80-100%

    % segment joint and pelvic angle
    AnglesCycle = anglesSegmentation(Rotation, LHS, RHS, CutOffCyc);

    % - - - - - - - - - - - - - - - - - - - -
    % plot segmented pelvic angles
    figure() 
    set(gcf,'Color','white');
    % - - - - - 
    subplot(1,3,1) 
    plot(AnglesCycle.Pelvis_Sagg'); grid on, hold on
    plot(AnglesCycle.Pelvis_Sagg_Mean,'k','linewidth',2)
    xlim([0 100]),ylabel('angle [deg]'),xlabel('gait cycle [%]')
    title('Sagital tilt','FontSize',12,'FontWeight','Bold');
    % - - - - - 
    subplot(1,3,2)
    plot(AnglesCycle.Pelvis_Front'); grid on, hold on
    plot(AnglesCycle.Pelvis_Front_Mean,'k','linewidth',2)
    xlim([0 100]),xlabel('gait cycle [%]')
    title('Lateral tilt','FontSize',12,'FontWeight','Bold');
    % - - - - - 
    subplot(1,3,3)
    plot(AnglesCycle.Pelvis_Trans'); grid on, hold on
    plot(AnglesCycle.Pelvis_Trans_Mean,'k','linewidth',2)
    xlim([0 100]),xlabel('gait cycle [%]')
    title('Rotation','FontSize',12,'FontWeight','Bold');

    set(findobj(gcf,'type','axes'),'FontWeight','Bold', 'LineWidth', 2);
    sgtitle(strcat('Pelvic angle in Test',num2str(TestOrder(tst))),'FontSize',15,'FontWeight','Bold')

    fprintf('code paused. press space to continue...\n')
    pause
    
    % - - - - - - - - - - - - - - - - - - - -
    % plot segmented joint angles
    figure() 
    set(gcf,'Color','white');
    % - - - - - 
    subplot(3,2,1)
    plot(AnglesCycle.Left_HipFlex'); grid on, hold on; 
    plot(mean(AnglesCycle.Left_HipFlex(CutOffCyc:end,:)),'k','linewidth',2);
    xlim([0 100]),ylabel('angle [deg]'),ylim([-30 40])
    title('Left Hip','FontSize',12,'FontWeight','Bold')
    % - - - - - 
    subplot(3,2,2)
    plot(AnglesCycle.Right_HipFlex'); grid on, hold on; 
    plot(mean(AnglesCycle.Right_HipFlex(CutOffCyc:end,:)),'k','linewidth',2);
    xlim([0 100]),ylim([-30 40])
    title('Right Hip','FontSize',12,'FontWeight','Bold')
    % - - - - - 
    subplot(3,2,3)
    plot(AnglesCycle.Left_KneeFlex'); grid on, hold on; 
    plot(mean(AnglesCycle.Left_KneeFlex(CutOffCyc:end,:)),'k','linewidth',2);
    xlim([0 100]),ylabel('angle [deg]'),ylim([-10 80])
    title('Left Knee','FontSize',12,'FontWeight','Bold')
    % - - - - - 
    subplot(3,2,4)
    plot(AnglesCycle.Right_KneeFlex'); grid on, hold on; 
    plot(mean(AnglesCycle.Right_KneeFlex(CutOffCyc:end,:)),'k','linewidth',2);
    xlim([0 100]),ylim([-10 80])
    title('Right Knee','FontSize',12,'FontWeight','Bold')
    % - - - - - 
    subplot(3,2,5)
    plot(AnglesCycle.Left_AnkleFlex'); grid on, hold on; 
    plot(mean(AnglesCycle.Left_AnkleFlex(CutOffCyc:end,:)),'k','linewidth',2);
    xlim([0 100]),ylabel('angle [deg]'),ylim([-40 40]),xlabel('gait cycle [%]')
    title('Left Ankle','FontSize',12,'FontWeight','Bold')
    % - - - - - 
    subplot(3,2,6)
    plot(AnglesCycle.Right_AnkleFlex'); grid on, hold on; 
    plot(mean(AnglesCycle.Right_AnkleFlex(CutOffCyc:end,:)),'k','linewidth',2);
    xlim([0 100]),ylim([-40 40]),xlabel('gait cycle [%]')
    title('Right Ankle','FontSize',12,'FontWeight','Bold')

    set(findobj(gcf,'type','axes'),'FontWeight','Bold', 'LineWidth', 2);
    sgtitle(strcat('Joint angle (Flexion) in Test',num2str(TestOrder(tst))),'FontSize',15,'FontWeight','Bold')

    %fprintf('code paused. press space to continue...\n')
    %pause
    
    fprintf('test finished. code paused. press space to continue to next test...\n')
    pause

    clc

end

fprintf('kinematics analysis finished. starting kinematics.\n')
fprintf('code paused. press space to continue...\n')
pause

clc

%% end

close all
clear
clc

 
