% EXTENDED DATA 7abc: Mg/Ca SSTs from Different Treatments/Calibrations
% Madison Shankle
% 02-10-2021

% Plots SSTs derived from this study's Mg/Ca data, using different
% treatments of the Mg/Ca-SST calibration, namely: using the Orbulina
% universa species-specific calibraiton of Anand et al. (2003), correcting
% for Mg/Ca_sw (using the record of Fantle and DePaolo (2006) assuming 
% either a power-law relationship (Evans and Muller, 2021) or linear
% relationship between Mg/Ca_test and Mg/Ca_sw; and also deriving SSTs from
% Mg/Ca using the BAYMAG Bayesian calibration of Tierney et al. (2019).


% References:
%  Anand, P., Elderfield, H. & Conte, M. H. Calibration of Mg/Ca 
%    thermometry in planktonic 830 foraminifera from a sediment trap time 
%    series. Paleoceanography 18, (2003).
% Fantle, M. S. & DePaolo, D. J. Sr isotopes and pore fluid chemistry in 
%    carbonate sediment 808 of the Ontong Java Plateau: Calcite 
%    recrystallization rates and evidence for a rapid rise in 809 seawater 
%    Mg over the last 10 million years. Geochim. Cosmochim. Acta 70, 
%    3883–3904 810 (2006).
%  Evans, D. & Müller, W. Deep time foraminifera Mg/Ca paleothermometry: 
%    Nonlinear 825 correction for secular change in seawater Mg/Ca. 
%    Paleoceanography 27, (2012).
%  Tierney, J. E., Malevich, S. B., Gray, W., Vetter, L. & Thirumalai, K. 
%    Bayesian calibration 827 of the Mg/Ca paleothermometer in planktic 
%    foraminifera. Paleoceanogr. Paleoclimatology 828 (2019).



%% LOAD IN DATA
% For more data, see pg. 37 of grey notebook

clear all
close all 
clc

east_sst = xlsread('ED7abc_Shankle_east_SSTs_diff_MgCa.xls');
west_sst = xlsread('ED7abc_Shankle_west_SSTs_diff_MgCa.xls');

% Notes^ (all Age (Ma) or SST (degC) unless stated otherwise):
%  East: 
%   (1,2)  Wara '05 Mg/Ca (ODP847) (Dekens '02 calbrn). Not corr. for sw Mg/Ca
%   (3,4)  O'Brien '14 sea-water corr. of Wara data. TEX86-reconstructed sw Mg/Ca
%   (5,6,7,8) BAYMAG Wara Mg/Ca (847) Age, SST, (+) error, (-) error. Error from 95% CI (2.5 and 97.5% limits)
%   (9,10,11) Lawrence '06 (846) Uk37. Age, SST, error (1.1, Conte '06 calbrn). In Zhang '14. 
%   (12,13,14) Zhang Pagani '14 (850) TEX86. Age, SST, error (2.5, Kim '10 calbrn).
%   (15,16,17,18,19) My Mg/Ca data. Age, (16) Linear, (17) Power (T.sacc), (18) Neg. Error, (19) Pos. Error
%   (20, 21, 22) BAYMAG applied to my Mg/Ca data by H. Ford. BAYMAG median (20), 2.5% CI error bar size (21), 97.5% CI error bar size (22)

%  West (all 806): 
%   (1,2)  Wara '05 Mg/Ca (Dekens '02 calbrn). Not corr. for sw Mg/Ca
%   (3,4)  O'Brien '14 sea-water corr. of Wara data. TEX86-reconstructed sw Mg/Ca
%   (5,6,7,8) BAYMAG Wara Mg/Ca (847) Age, SST, (+) error, (-) error. Error from 95% CI (2.5 and 97.5% limits)
%   (9,10,11) Pagani '06 Uk37. Age, SST, error (1.1, Conte '06 calbrn). In Zhang '14. *
%   (12,13,14) Zhang Pagani '14 TEX86. Age, SST, error (2.5, Kim '10 calbrn).
%   (15,16,17,18,19) My Mg/Ca data. Age, (16) Linear, (17) Power (T.sacc), (18) Neg. Error, (19) Pos. Error
%   (20, 21, 22) BAYMAG applied to my Mg/Ca data by H. Ford. BAYMAG median (20), 2.5% CI error bar size (21), 97.5% CI error bar size (22)

% * Uk37 data saturated at 28.5C (Conte et al., 2006)(only reaches this
%    in West, East record doesn't reach this saturation point in the Pliocene
% Horiz. line plotted to show that saturation temp.




%% Aesthetics for Plot

 east_color = [0 0.2970 0.6510];   % Classic blue
 west_color = [0.7 0.175 0.008];   % Classic red
 
 very_dark_blue = [0 0 0.35];
 very_dark_red = [0.45 0 0];

 very_light_blue = [0.85 0.95 0.99];
 very_light_red = [1 0.85 0.85];
 
 main_red = [0.76 0 0.22];
 main_blue = [0.11 0.25 0.88];
 

 
 mkr_size = 60;
 edgelinewidth_BAYMAG = 2;
 linewidth_BAYMAGerror = 2.25;
 linewidth_thisstudy = 2.25;
 linewidth_thisstudyError = 2.25;

 thisstudy_mkr_size = 120;



 
%% Plotting

figure

horz_offset = 0.015;

for i = 1:3
    if i == 1
        subplot(131)
        title_string = '1Ma';
    else if i == 2
            subplot(132)
            title_string = '3Ma';
        else if i == 3
                subplot(133)
                title_string = '6Ma';
            end
        end
    end

% East Mg/Ca (Power sw correction)
      e = errorbar(east_sst(:,15) - horz_offset, east_sst(:,17), east_sst(:,18), east_sst(:,19), ...
          'LineStyle', 'none', 'LineWidth', linewidth_thisstudyError, ...
          'HandleVisibility', 'off');
      hold on
      e.Color = east_color;
      e.CapSize = 0;   
      scatter(east_sst(:,15) - horz_offset, east_sst(:,17), thisstudy_mkr_size, 's', ...
          'LineWidth', linewidth_thisstudy, 'MarkerEdgeColor', east_color, ...
          'MarkerFaceColor', very_light_blue);
   
% West Mg/Ca (Power sw correction)
      e = errorbar(west_sst(:,15) - horz_offset, west_sst(:,17), west_sst(:,18), west_sst(:,19), ...
          'LineStyle', 'none', 'LineWidth', linewidth_thisstudyError, ...
          'HandleVisibility', 'off');
      e.Color = west_color;
      e.CapSize = 0;      
      scatter(west_sst(:,15) - horz_offset, west_sst(:,17), thisstudy_mkr_size, 's', ...
          'LineWidth', linewidth_thisstudy, 'MarkerEdgeColor', west_color, ...
          'MarkerFaceColor', very_light_red);

      
      
% THIS STUDY'S DATA WITH NORMAL DARK COLORS      
% East Mg/Ca (Linear sw correction)
      e = errorbar(east_sst(:,15), east_sst(:,16), east_sst(:,18), east_sst(:,19), ...
          'LineStyle', 'none', 'LineWidth', linewidth_thisstudyError, ...
          'HandleVisibility', 'off');
      e.Color = very_dark_blue;
      e.CapSize = 0;     
      scatter(east_sst(:,15), east_sst(:,16), thisstudy_mkr_size, 's', ...
          'LineWidth', linewidth_thisstudy, 'MarkerEdgeColor', very_dark_blue, ...
          'MarkerFaceColor', main_blue); 
       
% West Mg/Ca (Linear sw correction)
      e = errorbar(west_sst(:,15), west_sst(:,16), west_sst(:,18), west_sst(:,19), ...
          'LineStyle', 'none', 'LineWidth', linewidth_thisstudyError, ...
          'HandleVisibility', 'off');
      e.Color = very_dark_red + [0.15 0 0];
      e.CapSize = 0;   
      scatter(west_sst(:,15), west_sst(:,16), thisstudy_mkr_size, 's', ...
          'LineWidth', linewidth_thisstudy, 'MarkerEdgeColor', very_dark_red + [0.15 0 0], ...
          'MarkerFaceColor', main_red + [0.09 0 0.09]);      

      

% East Mg/Ca (BAYMAG on this study's data)
      scatter(east_sst(:,15) + horz_offset, east_sst(:,20), mkr_size, 'o', ...
          'LineWidth', edgelinewidth_BAYMAG, 'MarkerEdgeColor', very_dark_blue, ...
          'MarkerFaceColor', 'none');
      hold on
      e = errorbar(east_sst(:,15) + horz_offset, east_sst(:,20), east_sst(:,21), east_sst(:,22), ...
          'LineStyle', 'none', 'LineWidth', linewidth_BAYMAGerror, ...
          'HandleVisibility', 'off');
      e.Color = very_dark_blue;
      e.CapSize = 0;      
      
% West Mg/Ca (BAYMAG on this study's data)
      scatter(west_sst(:,15) + horz_offset, west_sst(:,20), mkr_size, 'o', ...
          'LineWidth', edgelinewidth_BAYMAG, 'MarkerEdgeColor', very_dark_red, ...
          'MarkerFaceColor', 'none');
      
      e = errorbar(west_sst(:,15) + horz_offset, west_sst(:,20), west_sst(:,21), west_sst(:,22), ...
          'LineStyle', 'none', 'LineWidth', linewidth_BAYMAGerror, ...
          'HandleVisibility', 'off');
      e.Color = very_dark_red;
      e.CapSize = 0;           
      
      
  % Aesthetics
  
  xlabel('\fontsize{19}Age \fontsize{15}(Ma)', 'FontWeight', 'bold');


    if i == 1
        xlim([0.7 1.2])
        ylabel('\fontsize{19}SST \fontsize{15}(\circC)', 'FontWeight', 'bold')
    else if i == 2
            xlim([2.6 3.1])
            legend('Mg/Ca East (Power)', 'Mg/Ca West (Power)', ...
                'Mg/Ca East (Linear)', 'Mg/Ca West (Linear)',...
                'Mg/Ca East (BAYMAG)', 'Mg/Ca West (BAYMAG)', ...
                'NumColumns', 3, 'Location', 'southeast');
        else if i == 3
                xlim([5.7 6.2])
                
            end
        end
    end
    
    ylim([18 45])
    set(gca,'XMinorTick','on','YMinorTick','on')
    set(gca,'FontSize', 13)
    set(gca,'box','on')
    grid on
    title(title_string, 'FontSize', 18)
    
end

