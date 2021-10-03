%% ED4c: Plotting d11B-derived pH (Henehan et al. 2016 Orbulina universa 
% calibration) versus observed pH
% Madison Shankle
% 13-09-2021

% Plots a coretop calibration figure of d11B-derived pH (from reported d11B
% values in various studies, pH calculated with either reported temperature
% and salinity in the study or temperature and salinity from World Ocean
% Atlas 2018) versus in-situ reported pH at the studys' sites.

% Note, this script requires ED4c_linfitxy_MS.m to work - this is a
% slightly adapted version fo linfitxy.m, available on Matlab's file
% exchange at the following website (current as of 12-09-2021):
%  https://www.mathworks.com/matlabcentral/fileexchange/45711-linear-fit-with-both-uncertainties-in-x-and-in-y

% References for core top data, etc.:
%   Henehan, M. J. et al. A new boron isotope-pH calibration for Orbulina 
%      universa, with implications for understanding and accounting for ‘vital effects’. Earth Planet. Sci. Lett. 454, 282–292 (2016).
%   Raitzsch, M. et al. Boron isotope-based seasonal paleo-pH 
%      reconstruction for the Southeast Atlantic – A multispecies approach 
%      using habitat preference of planktonic foraminifera. Earth Planet. 
%      Sci. Lett. 487, 138–150 (2018).
%   Guillermic, M. et al. Seawater pH reconstruction using boron isotopes 
%      in multiple planktonic foraminifera species with different depth 
%      habitats and their potential to constrain pH and pCO 2 gradients. 
%      Biogeosciences 17, 3487–3510 (2020).

%% LOAD IN DATA

close all
clearvars
clc

input = readtable('ED4c_coretop_compilation.xlsx'); 


% Load in pHs and other things
    refs = input.Ref;
    refs_unique = unique(refs);

    types = input.Type;
    types_unique = unique(types);

% d11B-derived pH (using WOA18 T & S input)
    B_avg_2550m = input.BpHavg2550m;
    Ber_avg_2550m = input.BpHeravg2550m;

% In-situ pH reported in study (various datasets and methods)
    study_pH   = input.studypH;
    study_pHer = input.studypHer;


%% PLOTTING

close all
clc

% Scatter plot data with a line of best fit and 2sigma shading around
[ P, SP ] = ED4c_linfitxy_MS( study_pH, B_avg_2550m, study_pHer, Ber_avg_2550m, 'NSigma', 2);

% One-to-one line (black dashed)
    rline = refline(1,0);
    rline.Color = 'k';
    rline.LineStyle = '--';
    rline.LineWidth = 3;

% Aesthetics
set(gca, 'FontSize', 14, 'FontWeight', 'bold')
axis_font_size = 20;
xlabel('Study-reported pH', 'FontSize', axis_font_size)
ylabel('\fontsize{20}\delta^{11}B-derived pH \fontsize{14}(Henehan ''16 Calibration)')
title('\delta^{11}B Calibration on Core Top Compilation', 'FontSize', axis_font_size*1.25);

xlim([7.95 8.21])
ylim([7.88 8.27])



default_orange_darker = [0.8500 0.3250 0.0980]*0.5; % default_orange = [0.8500 0.3250 0.0980];
default_green  = [0.4660 0.6740 0.1880]*0.5;

% --- Fixing off Raitzsch et al. 2018 and Guillermic et al. 2020 points ---
% Fixed Raitzsch point: x=8.177 is co2sys-calc'd with all Ratizsch data
% except more realistic alkalinity (2325 vs 2193, change of 132)
hold on
% FIRST first plot a white circle to cover up the old point
scatter(7.989, 8.175, 150, 'o', 'MarkerFaceColor', [1 1 1], ...
    'MarkerEdgeColor', [1 1 1], 'HandleVisibility', 'off', ...
    'LineWidth', 2.5);
hold on
% First an X at the old point
scatter(7.989, 8.175, 150, 'x', 'MarkerFaceColor', 'none', ...
    'MarkerEdgeColor', default_orange_darker, 'HandleVisibility', 'off', ...
    'LineWidth', 2.5);
hold on
% Then corrected point
scatter(8.177, 8.175, 150, 'o', 'MarkerFaceColor', 'none', ...
    'MarkerEdgeColor', default_orange_darker, 'HandleVisibility', 'on', ...
    'LineWidth', 3.5);
hold on

% Fixed Guillermic point: y=7.992 is pH calc'd by MC simulation using G's
% very cold T (~18C) (instead of T I got from WOA18) which idk where it 
% came from, doesn't look right (given WOA18 and a point 20deg farther
% south being warmer and his own PreInd temp figures in paper) but must be 
% right
% FIRST first plot a white circle to cover up the old point
scatter(8.07, 7.8979, 150, 'o', 'MarkerFaceColor', [1 1 1], ...
    'MarkerEdgeColor', [1 1 1], 'HandleVisibility', 'off', ...
    'LineWidth', 2.5);
hold on
% First an x around the old point
scatter(8.07, 7.8979, 150, 'x', 'MarkerFaceColor', 'none', ...
    'MarkerEdgeColor', default_green, 'HandleVisibility', 'off', ...
    'LineWidth', 2.5);
hold on
% Then corrected point
scatter(8.07, 7.992, 150, 'o', 'MarkerFaceColor', 'none', ...
    'MarkerEdgeColor', default_green, 'HandleVisibility', 'on', ...
    'LineWidth', 3.5);


% Add arrows connected old bad points to fixed points
% Orange Raitzsch point:
annotation('textarrow', [0.268 0.78], [0.7273 0.7273], 'LineStyle', '--', ...
    'HeadStyle', 'cback3', 'LineWidth', 2, 'Color', default_orange_darker, ...
    'HandleVisibility', 'off');
% Green Guillermic point:
annotation('textarrow', [0.488 0.488], [0.173 0.315], 'LineStyle', '--', ...
    'HeadStyle', 'cback3', 'LineWidth', 2, 'Color', default_green, ...
    'HandleVisibility', 'off');


legend(' Line of Best Fit', ' (2\sigma)', ' Henehan et al., 2016^{36}: Core Tops', ...
    '  " Net Tows', '  " Sed. Traps', ' Raitzsch et al., 2018^{108}', ' Guillermic et al., 2020^{109}',  ...
    ' 1:1 Line', ' Fixed Raitzsch point', ' Fixed Guillermic point', ...
    'Location', 'southeast', 'Box', 'off', 'FontWeight', 'normal', ...
    'FontSize', 12)

