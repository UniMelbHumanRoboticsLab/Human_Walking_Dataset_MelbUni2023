# Welcome to the Human "Walking Dataset MelbUni 2023" data repository!

This repository includes custom Matlab (.m) scripts that can be used to run basic calculations, visualisation, and data analysis using human walking data
available from an [open access data repository](https://springernature.figshare.com/...). More details on how data were collected, what data are available,
and structure of the provided dataset can be found in the corresponding [data descriptor paper](https://www.nature.com/articles/...). 

[*paper excerpt*] 
>This paper presents an open dataset of human walking biomechanics and energetics, collected from 12 healthy young adults. To investigate the effects of internal constraints (i.e., reduced joint range of motion), the participants are both the control (free walking) and the intervention (constrained walking) group. Each subject walked on a dual-belt treadmill at three speeds (0.4–1.1 m/s) and five step frequencies (between -10% and 20% of their preferred frequency) for a total of 30 test conditions. The dataset includes raw (.mat, .c3d) and segmented (.mat) data, featuring ground reaction forces, joint motion data, muscle activity, and metabolic data. Additionally, a sample code is provided for basic data manipulation and visualisation.

Data are provided on two different levels -- raw and segmented, and in two different formats: .c3d and .mat. The organisation is as follows:
1. RAW: raw data comes in both .c3d and .mat formats. C3D format contains ground reaction forces, joint motion, and muscle activity data all saved in one file per test per subject. MAT format contains two files per subject, one featuring ground reaction forces and joint motion data (called 'rawMechanics') and another one muscle activity data (called 'rawEnergetics'). Each of the two files contains data from all the tests separated by the test name. Note: raw data are filtered using common approaches found in the literature, with more details available in the data descriptor paper.
2. SEGMENTED: segmented data comes in .mat format only. Similar to the raw MAT file, segmented data also comes in two files per subject, one containing ground reaction forces and joint motion data (called 'segMechanics') and another one muscle activity and metabolic cost data (called 'segEnergetics'). Note: data are segmented using vertical ground reaction force, with one cycle starting and ending with two subsequent left heel strikes.

Data are accompanied by several Matlab (.m) functions that run basic data analysis and visualisation. The analysis of different data types is separated into different functions, resulting in three main functions: MAIN_KineticsKinematics, MAIN_Emg, and MAIN_MetabolicCost. Running either will load the relevant data and produce plots that visualise, e.g., ground reaction force, joint angles, and metabolic cost across the tests. 

## Test nomenclature ##

Each subject walked on a treadmill during 30 tests 5 minutes in length and differing in three factors: walking speed (three levels), step frequency (five levels), and constraints (two levels). The tests were equally split between two sessions (days) in a way to avoid multiple occurrences of the speed or consecutive occurrences of the impairment factor within a single session. The table below gives an overview of the tests. 

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

