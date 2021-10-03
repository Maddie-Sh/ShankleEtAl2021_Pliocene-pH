% FIGURE 1: HYPOTHESES SCHEMATIC
% Madison Shankle
% 18-08-2021

% Plots a line plot of modern pH values (for the eastern and western
% equatorial Pacific, EEP/WEP) and pH values from the early Pliocene/late
% Miocene. Also saves figures as a PDF ('Fig1_Shankle_Hypoth-pH-lines.pdf')

% Early Pliocene/late Miocene WEP pH value is the average pH value (and 
% 2sd error) found in the ~6Ma data of this study.

% Estimated/hypothesized early Pliocene/late Miocence pH values for the EEP 
% (dotted and dashed blue lines) are derived as follows. First, the zonal 
% pH gradient in the early Pliocene/late Miocene quatorial Pacifc was 
% estimated by applying the percent-reductions relative to modern in eq. 
% Pacific zonal sea surface temperature gradient (as reported in the two 
% refereces below for the early Pliocene/late Miocene) to the Pacific's 
% modern zonal pH gradient (~0.06, see Methods for details of getting 
% modern pH values and zonal gradient). With these two estimates for the 
% early Pliocene/late Miocene zonal pH gradient in hand (0.017 and 0.049, 
% west minus east), EEP values of pH for the early Pliocene/late Miocene 
% were estimated by subtracting these gradients to a representative early 
% Pliocene/late Miocene WEP pH value of ~8.021 (estimated from a 
% representative atmospheric pCO2 value of 400ppm with CO2Sys).

% The third value for early Pliocene/late Miocene EEP pH (solid blue line)
% is derived from the model output of this study, taken along the equator
% and averaged over the 25-55m depth range.


% TWO HYPOTHESIZED SCENARIOS (DOTTED AND DASHED BLUE LINES) FOR EARLY 
% PLIOCENE/LATE MIOCENE EQUATORIAL PACIFIC PH (ASSUMING ZONAL pH AND SST 
% GRADIENTS ARE COUPLED, I.E. REDUCED TO THE SAME MAGNITUDE/EXTENT)
% (1) REDUCED ZONAL GRADIENT (Liu et al, 2019)      
%     A 72% reduction (or 28% of the modern gradient, i.e. 0.28*0.06)
%        Liu, J. et al. Eastern equatorial Pacific cold tongue evolution 
%          since the late Miocene linked to extratropical climate. Sci. 
%          Adv. 5, eaau6060 (2019).
%(2) MAINTAINED ZONAL GRADIENT (Zhang et al., 2014) 
%    A 18% reduction (or 82% of the modern gradient, i.e. 0.82*0.06)
%    (roughly maintained/slight reduction)
%        Zhang, Y. G., Pagani, M. & Liu, Z. A 12-Million-Year Temperature 
%          History of the Tropical Pacific Ocean. Science 344, 84–88 (2014).



%% LOAD IN/SET UP DATA

% Clear any variables currently in workspace, close any figures currently
% open, and clear Command Window
clear all
close all 
clc


wep_pH_mod    = 8.067;
eep_pH_mod    = 8.007;

modern_pH_gradient  = wep_pH_mod - eep_pH_mod; % 0.06
reduced_hypothesis_grad_reduction   = 0.28;
maintained_hypothesis_grad_reduction= 0.82;

reduced_gradient    = modern_pH_gradient*reduced_hypothesis_grad_reduction;
maintained_gradient  = modern_pH_gradient*maintained_hypothesis_grad_reduction;

wep_pH_400ppm = 8.021;


% This study's data. (Red early Pliocene/late Miocene WEP pH and error)
%   Loads in a 24x2 array ('pH_final) where the columns are pH and 2sd on 
%   pH, respectively. Ages not given but first 12 are WEP and last 12 are 
%   EEP. Within WEP or EEP, grouped in three groups of four giving data 
%   from ~1Ma, then ~3Ma, then ~6Ma. I.e., rows 9-12 are the four ~6Ma WEP 
%   data points from this study, corresponding to ages 5.800Ma, 5.852Ma, 
%   5.899Ma, and 6.000Ma.
load('Fig1_Shankle_Pliocene_pH_results.mat', 'pH_final')
myWest_plio_average = mean(pH_final(9:12,1));
myWest_plio_average_error = mean(pH_final(9:12,2));
clear pH_final;


% Blue Dotted EEP "Reduced": (Reduced Thermal (SST) Gradient AND Reduced Upwelling (pH))
%  First column is fake "ages" of 0.1 and 1, just for plotting. Second
%  column (top and bottom rows, respectively)is modern EEP pH and estimated 
%  early Plio/late Mio pH (400ppm WEP's pH (8.021) minus gradient for 
%  reduced scenario (0.017))
reduced_hypoth = [0.1 1; eep_pH_mod wep_pH_400ppm-reduced_gradient]';

% Blue Dashed EEP "Maintained": (Maintained Thermal (SST) Gradient AND Maintained Upwelling (pH))
%  First column is fake "ages" of 0.1 and 1, just for plotting. Second
%  column (top and bottom rows, respectively) is modern EEP pH and  
%  estimated early Plio/late Mio pH (400ppm WEP's pH (8.021) minus gradient 
%  for maintained scenario (0.028))
maintained_hypoth = [0.1 1; eep_pH_mod wep_pH_400ppm-maintained_gradient]';

% Blue Solid EEP "Decoupled" Scenario: (Thermal (SST) Gradient ~Reduced~ But Upwelling (pH) ~Enhanced~) 
%  First column is fake "ages" of 0.1 and 1, just for plotting. Second
%  column (top and bottom rows, respectively) is modern EEP pH and  
%  estimated early Plio/late Mio pH (model output from experimental early 
%  Plio/late Mio-like run, from EEP averaged over 25-55m depth range)
model_255mavg = [0.1 1; eep_pH_mod 7.8863]'; % 7.8863: east, ExpA, 25-55m avg




%% Plotting


% Aesthetics
line_width = 3.5;
error_line_width = 3;
marker_size_red = 30;

% Colors
red = [1 0 0];
teal = [ 0.25 0.5 0.75];
dark_blue = [0.05 0.35 0.60];


close all

figure('Position', [300 200 1100 600])


subplot('Position',[0.104545454545455 0.11 0.674545454545455 0.815])

% Plot Red WEP (this study's data) line
p = plot([0.1 1], [wep_pH_mod myWest_plio_average], '-', 'Color', red, 'Marker', ...
     '.', 'LineWidth', line_width, 'MarkerSize', marker_size_red);
hold on
e = errorbar(1, myWest_plio_average, myWest_plio_average_error, 'Color', ...
    red, 'LineWidth', error_line_width, 'HandleVisibility', 'off');

% Plot Blue Dotted line EEP: "Reduced"
p = plot(reduced_hypoth(:,1), reduced_hypoth(:,2), ':', 'Color', teal, 'Marker', ...
    '.', 'LineWidth', line_width-0.5, 'MarkerSize', marker_size_red);

% Plot Blue Dashed line EEP: "Maintained"
p = plot(maintained_hypoth(:,1), maintained_hypoth(:,2), '--', 'Color', teal, 'Marker', ...
    '.', 'LineWidth', line_width, 'MarkerSize', marker_size_red);

% Plot Blue Solide line EEP: "Decoupled"
p = plot(model_255mavg(:,1), model_255mavg(:,2), '-', 'Color', dark_blue, 'Marker', ...
    '.', 'LineWidth', line_width, 'MarkerSize', marker_size_red);


% More aesthetics
ylim([7.85 8.12])
xlim([0.05 1.05])
xticks([0.1 1])
xticklabels({});
ylabel('\fontsize{19}pH', 'FontWeight', 'bold');
set(gca, 'FontSize', 13)
set(gca,'XMinorTick','off','YMinorTick','on')
set(gca,'FontSize', 14)
set(gca,'box','on')
set(gca, 'LineWidth', 1)
  
 
% Modern/early Plio late Mio Annotations
    annotation('textbox',...
        [0.100100507986169 0.028042328042328 0.132497442586465 0.087301587301587],...
        'String',{'Modern'},...
        'FontWeight','bold',...
        'FontSize',18,...
        'FitBoxToText','off',...
        'EdgeColor','none');

    annotation('textbox',...
        [0.653434343434343 0.0273015873015873 0.183656361853084 0.087301587301587], ... % [0.67 0.028042328042328 0.154161412358134 0.087301587301587]   ,... % [0.696224131198414 0.028042328042328 0.154161412358134 0.087301587301587]
        'String',{'early Pliocene /' 'late Miocene'},...
        'FontWeight','bold',...
        'FontSize',18,...
        'FitBoxToText','off',...
        'EdgeColor','none',...
        'HorizontalAlignment', 'center');

% Lines Annotations: WEP, EEP: Reduced, EEP: Maintained, EEP: Decoupled
labels_fontsize = 15;
% Red Label
    annotation('textbox',...
        [0.777676265561926 0.56582010582011 0.132497442586465 0.0873015873015871], ... %[0.777676265561926 0.565820105820107 0.132497442586465 0.0873015873015871],...
        'Color',[1 0 0],...
        'String',{'WEP'},...
        'FontSize',labels_fontsize,...
        'FontWeight', 'bold', ...
        'FitBoxToText','off',...
        'EdgeColor','none');
% Blue Dotted Label
    annotation('textbox',...
        [0.777676265561926 0.519153439153445 0.2 0.0873015873015871], ... % [0.777676265561926 0.530820105820109 0.2 0.0873015873015871],...
        'Color', teal,...
        'String',{'EEP: Reduced\newline         Gradient'},...
        'FontSize',labels_fontsize,...
        'FontWeight', 'bold', ...
        'FitBoxToText','off',...
        'EdgeColor','none');
% Blue Dashed Label
    annotation('textbox',...
        [0.777676265561926 0.417486772486778 0.2 0.0873015873015873], ... % [0.777676265561926 0.465820105820109 0.2 0.0873015873015872],...
        'Color', teal,...
        'String',{'EEP: Maintained\newline         Gradient'},...
        'FontSize',labels_fontsize,...
        'FontWeight', 'bold', ...
        'FitBoxToText','off',...
        'EdgeColor','none');
% Blue Solid Label 
    annotation('textbox',...
        [0.777676265561926 0.162486772486775 0.161818683933023 0.0873015873015874], ... % [0.777676265561926 0.105820105820108 0.161818683933023 0.0873015873015873],...
        'Color', dark_blue,...
        'String',{'EEP: Decoupled\newline         Gradients'},...
        'FontSize',labels_fontsize,...
        'FontWeight', 'bold', ...
        'FitBoxToText','off',...
        'EdgeColor','none');


%% Save figure as PDF
set(gcf,'PaperPositionMode','auto'); 
set(gcf,'PaperOrientation','landscape');
saveas(gcf,'Fig1_Shankle_Hypoth-pH-lines.pdf')