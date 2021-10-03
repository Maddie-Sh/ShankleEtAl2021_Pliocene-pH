% EXTENDED DATA 1: pCO2 TIMESERIES
% Madison Shankle
% 08-Sept-2021

% Plots pCO2 over time, from pH data from this study from the western 
% equatorial Pacific and from various other studies, assuming either (a/top
% panel) a modern-like alkainity or (b/bottom panel) a modern-like calcite
% saturation state (omega) for the study sites.

% Sosdian et al., 2018 compilation
% and de la Vega et al., 2020




%%

% Clear any variables currently in workspace, close any figures currently
% open, and clear Command Window
clearvars
close all
clc


%% LOAD IN/SET UP DATA

% Load pCO2 compilation from Sosdian '18 (MShankle has added the data from
%  de la Vega '20 as well)
    pCO2_comp = readtable('ED1_Sosdian18_pCO2_compilation.xlsx');

    
% Load in pCO2 from this study's western equatorial Pacific pH data
% (pCO2 calculated from the same Monte Carlo simulation used to calculate
%    pH, uses either modern-like alkalinity at the study sites (2275 +- 200
%    umol/kg) or modern-like calcite saturation state at study sites
%    (omega = 5 +- 2, =4, and =6) as the second carbonate system parameter 
%    besides pH). Below is that assuming a modern-like alkalinity. 

    load('ED1_Shankle_pCO2_modAlk.mat'); % loads 'pCO2_2sd_WEP'

% Also load in pCO2 estimated assuming a modern-like calcite saturation
% state (omega) at the study sites (omega = 5 +- 2) (points will also be
% plotted for omega = 4 and omega = 6).
    
    load('ED1_Shankle_pCO2_modOmega4.mat');    
    load('ED1_Shankle_pCO2_modOmega5uncert2.mat');    
    load('ED1_Shankle_pCO2_modOmega6.mat');    
    
    pCO2_Omega46 = [pCO2_Omega4(1:12,1) pCO2_Omega6(1:12,1)];
    pCO2_456omega_2sd = [pCO2_Omega4(1:12,2) pCO2_Omega6(1:12,2)];    

    
    
%% SETTING UP MARKER SHAPES FOR EACH REFERENCE

% Bartoli et al. 2011
% Chalk et al. 2017
% Honisch et al. 2009 (: over o, can't do in Matlab w/o German lang thing)
% Martinez-Boti et al. 2015
% Seki et al. 2018
% Sosdian et al. 2018
% de la Vega et al. 2020

    refs = unique(pCO2_comp.Reference);
    shapes = {'o'; '+'; 'x'; 's'; 'd'; '^'; 'p'};



%% PLOTTING

grey_color = [0.15 0 0.65];
darker_grey_color = grey_color*0.5;

figure

subplot(2,1,1) % Modern Alkalinity, top panel

    % do 95CI shaded band, very light grey
        x = pCO2_comp.AgeMa;
        y_bottom = pCO2_comp.lower_95CI;
        y_top    = pCO2_comp.upper_95CI;

        f1 = fill([x;flipud(x)],[y_top;flipud(y_bottom)],[0.86 0.86 0.86], 'linestyle', 'none'); 
        set(f1,'facealpha',0.4);
        hold on

    % do 68CI shaded band, slightly darker grey
        x = pCO2_comp.AgeMa;
        y_bottom = pCO2_comp.lower_68CI;
        y_top    = pCO2_comp.upper_68CI;

        f2 = fill([x;flipud(x)],[y_top;flipud(y_bottom)],[0.86 0.86 0.86], 'linestyle', 'none');
        set(f2,'facealpha',0.8);


    % Plot all the different references' pCO2 as scatter points
        for ii = 1:length(refs)
            index = find(contains(pCO2_comp.Reference,refs{ii}));

            scatter(pCO2_comp.AgeMa(index), pCO2_comp.CO2ppmv(index), 36, shapes{ii}, ...
                'MarkerEdgeColor', [0.6 0.6 0.6]);
        end

    % plot pCO2 from this study    
        errorbar(pCO2_2sd_WEP(:,1), pCO2_2sd_WEP(:,2), pCO2_2sd_WEP(:,3), 'o', ...
            'MarkerFaceColor', grey_color, 'Color', grey_color, 'LineStyle', ...
            'none', 'LineWidth', 1.3);

    % Aesthetics
        set(gca, 'FontSize', 12);
        xlabel('Age (Ma)', 'FontWeight', 'bold', 'FontSize', 14)
        ylabel('pCO_2 (ppmv)', 'FontWeight', 'bold', 'FontSize', 14)
        title('Assuming Modern-like Alkalinity', 'FontSize', 17)
        legend('95% CI', '68% CI', [refs{1} '^{110}'], [refs{2} '^{84}'], ...
            [refs{3} '^{111}'], [refs{4} '^{51}'], [refs{5} '^{112}'], ...
            [refs{6} '^{112}'], [refs{7} '^{114}'], ...
            ['This Study (' char(177) '2sd)'], 'Location', 'eastoutside',...
            'FontSize', 10) 
        set(gcf, 'Position', [150, 350, 1100, 400])

        
subplot(2,1,2) % Modern Calcite Saturation State (Omega), bottom panel
               % Largely the same as above, except for section: 'plot pCO2 
               %  from this study'
               
    % do 95CI shaded band, very light grey
        x = pCO2_comp.AgeMa;
        y_bottom = pCO2_comp.lower_95CI;
        y_top    = pCO2_comp.upper_95CI;

        f1 = fill([x;flipud(x)],[y_top;flipud(y_bottom)],[0.86 0.86 0.86], 'linestyle', 'none'); 
        set(f1,'facealpha',0.4);
        hold on

    % do 68CI shaded band, slightly darker grey
        x = pCO2_comp.AgeMa;
        y_bottom = pCO2_comp.lower_68CI;
        y_top    = pCO2_comp.upper_68CI;

        f2 = fill([x;flipud(x)],[y_top;flipud(y_bottom)],[0.86 0.86 0.86], 'linestyle', 'none');
        set(f2,'facealpha',0.8);


    % Plot all the different references' pCO2 as scatter points
        for ii = 1:length(refs)
            index = find(contains(pCO2_comp.Reference,refs{ii}));

            scatter(pCO2_comp.AgeMa(index), pCO2_comp.CO2ppmv(index), 36, shapes{ii}, ...
                'MarkerEdgeColor', [0.6 0.6 0.6]);
        end

        
    % plot pCO2 from this study 
    % Omega = 5 +- 2
    age = pCO2_2sd_WEP(:,1); % re-use age from 1st col in mod-alk data
    errorbar(age, pCO2_Omega5uncert2(1:12,1), pCO2_Omega5uncert2(1:12,2), 'o', ...
        'MarkerFaceColor', grey_color, 'Color', grey_color, 'LineStyle', ...
        'none', 'LineWidth', 1.3);

    % Plot pCO2 according to 4 and 6 omega
    % Omega = 4
    scatter(age(1:12), pCO2_Omega46(1:12,1), 's', 'MarkerFaceColor', ...
        darker_grey_color, 'MarkerEdgeColor', darker_grey_color)
    % Omega = 6
    scatter(age(1:12), pCO2_Omega46(1:12,2), 's', 'MarkerFaceColor', ...
        darker_grey_color, 'MarkerEdgeColor', darker_grey_color) % my_color*0.5)
    
    xlabel('Age (Ma)', 'FontWeight', 'bold', 'FontSize', 13)
    ylabel('pCO_2 (ppmv)', 'FontWeight', 'bold', 'FontSize', 13)
    title('Assuming Modern-like Calcite Saturation State', 'FontSize', 16)
    legend('95% CI', '68% CI', [refs{1} '^{110}'], [refs{2} '^{84}'], ...
        [refs{3} '^{111}'], [refs{4} '^{51}'], [refs{5} '^{112}'], ...
        [refs{6} '^{112}'], [refs{7} '^{114}'], ...
        ['This Study (' char(177) '2sd)'], '\Omega = 4 (bottom) & = 6 (top)', ...
        'Location', 'eastoutside')
    set(gcf, 'Position', [150, 350, 1100, 400])

    
