
% MAIN SCRIPT FOR EMG DATA ANALYSIS
% loads Subject data; plots data
% provided with the paper "Individual Gait Adaptations: A Dataset of Healthy Adults Walking With and Without Kinematic Constraints"
% Author: Bacek Tomislav, The University of Melbourne
% March 2023

%% sensor placement

% channel #         muscle                      side
% - - - - - - - - - - - - - - - - - - - - - - - - - - - 
%   1               tibialis anterior           left
%   2               gastrocnemius medialis      left
%   3               gastrocnemius lateralis     left
%   4               vastus lateralis            left
%   5               rectus femoris              left
%   6               biceps femoris              left
%   7               semitendinosus              left
%   8               gluteus maximus             left

%   9               tibialis anterior           right
%  10               gastrocnemius medialis      right
%  11               gastrocnemius lateralis     right
%  12               vastus lateralis            right
%  13               rectus femoris              right
%  14               biceps femoris              right
%  15               semitendinosus              right
%  16               gluteus maximus             right

%% initialise

clear
clc
close all

format short g

%% load data
% go to the folder where data are saved
message = ['Select folder where data are saved (in ROOT DATA/)']; 
disp(message);
datafolder = uigetdir(cd, message);
addpath(genpath(datafolder))

%% * * * * * * C H O O S E !!!!!! * * * * * * * 
% Subject and Session

% - - - - - SUBJECT ID - - - - -
Subject = {'Sub1','Sub2','Sub3','Sub4','Sub5','Sub6','Sub7','Sub8','Sub9','Sub10','Sub11','Sub12','Sub13'};
Subject_ID = input('Choose the subject (1-12):');

% - - - - - SESSION ID - - - - - - - - 
% sessions
Session = {'Session1','Session2','Session3'};
Session_ID = input('Choose the session (2 or 3):');

% - - - - - - - TESTS RANGE - - - - - - - 
% Bout1: 1-5; Bout2: 6-10; Bout3: 11-16
count_start = 1; 
count_end = 5;

% - - - - - - - MEAN DATA - - - - - - 
Cycles_Mean = 0.8; % takes (1-Cycles_Mean)*100% of data at the end of a 5-min test to calculate mean (eg 0.8 takes last 20%=1min of data)

% - - - - - - - SEGMENTS FOR DATA ANALYSIS - - - - - -
Segments10s_Total = 29; % default 30 -> in 300sec (5-min) tests, each segment is 10 sec

%% * * * * * * * * * DEFINITIONS * * * * * * * * * * *

% - - - - - BOUT ID - - - - - - - - 
Bout = {'Bout1','Bout2','Bout3'};
% Bout_ID defined later

% - - - - - - LEG SIDE - - - - - -
Side = {'Left','Right'};

% - - - - - MUSCLES - - - - - - - 
Muscles = {'TibAnt','GastroLat','GastroMed','VastLat','RecFem','BicFem','Semitend','GlutMax'};

% - - - - - - - FILTER DESIGN - - - - - - - - - -
BandPassFilt_EMG = designfilt('bandpassfir', 'StopbandFrequency1', 10,...
    'PassbandFrequency1', 15, 'PassbandFrequency2', 400,...
    'StopbandFrequency2', 500, 'StopbandAttenuation1',...
    80, 'PassbandRipple', 1, 'StopbandAttenuation2', 80, 'SampleRate',...
    2000);

% raw data frequency
RawDataFreq = 2000; % [Hz]

% define muscle # per leg
MuscleNum = 8;

% search window for RMS calculation
RMSwindow = 200; % due to 2kHz sampling, this corresponds to 250ms window

%% load subject-specific data

fprintf('loading data...')
load(strcat(char(Subject(Subject_ID)),'_rawEnergetics.mat'));
load(strcat(char(Subject(Subject_ID)),'_segEnergetics.mat'));
load(strcat(char(Subject(Subject_ID)),'_segMechanics.mat'));
fprintf('done! \n')

load('Subjects_Info.mat');
TestOrder = SubjectInfo.(Subject{Subject_ID}).(Session{Session_ID}).TestOrder;
Mass = SubjectInfo.(Subject{Subject_ID}).(Session{Session_ID}).Mass;

% - - - - - - - TESTS - - - - - - - - -
TestNmbr = length(TestOrder); % tests number [in total 30 5-min tests, 6 25-min trials]
Test = cell(TestNmbr,1);
for t = 1 : TestNmbr
    Test(t) = {strcat('T',num2str(TestOrder(t)))};
end

%% display a message
fprintf(strcat('running emg analysis for: ',char(Subject(Subject_ID)),'-',char(Session(Session_ID)),'\n'))

for tst = count_start : count_end
    % go through all three bouts, 5 tests per bout
    if tst <= 5
        Bout_ID = 1;
    elseif tst > 5 && tst <= 10
        Bout_ID = 2;
    else
        Bout_ID = 3;
    end
    
    % create new variable
    for s = 1 : 2 % 2 sides
        for m = 1 : 8 % 8 muscles
            EMG_Raw.(strcat(Side{s},'_',Muscles{m})) = rawEnergetics.(Test{tst}).EMG.(strcat(Side{s},'_',Muscles{m})); 
        end
    end
    
    % filter, rectify (abs), find RMS for each muscle
    xaxis = 1:1:size(EMG_Raw.Left_TibAnt,1);
    for s = 1 : 2 % left and right side
        figure(),set(gcf,'color','w')
        for m = 1 : 8
            % filtering
            Filtered = filtfilt(BandPassFilt_EMG,EMG_Raw.(strcat(Side{s},'_',Muscles{m})));
            % rectifying
            Rectified = abs(Filtered);
            % calculate RMS
            for rmw = (1 + RMSwindow/2) : (length(Rectified) - RMSwindow/2)
                RMSsignal(rmw - RMSwindow/2) = rms(Rectified((rmw - RMSwindow/2):(rmw + RMSwindow/2)));
            end
            
            EMGdata.RMS.(Test{tst}).(strcat(Side{s},'_',Muscles{m})) = downsample(RMSsignal',2); % from 2kHz to 1kHz (gait indices)
            % calculate relative activation with respect to baseline
            NormFact = segEnergetics.NormFactors.(Session{Session_ID}).(strcat(Side{s},'_',Muscles{m}));
            EMGdata.Normalised.(Test{tst}).(strcat(Side{s},'_',Muscles{m})) = EMGdata.RMS.(Test{tst}).(strcat(Side{s},'_',Muscles{m})) / NormFact;
            
            % plot
            subplot(2,4,m)
            figr = plot(xaxis,EMG_Raw.(strcat(Side{s},'_',Muscles{m})),'k'); figr.Color(4) = 0.08; hold on
            figr1 = plot(xaxis,Filtered,'b'); figr1.Color(4) = 0.08;
            hold on, grid on
            plot(1:1:length(RMSsignal),RMSsignal,'r','LineWidth',2)
            legend('raw','filt','RMS'), title(Muscles{m},'FontSize',13,'FontWeight','Bold')
        end
        set(findobj(gcf,'type','axes'),'FontWeight','Bold', 'LineWidth', 2);
        sgtitle(strcat('Muscle activity in Test',num2str(TestOrder(tst)),':',Side{s}),'FontSize',16,'FontWeight','Bold')
    end
    clear xaxis
    
    % - -- - - - - - - - - - - - -
    % segmentation of EMG data into cycles
    LHS = segMechanics.(Test{tst}).GaitIndex.LHS_1kHz;
    RHS = segMechanics.(Test{tst}).GaitIndex.RHS_1kHz;
    
    % define cycles
    Cycles = length(LHS);
    CutOffCyc = round(0.8 * Cycles);

    % - - - - - - - - - - -
    % call function that does the segmentation
    EMGdata = EMG_GaitCycle(LHS,RHS,EMGdata,Test,tst,Side,Muscles);

    % save mean and std values
    for s = 1 : 2
        for m = 1 : 8
            EMGdata.Cycles.(Test{tst}).(strcat(Side{s},'_',Muscles{m},'_Mean')) = mean(EMGdata.Cycles.(Test{tst}).(strcat(Side{s},'_',Muscles{m}))(CutOffCyc:end,:));
            EMGdata.Cycles.(Test{tst}).(strcat(Side{s},'_',Muscles{m},'_Std')) = std(EMGdata.Cycles.(Test{tst}).(strcat(Side{s},'_',Muscles{m}))(CutOffCyc:end,:));
        end
    end
    
    % plot EMG data per cycle
    figure()
    set(gcf,'color','w')
    for s = 1 : 2
        for m = 1 : 8
            subplot(4,4,(s-1)*8+m)
            %plot(Temp_EMG.Cycles.(Test{tst}).(strcat(Side{s},Muscles{m}))'), hold on, grid on
            plot(EMGdata.Cycles.(Test{tst}).(strcat(Side{s},'_',Muscles{m},'_Mean')),'k','linewidth',3)
            hold on, grid on
            stdUp = EMGdata.Cycles.(Test{tst}).(strcat(Side{s},'_',Muscles{m},'_Mean')) + EMGdata.Cycles.(Test{tst}).(strcat(Side{s},'_',Muscles{m},'_Std')); % mean + std
            stdDown = EMGdata.Cycles.(Test{tst}).(strcat(Side{s},'_',Muscles{m},'_Mean')) - EMGdata.Cycles.(Test{tst}).(strcat(Side{s},'_',Muscles{m},'_Std')); % mean - std
            StanDev = fill([1:1001, fliplr(1:1001)], [stdUp, fliplr(stdDown)],'b','LineStyle', '--', 'EdgeColor', 'b');
            hold off; alpha(StanDev,0.15)
            title(strcat(Side{s},Muscles{m}))
        end
    end
    set(findobj(gcf,'type','axes'),'FontWeight','Bold', 'LineWidth', 2);
    sgtitle(strcat('EMG in Test',num2str(TestOrder(tst))),'FontSize',15,'FontWeight','Bold')
    
    fprintf('test finished. code paused. press space to continue to next test...\n')
    pause

end

% plot a single figure for 5 test per bout, all 16 muscles
thisBout = sort(TestOrder(count_start:count_end));
figure, set(gcf,'color','w')
for tst = count_start : count_end
    for s = 1 : 2
        for m = 1 : 8
            subplot(4,4,(s-1)*8+m)
            plot(EMGdata.Cycles.(Test{tst}).(strcat(Side{s},'_',Muscles{m},'_Mean')), 'linewidth',2)
            hold on, grid on
        end
    end
end
for i = 1 : 4
    subplot(4,4,12+i),xlabel('gait [%]')
    subplot(4,4,(i-1)*4+1), ylabel('activity [% max]')
end
for s = 1 : 2
    for m = 1 : 8
        subplot(4,4,(s-1)*8+m)
        title(strcat(Side{s},Muscles{m}))
    end
end
subplot(4,4,4),legend(char(Test(count_start)),char(Test(count_start+1)),char(Test(count_start+2)),char(Test(count_start+3)),char(Test(count_start+4)))
set(findobj(gcf,'type','axes'),'FontWeight','Bold', 'LineWidth', 2);
sgtitle(strcat('EMG across 5 tests in:',char(Bout(Bout_ID)),'-(Tests:T',num2str(thisBout(1)),'-',num2str(thisBout(end)),')'),'FontSize',15,'FontWeight','Bold')
    
pause 

%% end

close all
clear
clc
