% EXTENDED DATA 9c: This study's Mg/Ca SSTs with a dissolution correction
% Madison Shankle
% 03-10-2021

% Plots the SSTs derived from the Mg/Ca data of this study, with the
% dissolution correction of Regenberg et al. (2014) applied.

% Reference:
% Regenberg, M. et al. Global dissolution effects on planktonic 
%   foraminiferal Mg/Ca ratios controlled by the calcite‐saturation state 
%   of bottom waters. Paleoceanography 29, 127–142 (2014).


%% LOAD IN DATA

close all
clearvars
clc

% This study's O. universa Mg/Ca data (and Mg/Ca_sw records already 
%  interpolated onto ages of this study's data)
thisstudy_input = readtable('ED9c_MgCasw_compilation', 'Range', '1:25');


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
thisstudy_input.SST_FDP = (log(thisstudy_input.MgCa./(B_orb*(thisstudy_input.FDP./mod_MgCa))))/A_orb;
% SST_FDP stands for SSTs calculated using the Mg/Ca_sw record of Fantle &
% DePaolo, 2006.


%% CALC SST with a dissolution correction
DissCorr = table();
DissCorr.E_W = thisstudy_input.E_W;
DissCorr.Age = thisstudy_input.Age;
DissCorr.ID = thisstudy_input.ID;
DissCorr.MgCa = thisstudy_input.MgCa;

correction = [0.7664 0.7664 0.7664 0.7664 0.7664 0.7664 0.7664 0.7664...
    0.7664 0.7664 0.7664 0.7664 1.4162 1.4162 1.4162 1.4162 1.4162 1.4162...
    1.4162 1.4162 1.4162 1.4162 1.4162 1.4162]';

DissCorr.MgCaCorr = thisstudy_input.MgCa + correction; % previously (v3): input.MgCa - correction;

DissCorr.SST_FDP = (log(DissCorr.MgCaCorr./(B_orb*(thisstudy_input.FDP./mod_MgCa))))/A_orb;

% Fill in missing data point with linear interpolation
DissCorr.SST_FDP(10) = interp1(DissCorr.Age([9 11]), DissCorr.SST_FDP([9 11]),DissCorr.Age(10), 'linear', 'extrap'); 
thisstudy_input.SST_FDP(10) = interp1(thisstudy_input.Age([9 11]), thisstudy_input.SST_FDP([9 11]),thisstudy_input.Age(10), 'linear', 'extrap'); 



%% PLOTTING

% Aesthetics 
marker_size = 10;
orange = [0.85 0.33 0.10];
blue = [0 0.45 0.74];

figure('Position', [200 200 800 500]);

% NORMAL
% West
plot(thisstudy_input.Age(1:12), thisstudy_input.SST_FDP(1:12), 's', 'MarkerEdgeColor', orange, ...
    'MarkerSize', marker_size);
hold on
% East
plot(thisstudy_input.Age(13:24), thisstudy_input.SST_FDP(13:24), 's', 'MarkerEdgeColor', blue, ...
    'MarkerSize', marker_size);

% DISSOLUTION CORRECTION
% West
plot(DissCorr.Age(1:12), DissCorr.SST_FDP(1:12), 's', 'MarkerFaceColor', ...
    orange, 'MarkerEdgeColor', orange, 'MarkerSize', marker_size);
% East
plot(DissCorr.Age(13:24), DissCorr.SST_FDP(13:24), 's',  'MarkerFaceColor', ...
    blue, 'MarkerEdgeColor', blue, 'MarkerSize', marker_size);


ylim([18 34]); % [10 35]
legend('West', 'East', '{\itWith} Dissolution Correction', ...
    '{\itWith} Dissolution Correction', ...
    'Location', 'northwest', 'Box', 'off', 'FontSize', 11);
set(gca, 'FontSize', 14);
xlabel('Age [Ma]', 'FontWeight', 'bold');
ylabel('SST [\circC]', 'FontWeight', 'bold');

