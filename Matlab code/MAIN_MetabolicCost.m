% MAIN SCRIPT FOR METABOLIC COST ANALYSIS
% loads and plots data
% provided with the paper "Individual Gait Adaptations: A Dataset of Healthy Adults Walking With and Without Kinematic Constraints"
% Author: Bacek Tomislav, The University of Melbourne
% March 2023

clear
clc
close all

format short g

%% load data
% go to the folder where data are saved
message = ['Select folder where data are saved (in ROOT DATA/SEGMENTED/)']; 
disp(message);
datafolder = uigetdir(cd, message);
addpath(genpath(datafolder))

%% define subjects and load their data
Subjects = cell(12,1);
for s = 1 : 12
   Subjects(s) = {strcat('Sub',num2str(s))}; 
end

% subjects with metabolic data in both sessions
subjects_both = [1 2 3 4 5 6 8 9 10 11];
% subjects with metabolic data in one session
subjects_one = [7 12];

%% define tests and sessions
% 5-min tests
Test = cell(30,1);
for t = 1 : 30
    Test(t) = {strcat('T',num2str(t))};
end

%% load metabolic data
% subjects with data from both sessions
for i = subjects_both
    fprintf(strcat('loading and saving Sub',num2str(i),'...'));
    load(strcat(char(Subjects(i)),'_segEnergetics.mat'));
    % - - - - - - - 
    % resting: 2x5; rows are sessions, columns are 5 measurements
    MC.(Subjects{i}).Resting = [segEnergetics.MetabolicResting.Session2'; segEnergetics.MetabolicResting.Session3'];
    % - - - - - - -
    % preferred: 1x2, corresponding to start and end, average over 2 sessions
    tempStart2 = round(0.8*length(segEnergetics.Pref_Start.Session2.Metabolic.MetCost)); % take last 20% of data, roughly 1 min
    tempStart3 = round(0.8*length(segEnergetics.Pref_Start.Session3.Metabolic.MetCost));
    tempEnd2 = round(0.8*length(segEnergetics.Pref_End.Session2.Metabolic.MetCost));
    tempEnd3 = round(0.8*length(segEnergetics.Pref_End.Session3.Metabolic.MetCost));
    startMean = mean([segEnergetics.Pref_Start.Session2.Metabolic.MetCost(tempStart2:end); segEnergetics.Pref_Start.Session3.Metabolic.MetCost(tempStart3:end)]);
    endMean = mean([segEnergetics.Pref_End.Session2.Metabolic.MetCost(tempEnd2:end); segEnergetics.Pref_End.Session3.Metabolic.MetCost(tempEnd3:end)]); 
    MC.(Subjects{i}).Preferred.MC = [startMean endMean];
    startMean = mean([segEnergetics.Pref_Start.Session2.Metabolic.CostTrans(tempStart2:end); segEnergetics.Pref_Start.Session3.Metabolic.CostTrans(tempStart3:end)]);
    endMean = mean([segEnergetics.Pref_End.Session2.Metabolic.CostTrans(tempEnd2:end); segEnergetics.Pref_End.Session3.Metabolic.CostTrans(tempEnd3:end)]); 
    MC.(Subjects{i}).Preferred.CoT = [startMean endMean];
    % - - - - - - -
    % tests: 30x1; rows correspond to tests T1-T30
    MC.(Subjects{i}).Tests.MC = zeros(30,1);
    MC.(Subjects{i}).Tests.CoT = zeros(30,1);
    for tst = 1 : 30
       temp = round(0.8*length(segEnergetics.(Test{tst}).Metabolic.MetCost));
       MC.(Subjects{i}).Tests.MC(tst,1) = mean(segEnergetics.(Test{tst}).Metabolic.MetCost(temp:end));
       MC.(Subjects{i}).Tests.CoT(tst,1) = mean(segEnergetics.(Test{tst}).Metabolic.CostTrans(temp:end));
    end
    fprintf('done! \n')
end
% subjects with data from a single session
for j = subjects_one
    fprintf(strcat('loading and saving Sub',num2str(i),'...'));
    load(strcat(char(Subjects(i)),'_segEnergetics.mat'));
    % - - - - - - - 
    % resting: 1x5; columns are 5 measurements
    MC.(Subjects{i}).Resting = segEnergetics.MetabolicResting.Session2';
    % - - - - - - -
    % preferred: 1x2, corresponding to start and end, average over 2 sessions
    tempStart2 = round(0.8*length(segEnergetics.Pref_Start.Session2.Metabolic.MetCost)); % take last 20% of data, roughly 1 min
    tempEnd2 = round(0.8*length(segEnergetics.Pref_End.Session2.Metabolic.MetCost));
    startMean = mean(segEnergetics.Pref_Start.Session2.Metabolic.MetCost(tempStart2:end));
    endMean = mean(segEnergetics.Pref_End.Session2.Metabolic.MetCost(tempEnd2:end)); 
    MC.(Subjects{i}).Preferred.MC = [startMean endMean];
    startMean = mean(segEnergetics.Pref_Start.Session2.Metabolic.CostTrans(tempStart2:end));
    endMean = mean(segEnergetics.Pref_End.Session2.Metabolic.CostTrans(tempEnd2:end)); 
    MC.(Subjects{i}).Preferred.CoT = [startMean endMean];
    % - - - - - - -
    % tests: 30x1; rows correspond to tests T1-T30
    MC.(Subjects{i}).Tests.MC = zeros(30,1);
    MC.(Subjects{i}).Tests.CoT = zeros(30,1);
    if j == 1
        for tst = 1 : 15 % tests available
            temp = round(0.8*length(segEnergetics.(Test{tst}).Metabolic.MetCost));
            MC.(Subjects{i}).Tests.MC(tst,1) = mean(segEnergetics.(Test{tst}).Metabolic.MetCost(temp:end));
            MC.(Subjects{i}).Tests.CoT(tst,1) = mean(segEnergetics.(Test{tst}).Metabolic.CostTrans(temp:end));
        end
    else
        for tst = [11 12 13 14 15 21 22 23 24 25] % tests available
            temp = round(0.8*length(segEnergetics.(Test{tst}).Metabolic.MetCost));
            MC.(Subjects{i}).Tests.MC(tst,1) = mean(segEnergetics.(Test{tst}).Metabolic.MetCost(temp:end));
            MC.(Subjects{i}).Tests.CoT(tst,1) = mean(segEnergetics.(Test{tst}).Metabolic.CostTrans(temp:end));
        end
    end
    fprintf('done! \n')
end

%% define plot labels

% rest (per session)
Rest = cell(5,1);
for r = 1 : 5
   Rest(r) = {strcat('Rest',num2str(r))}; 
end

% define labels for plots
lblRest = categorical(Rest);
lblTest = categorical({'PrefS',Test{1:30},'PrefE'});
lblTest = reordercats(lblTest,{'PrefS',Test{1:30},'PrefE'});

%% plot data per person
% each subject has two subplots for resting MC
% and one for all 30 tests + preferred walking (average from 2 sessions)

for sub = 1 : 12
   limRest = max(max(MC.(Subjects{sub}).Resting)) + 0.5;
   figure(), set(gcf,'color','w')
   % - - - - - - - 
   subplot(3,2,1)
   barRest2 = MC.(Subjects{sub}).Resting(1,:);
   bar(lblRest,barRest2),ylim([0 limRest]), grid on
   ylabel('cost [W/kg]'), title(strcat('Resting MC Sess2 Sub',num2str(sub)))
   % - - - - - - - 
   subplot(3,2,2)
   barRest3 = MC.(Subjects{sub}).Resting(2,:);
   bar(lblRest,barRest3),ylim([0 limRest]), grid on
   title(strcat('Resting MC Sess2 Sub',num2str(sub)))   
   % - - - - - - - 
   subplot(3,2,[3 4])
   barMC = [MC.(Subjects{sub}).Preferred.MC(1) MC.(Subjects{sub}).Tests.MC' MC.(Subjects{sub}).Preferred.MC(2)];
   b = bar(lblTest,barMC,'FaceColor','flat'); hold on
   prf = [1 32]; tst1 = [2:6 17:21]; tst2 = [7:11 22:26]; tst3 = [12:16 27:31];
   for c = 1 : 2
       b.CData(prf(c),:) = [0 1 0];
   end
   for c = 1 : 10
       b.CData(tst1(c),:) = [0.6 0.6 1];
       b.CData(tst2(c),:) = [0.1 0.1 1];
       b.CData(tst3(c),:) = [0.4 0.4 1];
   end
   grid on, ylim([0 max(barMC)+0.5])
   ylabel('cost [W/kg]'), title(strcat('Tests MC Sess2 Sub',num2str(sub)))
   % - - - - - - - 
   subplot(3,2,[5 6])
   barCoT = [MC.(Subjects{sub}).Preferred.CoT(1) MC.(Subjects{sub}).Tests.CoT' MC.(Subjects{sub}).Preferred.CoT(2)];
   b = bar(lblTest,barCoT,'FaceColor','flat'); hold on
   for c = 1 : 2
       b.CData(prf(c),:) = [0 1 0];
   end
   for c = 1 : 10
       b.CData(tst1(c),:) = [0.6 0.6 1];
       b.CData(tst2(c),:) = [0.1 0.1 1];
       b.CData(tst3(c),:) = [0.4 0.4 1];
   end
   grid on, ylim([0 max(barCoT)+0.5])
   ylabel('cost [J/kgm]'), title(strcat('Tests CoT Sess2 Sub',num2str(sub)))

   set(findobj(gcf,'type','axes'),'FontWeight','Bold', 'LineWidth', 2);
end
