% EXTENDED DATA 6c: pH Timeseries from BAYMAG-Calibration SSTs
% Madison Shankle
% 29-09-2021

% Plots a timeseries of pH, with pH as calculated from SSTs from this
% study's Mg/Ca data converted into SST by the BAYMAG calibration


%% LOAD IN DATA

% Clear any variables currently in workspace, close any figures currently
% open, and clear Command Window
clearvars
close all 
clc

east = xlsread('ED6_Shankle_east_pH_results_BAYMAG.xls');
west = xlsread('ED6_Shankle_west_pH_results_BAYMAG.xls');
east_avgs = xlsread('ED6_Shankle_east_pH_avgs_BAYMAG.xls');
west_avgs = xlsread('ED6_Shankle_west_pH_avgs_BAYMAG.xls');
% These Excel sheets have the following columns:
% (1) Age [Ma], (2) pH, (3) 2sd pH, (4) Temp Range [pH] (not incl BAYMAG), 
% (5) Temp Range [pH] w/ BAYMAG, (6) d11B [permil], (7) 2sd d11B [permil]
% NOTE: IGNORE COLS (4) & (5) TEMP RANGES - THESE ARE GIVEN IN 
% "ED6_Shankle_upper_lower_pH_bySSTs.xls"

ThreeMa = xlsread('ED6_MB15_3Ma_forMatlab.xls');
% This Excel sheet has the following columns:
% (1) Age [Ma], (2) pH, (3) avg. 95% CI, (4) d11B [permil], (5) 2sd d11B
% 3Ma: Martinez-Boti 2015 Nature Article:
%   Caribbean eqb. site (ODP999), G. ruber
%   Martínez-Botí, M. A. et al. Plio-Pleistocene climate sensitivity 
%     evaluated using high-resolution CO 2 records. Nature 518, 49–54 (2015).


% Modern pH 
east_mod_pH = 8.007; % See Methods for details of modern pH values
east_mod_1sd = 0.062;
west_mod_pH = 8.067;  
west_mod_1sd = 0.007;





%% PLOT

% COLORS
% Main Points
 main_red = [0.76 0 0.22];
 main_blue = [0.11 0.25 0.88];
% For Averages
 very_dark_blue = [0 0 0.35];
 very_dark_red = [0.45 0 0];
% For MB15 3Ma
 light_grey_color = [0.65 0.65 0.65];
 MB_3Ma_color_darker = light_grey_color +0.02;
 
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





%% Main Text Fig 2: d11B and pH timeseries


close all
clc

% figure
figure('OuterPosition', [813.44444 5.88889 864 925.33333]);

%%% (a) d11B (top panel) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot('Position',[0.095743215031315 0.697416974169742 0.8982 0.293094359515024])

  for i = 1:2
      if i == 1 % First plot EAST d11B 
          x = east;
          y = east_avgs;
          color_to_use = main_blue;
          dark_color_to_use = very_dark_blue;
      else 
          x = west; % Then plot WEST d11B
          y = west_avgs;
          color_to_use = main_red;
          dark_color_to_use = very_dark_red;
      end
      
      % Scatter plot normal points 
      e = errorbar(x(:,1), x(:,6), x(:,7), 'LineStyle', 'none', 'LineWidth', ...
          linewidth_normal_errorbars, 'HandleVisibility', 'off');
      e.Color = color_to_use;
      hold on
      scatter(x(:,1), x(:,6), size_normal_points, 'o', 'MarkerFaceColor', 'white', ...
          'MarkerEdgeColor', color_to_use, 'LineWidth', linewidth_normal_markers);

      
      
      % Scatter plot AVERAGES darker w/ line
      plot(y(:,1), y(:,6), '-o', 'Color', dark_color_to_use, ...
          'MarkerFaceColor', dark_color_to_use, 'MarkerSize', size_avg_points, ...
          'LineWidth', linewidth_avgs, 'HandleVisibility', 'off');
      e = errorbar(y(:,1), y(:,6), y(:,7), 'LineStyle', 'none', ...
          'HandleVisibility', 'off', 'LineWidth', linewidth_avgs_errorbars);
      e.Color = dark_color_to_use;
      e.CapSize = 12;
      
  end
    
  xlim([0 6.4])
  ylim([14 18.5])
  set(gca,'XMinorTick','on','YMinorTick','on')
  set(gca,'FontSize', 13)
  set(gca,'box','on')
  grid on
  ylabel(['\fontsize{17}\delta\fontsize{13}^1^1\fontsize{17}B \fontsize{12}(',char(8240),')'], 'FontWeight', 'bold');
  legend('East Pacific (ODP 846)', 'West Pacific (ODP 806)', 'FontSize', 11);
  
  
  

  
  
  
%%% (b) pH (bottom panel) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

subplot('Position', [0.095743215031315 0.16012 0.89823 0.46547]);
    
    
% NOW PLOT ESTIMATES OF MODERN pH
    % West Modern
      errorbar(0.01, west_mod_pH, west_mod_1sd, 'd', 'MarkerFaceColor', ...
          main_red, 'MarkerEdgeColor', 'none', ...
          'CapSize', 20, 'Color', main_red, ...
          'LineWidth', 3);   % face color main_red
      hold on
      % East Modern
      errorbar(0.01, east_mod_pH, east_mod_1sd, 'd', 'MarkerFaceColor', ...
          main_blue, 'MarkerEdgeColor', 'none', ... 
          'CapSize', 17, 'Color', main_blue, ...
          'LineWidth', 3);
     
      scatter(0.01, west_mod_pH, size_mod_points, 'diamond', 'MarkerFaceColor', ...
          main_red, 'MarkerEdgeColor', 'k', 'HandleVisibility', 'off');   % face color main_red
      scatter(0.01, east_mod_pH, size_mod_points, 'diamond', 'MarkerFaceColor', ...
          main_blue, 'MarkerEdgeColor', 'k', 'HandleVisibility', 'off');
      


    % 3Ma MB15 data - Eqb. site, Caribbean ODP site 999, G. ruber
      x = ThreeMa(:,1);
      y = ThreeMa(:,2);
      dy = ThreeMa(:,3);
      fill([x;flipud(x)],[y-dy;flipud(y+dy)],[0.86 .86 .86],'linestyle','none',...
          'HandleVisibility', 'off');
      
      plot(ThreeMa(:,1), ThreeMa(:,2), '-s', 'MarkerSize', size_3Ma_points, ...
          'MarkerFaceColor', MB_3Ma_color_darker, 'MarkerEdgeColor', ...
          MB_3Ma_color_darker, 'LineWidth', linewidth_3Ma, 'Color',...
          MB_3Ma_color_darker);
      

      
% PLOT FAKE POINT TO ADD EXTRA ITEM ON LEGEND: so that 2 items in first
  % column (modern east/west pH), 1 item in next colum (3Ma data), and
  % finally 2 items in last column (this study's pH and error east/west)
    scatter(0.01, 9.1, 'square', 'MarkerEdgeColor', 'none');      
      
      
% NOW PLOT THIS STUDY'S DATA      
      
  % FIRST FOR LOOP: PLOT NORMAL POINTS (2nd LOOP = AVERAGES)
    for i = 1:2
        if i == 2 % First plot EAST pH
            x = east;
            color_to_use = main_blue;
            dark_color_to_use = very_dark_blue;
        else 
            x = west; % Then plot WEST pH
            color_to_use = main_red;
            dark_color_to_use = very_dark_red;
        end
      
          % Then plot normal analytical uncertainty error bars on top of that
          e = errorbar(x(:,1), x(:,2), x(:,3), 'o', 'LineStyle', 'none', ...
              'LineWidth', linewidth_normal_errorbars, 'HandleVisibility', 'on');
          e.Color = color_to_use;
          
          % Then plot points
          scatter(x(:,1), x(:,2), size_normal_points, 'o',  'MarkerFaceColor', 'white', ...
              'MarkerEdgeColor', color_to_use, 'LineWidth', ...
              linewidth_normal_markers, 'HandleVisibility', 'off');
    end
    
  
    % SECOND FOR LOOP: PLOT AVERAGES
    for i = 1:2
        if i == 2 
            y = east_avgs;
            color_to_use = main_blue;
            dark_color_to_use = very_dark_blue;
        else 
            y = west_avgs;
            color_to_use = main_red;
            dark_color_to_use = very_dark_red;
        end
        
          % Plot average uncertainty error bars
          e = errorbar(y(:,1), y(:,2), y(:,3), 'o', 'LineStyle', 'none', ...
              'HandleVisibility', 'off', 'LineWidth', linewidth_avgs_errorbars);
          e.Color = dark_color_to_use;
          e.CapSize = 12;
          % Scatter plot averages darker w/ line
          plot(y(:,1), y(:,2), '-o', 'Color', dark_color_to_use, ...
             'MarkerFaceColor', dark_color_to_use, 'MarkerSize', size_avg_points, ...
             'LineWidth', linewidth_avgs, 'HandleVisibility', 'off');
               
    end
    
    
    
% More Aesthetics
  xlim([0 6.4])
  ylim([7.65 8.25])
  set(gca,'XMinorTick','on','YMinorTick','on')
  set(gca,'FontSize', 13)
  set(gca,'box','on')
  grid on
  xlabel('\fontsize{17}Age \fontsize{13}(Ma)', 'FontWeight', 'bold');
  ylabel('\fontsize{17}pH', 'FontWeight', 'bold');
  legend('Avg. Modern West (1\sigma)', 'Avg. Modern East (1\sigma)', ...
      '3Ma, Eqb. Site (95% CI)', ' ', ...
      '2\sigma', '2\sigma', ...
      'FontSize', 11.75, 'NumColumns', 3, 'Position', ...
      [0.095743215031315 0.01526 0.87996 0.066025]);
  legend boxoff
  
% Annotations ('a' and 'b' on panels)
annotation('textbox',[0.0102 0.955724443858724 0.035 0.036],...
    'VerticalAlignment','middle',...
    'String','a',...
    'HorizontalAlignment','center',...
    'FontWeight','bold',...
    'FontSize',14,...
    'FitBoxToText','off',...
    'EdgeColor', 'none');

annotation('textbox',...
    [0.0101725469728601 0.603853068002109 0.035 0.0359999999999999],...
    'VerticalAlignment','middle',...
    'String','b',...
    'HorizontalAlignment','center',...
    'FontWeight','bold',...
    'FontSize',14,...
    'FitBoxToText','off',...
    'EdgeColor', 'none');
 
  