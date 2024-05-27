# Welcome to the Human "Walking Dataset MelbUni 2023" data repository!

This repository includes custom Matlab (.m) scripts that can be used to run basic calculations, visualisation, and data analysis using human walking data
available from an [open access data repository](https://doi.org/10.26188/c.6887854.v1). More details on how data were collected, what data are available,
and structure of the provided dataset can be found in the corresponding [data descriptor paper](https://www.nature.com/articles/...). 

[*paper excerpt*] 
>This paper presents an open dataset of human walking biomechanics and energetics, collected from 21 neurotypical young adults. To investigate the effects of internal constraints (i.e., reduced joint range of motion), the participants are both the control (free walking) and the intervention (constrained walking) group. Each subject walked on a dual-belt treadmill at three speeds (0.4, 0.8. and 1.1 m/s) and five step frequencies (between -10% and 20% of their preferred frequency) for a total of 30 test conditions and at their preferred walking speed. The dataset includes raw (.mat, .c3d, and .csv) and segmented (.mat) data, featuring ground reaction forces, joint motion data, muscle activity, and metabolic data. Additionally, a sample code is provided for basic data manipulation and visualisation.

Data are provided on two different levels -- raw and segmented, and in three different formats: .c3d, .csv, and .mat. The organisation is as follows:
1. RAW: raw data comes in .c3d, .csv, and .mat formats. C3D format contains ground reaction forces, joint motion, and muscle activity data all saved in one file per test per subject. MAT format contains two files per subject, one featuring ground reaction forces and joint motion data (called 'rawMechanics') and another one muscle activity data (called 'rawEnergetics'). Each of the two files contains data from all the tests separated by the test name. Note: raw data are filtered using common approaches found in the literature, with more details available in the data descriptor paper.
2. SEGMENTED: segmented data comes in .mat format only. Similar to the raw MAT file, segmented data also comes in two files per subject, one containing ground reaction forces and joint motion data (called 'segMechanics') and another one muscle activity and metabolic cost data (called 'segEnergetics'). Note: data are segmented using vertical ground reaction force, with one cycle starting and ending with two subsequent left heel strikes.

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
