% EXTENDED DATA 9ab: Compilation of SSTs records from literature, different proxies
% Madison Shankle
% 03-10-2021

% Plots SST records from different proxies in past literaure.
%  - Mg/Ca from T. sacculifer (Wara et al., 2005) from the species-
%      specific calibration of (Dekens et al., 200X) corrected for Mg/Ca_sw
%      by O'Brien et al. (2014) assuming a linear relationship between 
%      Mg/Ca_test and Mg/Ca_sw, and with the Bayesian calibration of 
%      Tierney et al. (2019) (BAYMAG).
%  - Uk37 data from Liu et al. (2004) and Lawrence et al. (2006) using 
%      the global ocean annual-mean calibration of Muller et al. (1998).
%  - Mg/Ca from O. universa (this study), with the species-specific
%      calibration of Anand et al (2003) corrected for Mg/Ca_sw using the
%      Mg/Ca_sw record of Fantle & DePaolo (2006) and assuming a linear
%      relationship between Mg/Ca_test and Mg/Ca_sw.
%  - TEX86 data Zhang et al. (2014) using the calibraiton of Kim et al. (2010).

% References:
% Wara, M. W., Ravelo, A. C. & Delaney, M. L. Permanent El Niño-like 
%   conditions during the Pliocene warm period. Science 309, 758–761 (2005).
% Dekens, P. S., Lea, D. W., Pak, D. K. & Spero, H. J. Core top calibration 
%   of Mg/Ca in tropical foraminifera: Refining paleotemperature estimation. 
%   Geochemistry, Geophys. Geosystems 3, 1–29 (2002).
% O’Brien, C. L. et al. High sea surface temperatures in tropical warm pools 
%   during the Pliocene. Nat. Geosci. 7, 606–611 (2014).
% Tierney, J. E., Malevich, S. B., Gray, W., Vetter, L. & Thirumalai, K. 
%   Bayesian calibration of the Mg/Ca paleothermometer in planktic 
%   foraminifera. Paleoceanogr. Paleoclimatology (2019).
% Lawrence, K. T., Liu, Z. & Herbert, T. D. Evolution of the eastern tropical 
%   Pacific through Plio-Pleistocene glaciation. Science 312, 79–83 (2006).
% Liu, Z. & Herbert, T. D. High-latitude influence on the eastern equatorial 
%   Pacific climate in the early Pleistocene epoch. Nature 427, 720–723 
%   (2004).
% Müller, P. J., Kirst, G., Ruhland, G., Von Storch, I. & Rosell-Melé, A. 
%   Calibration of the alkenone paleotemperature index U37K′ based on core-
%   tops from the eastern South Atlantic and the global ocean (60° N-60° S). 
%   Geochim. Cosmochim. Acta 62, 1757–1772 (1998).
% Anand, P., Elderfield, H. & Conte, M. H. Calibration of Mg/Ca thermometry 
%   in planktonic foraminifera from a sediment trap time series. 
%   Paleoceanography 18, (2003).
% Fantle, M. S. & DePaolo, D. J. Sr isotopes and pore fluid chemistry in 
%   carbonate sediment of the Ontong Java Plateau: Calcite recrystallization 
%   rates and evidence for a rapid rise in seawater Mg over the last 10 
%   million years. Geochim. Cosmochim. Acta 70, 3883–3904 (2006). 
% Zhang, Y. G., Pagani, M. & Liu, Z. A 12-Million-Year Temperature History 
%   of the Tropical Pacific Ocean. Science 344, 84–88 (2014).
% Kim, J.-H. et al. New indices and calibrations derived from the distribution 
%   of crenarchaeal isoprenoid tetraether lipids: Implications for past sea 
%   surface temperature reconstructions. Geochim. Cosmochim. Acta 74, 4639–
%   4654 (2010).



%% LOAD IN DATA

clear all
close all 
clc

east_sst = xlsread('ED9ab_Shankle_east_SSTs_compilation.xls');
west_sst = xlsread('ED9ab_Shankle_west_SSTs_compilation.xls');

% Notes^ (all Age, SST unless stated otherwise):
%  East: 
%   (1,2)  Wara '05 Mg/Ca (ODP847) (Dekens '02 calbrn). Don't use b/c not corr. for sw Mg/Ca
%   (3,4)  O'Brien '14 sea-water corr. of Wara data. TEX86-reconstructed sw Mg/Ca
%   (5,6,7,8) Ford BAYMAG Mg/Ca (847) Age, SST, (+) error, (-) error. Error from 95% CI (2.5 and 97.5% limits)
%   (9,10,11) Lawrence '06 (846) Uk37. Age, SST, error (1.1, Conte '06 calbrn). In Zhang '14. 
%   (12,13,14) Zhang Pagani '14 (850) TEX86. Age, SST, error (2.5, Kim '10 calbrn).
%   (15,16,17,18,19) My Mg/Ca data. Age, (16) Linear, (17) Power (T.sacc), (18) Neg. Error, (19) Pos. Error
%   (20, 21, 22) BAYMAG applied to my Mg/Ca data by H. Ford. BAYMAG median (20), 2.5% CI error bar size (21), 97.5% CI error bar size (22)

%  West (all 806): 
%   (1,2)  Wara '05 Mg/Ca (Dekens '02 calbrn). Don't use b/c not corr. for sw Mg/Ca
%   (3,4)  O'Brien '14 sea-water corr. of Wara data. TEX86-reconstructed sw Mg/Ca
%   (5,6,7,8) Ford BAYMAG Mg/Ca (847) Age, SST, (+) error, (-) error. Error from 95% CI (2.5 and 97.5% limits)
%   (9,10,11) Pagani '06 Uk37. Age, SST, error (1.1, Conte '06 calbrn). In Zhang '14. *
%   (12,13,14) Zhang Pagani '14 TEX86. Age, SST, error (2.5, Kim '10 calbrn).
%   (15,16,17,18,19) My Mg/Ca data. Age, (16) Linear, (17) Power (T.sacc), (18) Neg. Error, (19) Pos. Error
%   (20, 21, 22) BAYMAG applied to my Mg/Ca data by H. Ford. BAYMAG median (20), 2.5% CI error bar size (21), 97.5% CI error bar size (22)

% * Uk37 data saturated at 28.5C (Conte et al., 2006)(only reaches this
%    in West, East record doesn't reach this saturation point in the Pliocene
% Horiz. line plotted to show that saturation temp.




%% AESTHETICS

% COLORS
 BAYMAG_east_color = [0 0.2970 0.6510];   % Classic blue
 BAYMAG_west_color = [0.7 0.175 0.008];   % Classic red
 
 MgCa_west_color = [1 0 0];         % Bright Red
 MgCa_east_color = [0.18 0.87 0.99];% Bright Blue
 
 Uk37_west_color = [0.55 0 0];      % Dark Red
 Uk37_east_color = [0 0.2 0.5];     % Dark Blue
 
 TEX86_east_color = [0.25 0.55 0.7];% Teal-ish faded blue
 TEX86_west_color = [0.7 0.2 0.2];  % "Faded" red
 
 very_light_blue = [0.85 0.95 0.99];
 very_light_red = [1 0.85 0.85];

 
 transparency_Uk37_west = 0.5;
 transparency_Uk37_east = 0.7;
 transparency_BAYMAG_west = 0.25; 
 transparency_BAYMAG_east = 0.25;
 transparency_TEX86 = 0.5;
 
 linewidth_ThisStudy = 2.25;
 linewidth_ErrorThisStudy = 2.25;

 MyData_mkr_size = 120;
 linewidth_MgCa = 1;
 linewidth_BAYMAG = 1.35;
 linewidth_Uk37 = 0.75;
 linewidth_TEX86 = 1.5;


%% PLOTTING

figure

% Panel (a)

% Mg/Ca: Wara/OBrien (806/846), Ford (806/847), and this study [LinOrb and BAYMAG]
subplot('Position', [0.130260416666667,0.554433131936931,0.775,0.4346])        


% East Mg/Ca BAYMAG (847, Ford)
      x = east_sst(1:299,5);    % 299 cuts off NaN values
      y = east_sst(1:299,6);
      dy_neg = east_sst(1:299,7);
      dy_pos = east_sst(1:299,8);
      f = fill([x;flipud(x)],[y-dy_neg;flipud(y+dy_pos)],BAYMAG_east_color,...
          'linestyle','none', 'HandleVisibility', 'on');
      set(f,'facealpha',transparency_BAYMAG_east)
      hold on
      plot2 = plot(east_sst(:,5), east_sst(:,6), 'Color', BAYMAG_east_color,...
          'LineWidth', linewidth_BAYMAG+.2, 'HandleVisibility', 'off'); 

% West Mg/Ca BAYMAG (806, Ford)
      x = west_sst(1:373,5);    % 373 cuts off NaN values
      y = west_sst(1:373,6);
      dy_neg = west_sst(1:373,7);
      dy_pos = west_sst(1:373,8);
      f = fill([x;flipud(x)],[y-dy_neg;flipud(y+dy_pos)],BAYMAG_west_color,...
          'linestyle','none', 'HandleVisibility', 'on');
      set(f,'facealpha',transparency_BAYMAG_west)
      hold on
      plot2 = plot(west_sst(:,5), west_sst(:,6), 'Color', BAYMAG_west_color,...
          'LineWidth', linewidth_BAYMAG, 'HandleVisibility', 'off');       
      
      
      
      
% East Uk37 (Pagani '10)
      x = east_sst(:,9);
      y = east_sst(:,10);
      dy = east_sst(:,11);
      f = fill([x;flipud(x)],[y-dy;flipud(y+dy)],Uk37_east_color,...
          'linestyle','none', 'HandleVisibility', 'on');
      set(f,'facealpha',transparency_Uk37_east)
      hold on
      plot1 = plot(east_sst(:,9), east_sst(:,10), 'Color', Uk37_east_color,...
          'LineWidth', linewidth_Uk37, 'HandleVisibility', 'off');       

% West Uk37 (Liu'04, Lawrence'06)
      x = west_sst(1:54,9);     % 1:54 removes NaN values
      y = west_sst(1:54,10);
      dy = west_sst(1:54,11);
      f = fill([x;flipud(x)],[y-dy;flipud(y+dy)],Uk37_west_color,...
          'linestyle','none', 'HandleVisibility', 'on');
      set(f,'facealpha',transparency_Uk37_west)
      hold on      
      plot1 = plot(west_sst(:,9), west_sst(:,10), 'Color', Uk37_west_color,...
          'LineWidth', linewidth_Uk37, 'HandleVisibility', 'off'); 
      

      
      
% East Mg/Ca (846, O'Brien '14)
      plot1 = plot(east_sst(:,3), east_sst(:,4), '-', 'Color', MgCa_east_color,...
          'LineWidth', linewidth_MgCa);      
      
% West Mg/Ca (806, O'Brien '14)
      plot1 = plot(west_sst(:,3), west_sst(:,4), '-', 'Color', MgCa_west_color,...
          'LineWidth', linewidth_MgCa);


      

      
      
% This Study
% East Mg/Ca (Linear sw correction)
      e = errorbar(east_sst(:,15), east_sst(:,16), east_sst(:,18), east_sst(:,19), ...
          'LineStyle', 'none', 'LineWidth', linewidth_ErrorThisStudy, ...
          'HandleVisibility', 'off');
      e.Color = BAYMAG_east_color;
      e.CapSize = 0;     
      scatter(east_sst(:,15), east_sst(:,16), MyData_mkr_size, 's', ...
          'LineWidth', linewidth_ThisStudy, 'MarkerEdgeColor', BAYMAG_east_color, ...
          'MarkerFaceColor', very_light_blue); 
      
% West Mg/Ca (Linear sw correction)
      e = errorbar(west_sst(:,15), west_sst(:,16), west_sst(:,18), west_sst(:,19), ...
          'LineStyle', 'none', 'LineWidth', linewidth_ErrorThisStudy, ...
          'HandleVisibility', 'off');
      e.Color = BAYMAG_west_color;
      e.CapSize = 0;   
      scatter(west_sst(:,15), west_sst(:,16), MyData_mkr_size, 's', ...
          'LineWidth', linewidth_ThisStudy, 'MarkerEdgeColor', BAYMAG_west_color, ...
          'MarkerFaceColor', very_light_red);
      
      
      
% Plot reference line for saturation of Uk37 (28.5C)
      yline(28.5, '--', 'LineWidth', 1.5);
      hold on
      
      
  xlim([-0.1 6.3])
  set(gca,'XMinorTick','on','YMinorTick','on')
  set(gca,'FontSize', 13)
  set(gca,'box','on')
  
  ylim([16.5 36.5])      

  ylabel('\fontsize{19}SST \fontsize{15}(\circC)', 'FontWeight', 'bold');

  legend('Mg/Ca (BAYMAG) East', 'Mg/Ca (BAYMAG) West', 'Uk37 East',  'Uk37 West', 'Mg/Ca (Linear) East', ...
      'Mg/Ca (Linear) West', 'Mg/Ca East (Linear, this study)', 'Mg/Ca West (Linear, this study)', ...
      'NumColumns', 4, 'Location', 'southeast');

  
  

% PANEL (b) - TEX86
subplot('Position', [0.13,0.0724,0.775,0.4346]) 

% East TEX86 (Zhang '14)
      x = east_sst(1:47,12);     % 1:47 removes NaN values
      y = east_sst(1:47,13);
      dy = east_sst(1:47,14);
      f = fill([x;flipud(x)],[y-dy;flipud(y+dy)],TEX86_east_color,...
          'linestyle','none', 'HandleVisibility', 'on');
      set(f,'facealpha',transparency_TEX86)
      hold on      
      plot1 = plot(east_sst(:,12), east_sst(:,13), 'Color', TEX86_east_color,...
          'LineWidth', linewidth_TEX86, 'HandleVisibility', 'off');    

% West TEX86 (Zhang '14)      
      x = west_sst(1:57,12);     % 1:57 removes NaN values
      y = west_sst(1:57,13);
      dy = west_sst(1:57,14);
      f = fill([x;flipud(x)],[y-dy;flipud(y+dy)],TEX86_west_color,...
          'linestyle','none', 'HandleVisibility', 'on');
      set(f,'facealpha',transparency_TEX86)
      hold on      
      plot1 = plot(west_sst(:,12), west_sst(:,13), 'Color', TEX86_west_color,...
          'LineWidth', linewidth_TEX86, 'HandleVisibility', 'off');    
      

  xlim([-0.1 6.3])
  set(gca,'XMinorTick','on','YMinorTick','on')
  set(gca,'FontSize', 13)
  set(gca,'box','on')
  
  ylim([16.5 36.5])      

  ylabel('\fontsize{19}SST \fontsize{15}(\circC)', 'FontWeight', 'bold');
  
  xlabel('\fontsize{19}Age \fontsize{15}(Ma)', 'FontWeight', 'bold');

  
  legend('TEX86 East', 'TEX86 West', 'Location', 'southeast');
      
  
annotation('textbox',[0.087 0.944 0.019 0.039],...
    'VerticalAlignment','middle',...
    'String',{'a'},...
    'HorizontalAlignment','center',...
    'FontWeight','bold',...
    'FontSize',14,...
    'FitBoxToText','off',...
    'BackgroundColor',[1 1 1]);  

annotation('textbox',...
    [0.087 0.463994772608468 0.019 0.0389999999999999],...
    'VerticalAlignment','middle',...
    'String','b',...
    'HorizontalAlignment','center',...
    'FontWeight','bold',...
    'FontSize',14,...
    'FitBoxToText','off',...
    'BackgroundColor',[1 1 1]);
