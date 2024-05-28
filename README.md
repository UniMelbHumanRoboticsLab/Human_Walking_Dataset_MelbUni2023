# Welcome to the Human "Walking Dataset MelbUni 2023" data repository!

This repository includes custom Matlab (.m) scripts that can be used to run basic calculations, visualisation, and data analysis using human walking data
available from an [open access data repository](https://doi.org/10.26188/c.6887854.v1). More details on how data were collected, what data are available,
and structure of the provided dataset can be found in the corresponding [data descriptor paper](https://www.nature.com/articles/...). 

[*paper excerpt*] 
>This paper presents an open dataset of human walking biomechanics and energetics, collected from 21 neurotypical young adults. To investigate the effects of internal constraints (i.e., reduced joint range of motion), the participants are both the control (free walking) and the intervention (constrained walking) group. Each subject walked on a dual-belt treadmill at three speeds (0.4, 0.8. and 1.1 m/s) and five step frequencies (between -10% and 20% of their preferred frequency) for a total of 30 test conditions and at their preferred walking speed. The dataset includes raw (.mat, .c3d, and .csv) and segmented (.mat) data, featuring ground reaction forces, joint motion data, muscle activity, and metabolic data. Additionally, a sample code is provided for basic data manipulation and visualisation.

Data are provided on two different levels -- raw and segmented, and in three different formats: .c3d, .csv, and .mat. The organisation is as follows:
1. RAW: raw data comes in .c3d, .csv, and .mat formats. C3D format is saved as, e.g., 'RAW_c3d_Sub5.zip' and contains ground reaction forces, joint motion, and muscle activity data all saved in one file per test per subject. MAT format is saved as, e.g., 'RAW_mat_Sub17.zip' and contains two files per subject, one featuring ground reaction forces and joint motion data (called 'rawMechanics') and another one muscle activity data (called 'rawEnergetics'). Each of the two files contains data from all the tests separated by the test name. Note: raw data are filtered using common approaches found in the literature, with more details available in the data descriptor paper. CSV format is saved as, e.g., 'RAW_csv_Sub20.zip' and contains four folders, corresponding to kinetics, kinematics, metabolic cost, and muscle activation data. 
2. SEGMENTED: segmented data comes in .mat format only. Similar to the raw MAT file, segmented data is saved as, e.g., 'SEGMENTED_mat_Sub6.zip' and comes in two files per subject, one containing ground reaction forces and joint motion data (called 'segMechanics') and another one muscle activity and metabolic cost data (called 'segEnergetics'). Note: data are segmented using vertical ground reaction force, with one cycle starting and ending with two subsequent left heel strikes (i.e., the provided data give a snapshot in time - a stride, allowing direct comparisons between the legs within a single stride).

Data are accompanied by several Matlab (.m) functions that run basic data analysis and visualisation. The analysis of different data types is separated into different functions, resulting in three main functions: MAIN_KineticsKinematics, MAIN_Emg, and MAIN_MetabolicCost. Running either will load the relevant data and produce plots that visualise, e.g., ground reaction force, joint angles, and metabolic cost across the tests. 

## Test nomenclature ##

Each subject walked on a treadmill during 30 tests 5 minutes in length and differing in three factors: walking speed (three levels), step frequency (five levels), and constraints (two levels). The tests were equally split between two sessions (days) in a way to avoid multiple occurrences of the speed or consecutive occurrences of the impairment factor within a single session. The table below gives an overview of the tests. The 15 tests per session are grouped into three bouts of five tests, with each bout having a fixed walking speed and sweeping through five step frequencies.

| Test | Walking speed | Constraint  | Cadence (% preferred) |
| ---- | ------------- | ----------- | --------------------- |
|  T1  |    1.1m/s     | NO orthosis |        -10%           |
|  T2  |    1.1m/s     | NO orthosis |        -5%            |
|  T3  |    1.1m/s     | NO orthosis |     preferred         |
|  T4  |    1.1m/s     | NO orthosis |        +10%           |
|  T5  |    1.1m/s     | NO orthosis |        +20%           |
|  --  |      --       |     --      |         --            |
|  T6  |    0.8m/s     | NO orthosis |        -10%           |
|  T7  |    0.8m/s     | NO orthosis |        -5%            |
|  T8  |    0.8m/s     | NO orthosis |     preferred         |
|  T9  |    0.8m/s     | NO orthosis |        +10%           |
|  T10 |    0.8m/s     | NO orthosis |        +20%           |
|  --  |      --       |     --      |         --            |
|  T11 |    0.4m/s     | NO orthosis |        -10%           |
|  T12 |    0.4m/s     | NO orthosis |        -5%            |
|  T13 |    0.4m/s     | NO orthosis |     preferred         |
|  T14 |    0.4m/s     | NO orthosis |        +10%           |
|  T15 |    0.4m/s     | NO orthosis |        +20%           |
|  --  |      --       |     --      |         --            |
|  T16 |    1.1m/s     |  orthosis   |        -10%           |
|  T17 |    1.1m/s     |  orthosis   |        -5%            |
|  T18 |    1.1m/s     |  orthosis   |     preferred         |
|  T19 |    1.1m/s     |  orthosis   |        +10%           |
|  T20 |    1.1m/s     |  orthosis   |        +20%           |
|  --  |      --       |     --      |         --            |
|  T21 |    0.8m/s     |  orthosis   |        -10%           |
|  T22 |    0.8m/s     |  orthosis   |        -5%            |
|  T23 |    0.8m/s     |  orthosis   |     preferred         |
|  T24 |    0.8m/s     |  orthosis   |        +10%           |
|  T25 |    0.8m/s     |  orthosis   |        +20%           |
|  --  |      --       |     --      |         --            |
|  T26 |    0.4m/s     |  orthosis   |        -10%           |
|  T27 |    0.4m/s     |  orthosis   |        -5%            |
|  T28 |    0.4m/s     |  orthosis   |     preferred         |
|  T29 |    0.4m/s     |  orthosis   |        +10%           |
|  T30 |    0.4m/s     |  orthosis   |        +20%           |

## Subject info ##
A file called 'Subject_Info.mat' is provided in the 'Root Data" folder in the open data repository, containing the relevant info for each subject. These data are loaded in the preamble of all MAIN Matlab functions and are used in the code to load the relevant experimental data and run relevant calculations. Table below shows all data fields available for each subject per session.

| Data field | Meaning | Example |
| ---------- | ------- | ------- |
| TestOrder  | 15 tests as they took place during the experiment | 1 3 2 4 5 23 22 25 21 24 15 13 11 14 12|
| ConditionOrder | 3 bouts as they took place during the experiment; 1=no orthosis, 2=orthosis | 2 1 2 |
| WalkSpeedOrder| 3 speeds as followed during the experiment; v1=0.4 m/s, v2=0.8 m/s, v3=1.1 m/s | 2 3 1 |
| PrefSpeed | preferred walking speed determined during Session1 using the staircase method | na |
| PrefCadence | preferred cadence at all three speeds, with and without orthosis; top row no orthosis, bottom row with orthosis; speed from v1 to v3 | 58 86 104; 62 86 100 |
| CadenceRef | reference step frequency as played by the metronome; corresponding in order to TestOrder | 86 77 103 82 95 64 52... |
| LowerLimbMarkers | number of markers on the pelvis and lower limbs | 26 |
| UpperLimbMarkers | number of markers on the torso and arms | 11 |
| Mass | subject's mass in kg | 75 |
| MC_RestAvailable | the availability of metabolic cost measurement in resting; 5 in total; 1=available, 0=unavailable | 1 1 1 0 1 |
| MC_PrefAvailable | the availability of metabolic cost measurement during preferred walking at the start and end of a session | 1 0 |
| MC_BoutAvailable | the availability of metabolic cost measurement during the three bouts | 1 1 1 |

An overview of subjects and their details can be found below.

| Sub ID | Age (years) | Height (m) | Weight (kg) | BMI (kg/m2) | Sex (M/F) | Pref. walk speed (m/s) | Treadmill experience | Physical activity |
| --- | ----------- | ---------- | ----------- | ----------- | --------- | ---------------------- | -------------------- | ----------------- |
| S1 | 35 | 1.72 | 74 | 25.0 | M | 0.87 | 104 | 1.12 | Single-belt | Walking |
| S2 | 33 | 1.74 | 70 | 23.1 | M | 1.00 | Dual-belt | Gym |
| S3 | 33 | 1.86 | 86 | 24.9 | M | 1.40 | Dual-belt | Various |
| S4 | 25 | 1.75 | 76 | 24.8 | M | 1.00 | Dual-belt | Various |
| S5 | 32 | 1.68 | 51 | 18.1 | M | 1.05 | Single-belt | Tennis |
| S6 | 43 | 1.73 | 80 | 26.7 | F | 1.21 | Single-belt | Walking |
| S9 | 23 | 1.60 | 65 | 25.4 | M | 1.15 | Single-belt | None |
| S10 | 22 | 1.88 | 77 | 21.8 | M | 1.05 | Single-belt | Walking |
| S11 | 24 | 1.75 | 90 | 29.4 | M | 1.20 | Single-belt | Gym |
| S12 | 26 | 1.74 | 82 | 26.9 | M | 1.10 | Single-belt | None |
| S13 | 29 | 1.73 | 82 | 27.4 | M | 0.96 | Single-belt | Runner |
| S14 | 30 | 1.72 | 79 | 26.7 | M | 0.94 | Single-belt | Walking |
| S15 | 27 | 1.55 | 50 | 20.8 | F | 0.98 | Single-belt | Gym |
| S16 | 28 | 1.55 | 51 | 21.2 | F | 1.23 | Single-belt | Gym |
| S17 | 29 | 1.65 | 72 | 26.4 | F | 1.10 | Single-belt | Gym |
| S18 | 25 | 1.80 | 80 | 24.7 | M | 1.25 | Single-belt | Gym/Run |
| S19 | 57 | 1.56 | 59 | 24.2 | F | 1.03 | Single-belt | Walking |
| S20 | 29 | 1.74 | 66 | 21.8 | M | 1.10 | Single-belt | Jogging |
| S21 | 26 | 1.85 | 88 | 25.7 | M | 1.01 | Single-belt | Martial arts |

## Matlab files ##

There are a total of 18 Matlab functions provided with this dataset. A table below gives a short description of each.

| Function name | Description |
| ------------- | ----------- |
| MAIN_KineticsKinematics.m | loads data, sets relevant variables, runs kinetics and kinematics analysis, and plots data |
| MAIN_Emg.m | loads data, processes it, and plots raw, filtered, and segmented data|
| MAIN_MetabolicCost.m | loads data and plots metabolic cost data, including resting, preferred walking, and all 30 tests|
| AltitudeDynamic | calculates dynamic attitude matrices used in joint calculations |
| AnglesCalibration.m | calculates static calibration angles used to offset errors (optional) |
| anglesSegmentation.m | segments joint angles into normalized gait cycles (1-100%) and finds mean trajectories |
| correctFalsePositives.m | finds false positives based on average step time |
| correctMissingSteps.m | finds if there are missing steps, and corrects it based on average step time |
| correctWrongTO.m | corrects toe-off events that are wrongly detected |
| EMG_GaitCycle.m | segments muscle activation into normalised gait cycles (1-100%)|
| GaitCycleDetection.m | finds heel-strike and toe-off events on both legs |  
| GRFsegmentation.m | segments ground reaction force and centre of pressure data into normalised gait cycle (1-100%) |
| RotationCalculation.m | calculates rotations from dynamic attitude matrices for joint calculation |
| ScaleTime.m | lineaer interpolation used to normalise gait cycle |

## Usage notes (Matlab) ##
### MAIN_KineticsKinematics.m ###
The main function for the analysis is "MAIN_KineticsKinematics.m" function. Ensure SubjectInfo.mat is in the same folder as this and other functions, and SubX_rawMechanics.mat available as you will be asked to locate the folder where the data are saved.

The function will prompt you about the subject you want to analyse and the corresponding data collection session (Session2 or Session3) you wish to focus on. 

You can choose whether you want to correct for the static calibration angle offset (and if so, which leg), as well as which Bout (of the three) in a chosen session to analyse, the cut-off ground reaction force value used in gait segmentation, as well as filter parameters used in filtering force data.

The main function is calling all other functions as needed, and you do not need to change anything there.

The function will plot 5 figures per test:
- vertical Ground Reaction Force (vGRF) over time with heel-strike and toe-off indices, as well as segmented vGRF across both legs, separately
- vertical, lateral-medial, and anterior-posterior GRF, as well as the corresponding centre of pressure (CoP) data on both legs segmented starting with Left heel-strike (individual trajectories and the mean), as well as vertical and anterior-posterior GRF on the Right leg starting with Right heel-strike
- step time on both legs and stride time over the entire test (5 min), as well as how accurately the person followed the metronome (no each leg, and across the stride)
- pelvic angles (individual trajectories and mean) in three planes
- joint angles (hip, knee, ankle) in the sagittal plane on both legs (individual trajectories and mean)


Note that the main function manipulates the data as follows:
- it finds and corrects false positives and missing steps
- it ensures the analysis always starts with the Left heel strike
- it ensures the number of Left and Right steps match

This is done for repeatable, clean, and simple analysis.

### MAIN_MetabolicCost.m ###
The main function for the analysis is "MAIN_MetabolicCost.m" function. Ensure SubX_segEnergetics.mat files are available as you will be asked to locate the folder where the data are saved.

The function loads data of all subjects with recordings from both sessions (i.e., excluding Sub7 and Sub12) and plots one figure per subject. The plot includes resting metabolic cost (5 values) for both sessions, as well as 30 tests (T1-T30) and Preferred Walking at the start and end of each session, averaged across the sessions. Both net metabolic cost (W/kg) and cost of transport (J/mkg) are plotted.

### MAIN_Emg.m ###
The main function for the analysis is "MAIN_Emg.m" function. Ensure SubjectInfo.mat is in the same folder as this and other functions, and SubX_rawEnergetics.mat, SubX_segMechanics.mat and SubX_segEnergetics.mat available as you will be asked to locate the folder where the data are saved.

The function will prompt you about the subject you want to analyse and the corresponding data collection session (Session2 or Session3) you wish to focus on. 

You can change filter design and the moving window width used in RMC calculations.

The function will plot 3 figures per test:
- raw, filtered, and RMS data of all 8 muscles across the entire test, for Left and Right legs (2 figures)
- segmented (per gait cycle) mean and standard deviation of the last minute for each of the 16 muscles

In addition, it will also plot a figure with segmented mean values of all 16 muscles across one Bout (i.e., 5 selected tests) for direct comparison.

## The rest ##
Data from Belt1 corresponds to the Left leg. Data from Belt2 corresponds to the Right leg.

Ground Reaction Force data are collected at 1 kHz (for exceptions see Supplementary File provided with the manuscript); muscle activity data at 2 kHz; marker data at 100 Hz.

