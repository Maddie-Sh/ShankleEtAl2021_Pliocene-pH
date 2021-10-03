% EXTENDED DATA 9c: WEP SSTs: from T. sacculifer (Wara et al., 2005) & this
% study's O. universa Mg/Ca data, using different Mg/Ca_sw records
% Madison Shankle
% 03-10-2021

% Plots WEP (western equtorial Pacific) SSTs derived from the Mg/Ca data of 
% this study, as well as that of Wara et al. (2005) (T. sacculifer), using 
% the Mg/Ca_sw records of Fantle & DePaolo (2006) and the BAYMAG 
% calibration (Tierney et al., 2019).

% References:
% Wara, M. W., Ravelo, A. C. & Delaney, M. L. Permanent El Niño-like 
%   conditions during the Pliocene warm period. Science 309, 758–761 (2005).
% Fantle, M. S. & DePaolo, D. J. Sr isotopes and pore fluid chemistry in 
%   carbonate sediment of the Ontong Java Plateau: Calcite recrystallization 
%   rates and evidence for a rapid rise in seawater Mg over the last 10 
%   million years. Geochim. Cosmochim. Acta 70, 3883–3904 (2006).
% Tierney, J. E., Malevich, S. B., Gray, W., Vetter, L. & Thirumalai, K. 
%   Bayesian calibration of the Mg/Ca paleothermometer in planktic 
%   foraminifera. Paleoceanogr. Paleoclimatology (2019).

%% LOAD IN DATA

close all
clearvars
clc

% This study's O. universa Mg/Ca data (and Mg/Ca_sw records already 
%  interpolated onto ages of this study's data)
thisstudy_input = readtable('ED9d_MgCasw_compilation.xlsx', 'Range', '1:25');

% Wara T. sacculifer data
wara_eep846 = readtable('ED9d_Wara05_sacculifer_MgCa_EEP847.xlsx', 'Range', 'A:B');
wara_wep806 = readtable('ED9d_Wara05_sacculifer_MgCa_WEP806.xlsx', 'Range', 'A:B');

% Full MgCa_sw records (will need to interpolate these SW values for
% correcting high-res Wara data)
sw_BAYMAG   = readtable('ED9d_sw-rec_BAYMAG.xlsx', 'Range', 'A:C');
sw_FDP06    = readtable('ED9d_sw-rec_FDP06.xlsx', 'Range', 'A:B');



%% DATA PROCESSING
% Interpolate MgCa_sw records onto Wara's ages for the two sites
% (This study's data in "input" already have correct MgCa_sw values already 
%   in it.)
% For each age in Wara data, find nearest age in sw-rec and use that Mg/Ca
%   water value (or, instead of interp1 with "nearest" method (nearest
%   neighbor), just do the "linear" method, which is already the deafault.) 
%   https://www.mathworks.com/help/matlab/ref/interp1.html#btwp6lt-1-method
% (All sw-recs fairly high-res sw-recs, except BAYMAG 0.5Ma)

% Mod. Mg = 52.8171; Mod. Ca = 10.2821; Mod. Mg/Ca = 5.1368


% ___.BAYMAG makes new col titled BAYMAG
% interp1(x, v, xq): x & v are full sw-rec, xq are Wara ages (query pts)
wara_eep846.BAYMAG = interp1(sw_BAYMAG.Age_Ma, sw_BAYMAG.MgCa_sw, wara_eep846.Age_Ma);
wara_eep846.FDP06 = interp1(sw_FDP06.Age_Ma, sw_FDP06.MgCa_sw, wara_eep846.Age_Ma);

wara_wep806.BAYMAG = interp1(sw_BAYMAG.Age_Ma, sw_BAYMAG.MgCa_sw, wara_wep806.Age_Ma);
wara_wep806.FDP06 = interp1(sw_FDP06.Age_Ma, sw_FDP06.MgCa_sw, wara_wep806.Age_Ma);

% NOTE: Evans16 sw-rec stops (last entry) at ~4.9990Ma, OBrien14 at ~4.8150Ma



%% CALC SST from this study's  O. univ. Mg/Ca Data
% Calc SSTs on this study's Orb data. 
% Anand et al 2003 orb-spec. sed-trap calibration
% Corrected for MgCa-sw by Evans and Muller 2012 but linear (i.e. exponent
%   H = 1)

A_orb = 0.090;
B_orb = 0.595;
mod_MgCa = 52.8171/10.2821; % mmol/kg / mmol/kg = mmol/mmol (or equivalently mol/mol)

% Note, Matlab "log" function does the natural log. Good.
% Wherever it's not an absolute number (i.e. A, B, mod-sw), do element-wise
%  operators
thisstudy_input.SST_BAYMAG = (log(thisstudy_input.MgCa./(B_orb*(thisstudy_input.BAYMAG./mod_MgCa))))/A_orb;
thisstudy_input.SST_Evans = (log(thisstudy_input.MgCa./(B_orb*(thisstudy_input.Evans./mod_MgCa))))/A_orb;
thisstudy_input.SST_FDP = (log(thisstudy_input.MgCa./(B_orb*(thisstudy_input.FDP./mod_MgCa))))/A_orb;
thisstudy_input.SST_OBrien = (log(thisstudy_input.MgCa./(B_orb*(thisstudy_input.OBrien./mod_MgCa))))/A_orb;





%% CALC SSTs on Wara Sacc data
% Dekens et al 2002, sacc-specific with its own built in dissolution corr.
% Corrected for MgCa-sw by Evans and Muller 2012 but linear (i.e. exponent
%   H = 1)

A_sacc = 0.084;
B_sacc = 0.31;
C_sacc = 0.048; % for dissolution corr, see pg 20 in Dekens 02 & supp of Wara 05
eep_co32 = 10.3;  % Given in supplement to Wara 05, last page ref 16
wep_co32 = -10.5; 

% East
wara_eep846.SST_BAYMAG = ((log(wara_eep846.MgCa./(B_sacc*(wara_eep846.BAYMAG./mod_MgCa))))/A_orb) - (C_sacc*eep_co32);
wara_eep846.SST_FDP = ((log(wara_eep846.MgCa./(B_sacc*(wara_eep846.FDP06./mod_MgCa))))/A_orb) - (C_sacc*eep_co32);

% West
wara_wep806.SST_BAYMAG = ((log(wara_wep806.MgCa./(B_sacc*(wara_wep806.BAYMAG./mod_MgCa))))/A_orb) - (C_sacc*wep_co32);
wara_wep806.SST_FDP = ((log(wara_wep806.MgCa./(B_sacc*(wara_wep806.FDP06./mod_MgCa))))/A_orb) - (C_sacc*wep_co32);




%% PLOTTING

% Aesthetics
 line_width = 1.25;
% Colors
 blue_4 = [0.1 0 0.5];
 blue_3 = [0.04 0.5 0.81];
 blue_2 = [0.07 0.62 1];
 blue_1 = [0.67 0.82 0.98];

 red_4 = [0.5 0 0];
 red_3 = [0.7 0.16 0.16];
 red_2 = [0.92 0 0];
 red_1 = [0.95 0.61 0.61]; 
 

figure('Position', [250 200 1100 500]);

x = wara_wep806.Age_Ma;
y = wara_wep806;

plot(x, y.SST_FDP, 'LineWidth', line_width, 'Color', red_2);
hold on
plot(x, y.SST_BAYMAG, 'LineWidth', line_width, 'Color', red_4);

% Plot line of modern WEP temperature (29.0 degC, GLODAPv2)
yline(29.0, '--', 'Color', 0.3*[1 1 1], 'LineWidth', 2);

range = [1:12];
marker_size = 80;
scatter(thisstudy_input.Age(range), thisstudy_input.SST_FDP(range), marker_size, 'MarkerEdgeColor', 'k', ...
     'MarkerFaceColor', red_2);
scatter(thisstudy_input.Age(range), thisstudy_input.SST_BAYMAG(range), marker_size, 'MarkerEdgeColor', 'k', ...
     'MarkerFaceColor', red_4);


% Aesthetics
set(gca, 'FontSize', 14)
leg = legend('Fantle and DePaolo, 2006^{81}', 'BAYMAG (Tierney et al., 2019)^{88}', ...
    'Modern WEP SST (GLODAPv2)^{66}', 'Box', 'off', 'FontSize', 12, 'Location', 'northwest');
legtitle = get(leg,'Title');
set(legtitle,'String','Mg/Ca_s_w Records')
xlim([0 6.3]);
ylim([20 38]);
xlabel('Age [Ma]', 'FontWeight', 'bold', 'FontSize', 20);
ylabel('SST [\circC]', 'FontWeight', 'bold', 'FontSize', 20);
title('Wara et al., 2005^{1}: {\itT. sacculifer} Mg/Ca with {\itO. universa} Data (This Study)', ...
    'FontSize', 18)




