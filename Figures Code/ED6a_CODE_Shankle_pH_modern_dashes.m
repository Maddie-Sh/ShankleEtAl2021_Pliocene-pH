% EXTENDED DATA 6A - pH Time Series with Modern pH Dashes
% Madison Shankle
% 29-09-2021

% Plots a timeseries of pH, with all observations of modern pH plotted as
% dashes along the y-axis (all observations that went into the mean modern
% pH points plotted on the y-axis of Figure 2b (diamonds)).

%% LOAD IN DATA

% Clear any variables currently in workspace, close any figures currently
% open, and clear Command Window
clearvars
close all 
clc

east = xlsread('ED6_Shankle_east_pH_results.xls'); % add _BAYMAG if want to do with BAYMAG data
west = xlsread('ED6_Shankle_west_pH_results.xls'); % " "
east_avgs = xlsread('ED6_Shankle_east_pH_avgs.xls'); % " "
west_avgs = xlsread('ED6_Shankle_west_pH_avgs.xls'); % " "
% These Excel sheets have the following columns:
% (1) Age [Ma], (2) pH, (3) 2sd pH, (4) Temp Range [pH] (not incl BAYMAG), 
% (5) Temp Range [pH] w/ BAYMAG, (6) d11B [permil], (7) 2sd d11B [permil]
% NOTE: IGNORE COLS (4) & (5) TEMP RANGES - THESE ARE GIVEN IN 
% "ED6_Shankle_upper_lower_pH_bySSTs.xls"


ThreeMa = xlsread('ED6_MB15_3Ma_forMatLab.xls');
% This Excel sheet has the following columns:
% (1) Age [Ma], (2) pH, (3) avg. 95% CI, (4) d11B [permil], (5) 2sd d11B
% 3Ma: Martinez-Boti 2015 Nature Article:
%   Caribbean eqb. site (ODP999), G. ruber
%   Martínez-Botí, M. A. et al. Plio-Pleistocene climate sensitivity 
%     evaluated using high-resolution CO 2 records. Nature 518, 49–54 (2015).


% Modern pH
east_mod_pH = 8.007; % See Methods for details of modern pH values
west_mod_pH = 8.067;
load('ED6_observed_pH_vals_2550mavg.mat')
    % Has:
    % east_pHs_2550mavg_ElNino (n=5)
    %                  _LaNina (n=22)
    %                  _neutral (n=12) % NOTE - BAD, not from near site, don't include
    % west_pHs_2550mavg_ElNino (n=16)
    %                  _LaNina (n=14)
    %                  _neutral (n=21)


%% PLOT

% COLORS
% Main Points
 main_red = [0.76 0 0.22];
 main_blue = [0.11 0.25 0.88];
% For Averages
 very_dark_blue = [0 0 0.35];
 very_dark_red = [0.45 0 0];
% For MB15 3Ma
 grey_color = [0.2 0.2 0.2];
 light_grey_color = [0.65 0.65 0.65];
 MB_3Ma_color = light_grey_color + 0.2;        % Prev. light green color [0.75 0.95 0.75];
 MB_3Ma_color_darker = light_grey_color +0.02; % + 0.15; % Prev. darker green color [0.69 0.89 0.69];

% Aesthetics
size_normal_points = 35;
size_avg_points = 7;
size_3Ma_points = 4;
size_mod_points = 125;
linewidth_normal_markers = 1.25;
linewidth_normal_errorbars = 1.25;
linewidth_normal_SST_errorbars = 1;
linewidth_avgs = 1.5;
linewidth_avgs_errorbars = 3.5;
linewidth_3Ma = 0.75;




%% 
  
  
%% Supp. Fig. 2: Repeat panel b^ (pH in time) with Temp range behind

linewidth_for_ranges = 4.5;

figure

% BEFORE ANYTHING ELSE, plot dashes on yaxis for modern east and west pHs
% at 25-50m depth average.
    dash_size = 10;
    dash_width = 1;

    % West
        plot(zeros(size(west_pHs_2550mavg_LaNina)), west_pHs_2550mavg_LaNina, ...
            '_', 'Color', [1 0.75 0.75], 'LineWidth', 1.5, 'MarkerSize', ...
            dash_size);
        hold on
        plot(zeros(size(west_pHs_2550mavg_ElNino)), west_pHs_2550mavg_ElNino, ...
            '_', 'Color', [0.5 0 0], 'LineWidth', 1.5, 'MarkerSize', ...
            dash_size);
        plot(zeros(size(west_pHs_2550mavg_neutral)), west_pHs_2550mavg_neutral, ...
            '_', 'Color', [1 0.25 0.25], 'LineWidth', dash_width, 'MarkerSize', ...
            dash_size);

    % East El Nino dark, neutral normal
        plot(zeros(size(east_pHs_2550mavg_ElNino)), east_pHs_2550mavg_ElNino, ...
            '_', 'Color', [0.0,0.26,0.58], 'LineWidth', dash_width, 'MarkerSize', ...
            dash_size);
        hold on
        plot(zeros(size(east_pHs_2550mavg_neutral)), east_pHs_2550mavg_neutral, ...
            '_', 'Color', [0.0,0.65,0.95], 'LineWidth', dash_width, 'MarkerSize', ...
            dash_size);    
    
% PLOT FAKE POINT TO ADD EXTRA ITEM ON LEGEND: so that 3 items in first
  % column (LGMx2 + 3Ma), 2 items in next colum (Modern east/west), and
  % finally 3 items in last column (SST Uncert, Analytical Uncert
  % east/west)
    scatter(0.01, 9.1, 'd');  
    
    
% NOW PLOT ESTIMATES OF MODERN pH
    % West Modern
      scatter(0.01, west_mod_pH, size_mod_points, 'diamond', 'MarkerFaceColor', ...
          main_red, 'MarkerEdgeColor', 'k');   % face color main_red
      % East Modern
      scatter(0.01, east_mod_pH, size_mod_points, 'diamond', 'MarkerFaceColor', ...
          main_blue, 'MarkerEdgeColor', 'k');
     
      
      
% PLOT FAKE POINT TO ADD EXTRA ITEM ON LEGEND: so that 3 items in first
  % column (LGMx2 + 3Ma), 2 items in next colum (Modern east/west), and
  % finally 3 items in last column (SST Uncert, Analytical Uncert
  % east/west)
    scatter(0.01, 9.1, 'square');      
      
    
% PLOT MARTINEZ-BOTI 3Ma DATA
      x = ThreeMa(:,1);
      y = ThreeMa(:,2);
      dy = ThreeMa(:,3);
      fill([x;flipud(x)],[y-dy;flipud(y+dy)],[0.86 .86 .86],'linestyle','none',...
          'HandleVisibility', 'off');
      
      plot(ThreeMa(:,1), ThreeMa(:,2), '-s', 'MarkerSize', size_3Ma_points, ...
          'MarkerFaceColor', MB_3Ma_color_darker, 'MarkerEdgeColor', ...
          MB_3Ma_color_darker, 'LineWidth', linewidth_3Ma, 'Color',...
          MB_3Ma_color_darker);



% Some rearranging of Extra points to get legend to work properly

      
  % FIRST FOR LOOP: PLOT NORMAL POINTS (2nd = AVERAGES)
    for i = 1:2
        if i == 1 % First plot EAST pH 
            x = east;
            color_to_use = main_blue;
            dark_color_to_use = very_dark_blue;
        else 
            x = west; % Then plot WEST pH
            color_to_use = main_red;
            dark_color_to_use = very_dark_red;
        end
      
          % Then plot normal analytical uncertainty error bars on top of that
          e = errorbar(x(:,1), x(:,2), x(:,3), 'LineStyle', 'none', ...
              'LineWidth', linewidth_normal_errorbars+0.2, 'HandleVisibility', 'on');
          e.Color = color_to_use;
          e.CapSize = 9;
          
          % Then plot points
          scatter(x(:,1), x(:,2), size_normal_points, 'o',  'MarkerFaceColor', 'white', ...
              'MarkerEdgeColor', color_to_use, 'LineWidth', ...
              linewidth_normal_markers, 'HandleVisibility', 'off');
    end

    
    
    
    for i = 1:2   % SECOND FOR LOOP: PLOT AVERAGES
        if i == 2 
            y = east_avgs;
            color_to_use = main_blue;
            dark_color_to_use = very_dark_blue;
        else 
            y = west_avgs;
            color_to_use = main_red;
            dark_color_to_use = very_dark_red;
        end
        
        % Scatter plot averages darker w/ line
%           % First plot BIG ERROR BARS in grey (temp+analytical uncert.)
%           e = errorbar(y(:,1), y(:,2), y(:,3)+(y(:,4)/2), 'LineStyle', 'none', ...
%               'HandleVisibility', 'off', 'LineWidth', linewidth_avgs_errorbars);
%           e.Color = [0 0 0]; %grey_color;
%           e.CapSize = 12;      
          % Then plot normal analytical uncertainty error bars on top of that
          e = errorbar(y(:,1), y(:,2), y(:,3), 'LineStyle', 'none', ...
              'HandleVisibility', 'off', 'LineWidth', linewidth_avgs_errorbars);
          e.Color = dark_color_to_use;
          e.CapSize = 12;
          % Plot averages with a line through them
          plot(y(:,1), y(:,2), '-o', 'Color', dark_color_to_use, ...
             'MarkerFaceColor', dark_color_to_use, 'MarkerSize', size_avg_points, ...
             'LineWidth', linewidth_avgs, 'HandleVisibility', 'off');
               
    end
    
    
    

    
      
      
  xlim([0 6.4])
  ylim([7.65 8.25])
%   yticks([7.7:0.1:8.2]);
  set(gca,'XMinorTick','on','YMinorTick','on')
  set(gca,'FontSize', 13)
  set(gca,'box','on')
  grid on
  
  xlabel('\fontsize{17}Age \fontsize{13}(Ma)', 'FontWeight', 'bold');
  ylabel('\fontsize{17}pH', 'FontWeight', 'bold');
  legend('Modern La Nina', 'Modern El Nino', 'Modern Neutral', ...
      'Modern El Nino', 'Modern Neutral', ' ', 'Avg. Modern West', ...
      'Avg. Modern East', ' ', '3Ma, Eqb. Site', ...
      '2\sigma', '2\sigma', ...
      'FontSize', 11.75, 'NumColumns', 5, 'Position', ...
      [0.095743215031315 0.01526 0.87996 0.066025]);
  legend boxoff 
  

  