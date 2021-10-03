% EXTENDED DATA 7def: pH from Different SST Proxy Records
% Madison Shankle
% 02-10-2021

% Plots pH derived from different SST proxy records: UK37 (Lawrence et al., 
% 2006; Pagani et al., 2010), TEX86 (Zhang et al., 2014), as well as this 
% study's Mg/Ca data uding the O. universa-specific calibration of Anand et
% al. (2003) and correcting for Mg/Ca_sw using the Mg/Ca_sw record of
% Fantle and DePaolo (2006) assuming both a linear and power-law (Evans and
% Muller, 2012) relationship between Mg/Ca_test and Mg/Ca_sw.


% References:
% Lawrence, K. T., Liu, Z. & Herbert, T. D. Evolution of the eastern 
%    tropical Pacific through Plio-Pleistocene glaciation. Science 312, 
%    79–83 (2006).
% Pagani, M., Liu, Z., LaRiviere, J. & Ravelo, A. C. High Earth-system 
%    climate sensitivity determined from Pliocene carbon dioxide 
%    concentrations. Nat. Geosci. 3, 27–30 (2010).
% Zhang, Y. G., Pagani, M. & Liu, Z. A 12-Million-Year Temperature History 
%    of the Tropical Pacific Ocean. Science 344, 84–88 (2014).
%  Anand, P., Elderfield, H. & Conte, M. H. Calibration of Mg/Ca 
%    thermometry in planktonic foraminifera from a sediment trap time 
%    series. Paleoceanography 18, (2003).
% Fantle, M. S. & DePaolo, D. J. Sr isotopes and pore fluid chemistry in 
%    carbonate sediment of the Ontong Java Plateau: Calcite 
%    recrystallization rates and evidence for a rapid rise in seawater 
%    Mg over the last 10 million years. Geochim. Cosmochim. Acta 70, 
%    3883–3904 (2006).
%  Evans, D. & Müller, W. Deep time foraminifera Mg/Ca paleothermometry: 
%    Nonlinear correction for secular change in seawater Mg/Ca. 
%    Paleoceanography 27, (2012).
%  Tierney, J. E., Malevich, S. B., Gray, W., Vetter, L. & Thirumalai, K. 
%    Bayesian calibration of the Mg/Ca paleothermometer in planktic 
%    foraminifera. Paleoceanogr. Paleoclimatology (2019).


%% LOAD IN DATA
% Col 1: Age [Ma]
% Col 2: pH from TEX86 (+/-2C)
% IGNORE ALL-SPECIES CALBRN --> Col 3: pH from Mg/Ca (+/-2C) All-Species Calibration, Linear SW Correction
% Col 4: pH from Mg/Ca (+/-2C) OrbUniversa Calibration, Linear SW Correction
% IGNORE ALL-SPECIES CALBRN --> Col 5: pH from Mg/Ca (+/-2C) All-Species Calibration, Power SW Correction
% Col 6: pH from Mg/Ca (+/-2C) OrbUniversa Calibration, Power SW Correction
% Col 7: pH from BAYMAG Mg/Ca (+/-2)
% !!! UPDATE !!!: Col8: pH from Uk37 (+/-2C in monte carlo T error)

% First 12 rows are WEST (1:12) (159E), last 13 are EAST (13:25) (-90E)

% Note: power uses non-linearity coefficient calibrated for G. sacculifer
% (H=0.41, see Evans et al., 2014 and references w/in)

close all
clear all
clc


pH_array = xlsread('ED7def_compilation_pH_diff_SSTs.xls');
twosd_array = xlsread('ED7def_compilation_2sdpH_diff_SSTs.xls');

west_indices = [1:12];
east_indices = [13:24];


%% AESTHETICS


 uk_east_color = [0.85 0.95 0.99] -0.2;     % very_light_blue
 uk_west_color = [1 0.85 0.85] -0.2;        % very_light_red
 
 TEX_east_color = [0.25 0.55 0.7];  % Teal-ish faded blue
 TEX_west_color = [0.8 0.2 0.2];    % "Faded" red
 
 MgCa_lin_east_color = [0 0 1];     % Bright blue  
 MgCa_lin_west_color = [1 0 0];     % Bright red 
 
 MgCa_pow_east_color = [0.11 0.25 0.50];     % Dark blue
 MgCa_pow_west_color = [0.56 0 0.22];        % Dark red


linewidth_error = 1.5;

marker_size = 50;

offset = 0.006;

errorcapsize = 5;



%% PLOTTING

figure('Position', [35 220 1690 630]);

panel_bottom = 0.2541; 
panel_width = 0.2842;
panel_height = 0.6709;
left_panel1 = 0.0462;
left_panel2 = 0.3689;
left_panel3 = 0.6916;

for i = 1:3
    if i == 1
        subplot('Position',[left_panel1 panel_bottom panel_width panel_height]);
        title_string = '1Ma';
    else if i == 2
            subplot('Position', [left_panel2 panel_bottom panel_width panel_height]);
            title_string = '3Ma';
        else if i == 3
                subplot('Position',[left_panel3 panel_bottom panel_width panel_height]); % Left Bottom Width Height
                title_string = '6Ma';
            end
        end
    end
    
    % East, Uk37                                        col 8: Uk37
      scatter(pH_array(east_indices, 1)-(2*offset), pH_array(east_indices, 8), marker_size*1.5, 'x', 'MarkerEdgeColor',...
          uk_east_color, 'LineWidth', 1.25)
      hold on
      e = errorbar(pH_array(east_indices, 1)-(2*offset), pH_array(east_indices, 8), twosd_array(east_indices, 8), ...
          'LineStyle', 'none', 'LineWidth', linewidth_error, 'HandleVisibility', 'off');      
      e.Color = uk_east_color;
      e.CapSize = errorcapsize;
    
    % East, TEX86       % col 1: age                    col 2: TEX86
      scatter(pH_array(east_indices, 1)-offset, pH_array(east_indices, 2), marker_size, '*', 'MarkerEdgeColor',...
          TEX_east_color, 'LineWidth', 1.25)
      hold on
      e = errorbar(pH_array(east_indices, 1)-offset, pH_array(east_indices, 2), twosd_array(east_indices, 2), ...
          'LineStyle', 'none', 'LineWidth', linewidth_error, 'HandleVisibility', 'off');      
      e.Color = TEX_east_color;
      e.CapSize = errorcapsize;
      
    % East, LinOrb - Mg/Ca ORB. Calb, Linear SW Corrn   col 4: Mg/Ca linear
      e = errorbar(pH_array(east_indices, 1), pH_array(east_indices, 4), twosd_array(east_indices, 4), ...
          'LineStyle', 'none', 'LineWidth', linewidth_error, 'HandleVisibility', 'off');      
      e.Color = MgCa_lin_east_color;
      e.CapSize = errorcapsize;
      hold on
      scatter(pH_array(east_indices, 1), pH_array(east_indices, 4), marker_size, 'o', 'MarkerEdgeColor', ...
          MgCa_lin_east_color, 'MarkerFaceColor', MgCa_lin_east_color, 'LineWidth', 0.75)

    % East, PowOrb - Mg/Ca Orb Calb, POWER SW Corrn     col 6: Mg/Ca power
      e = errorbar(pH_array(east_indices, 1)+offset, pH_array(east_indices, 6), twosd_array(east_indices, 6), ...
          'LineStyle', 'none', 'LineWidth', linewidth_error, 'HandleVisibility', 'off');      
      e.Color = MgCa_pow_east_color;
      e.CapSize = errorcapsize;
      scatter(pH_array(east_indices, 1)+offset, pH_array(east_indices, 6), marker_size, '^', 'MarkerEdgeColor',...
          MgCa_pow_east_color, 'MarkerFaceColor', MgCa_pow_east_color, 'LineWidth', 0.75)
 
  
      
      
    % West, Uk37                                        col 8: Uk37
      scatter(pH_array(west_indices, 1)-(2*offset), pH_array(west_indices, 8), marker_size*1.5, 'x', 'MarkerEdgeColor',...
          uk_west_color, 'LineWidth', 1.25)
      hold on
      e = errorbar(pH_array(west_indices, 1)-(2*offset), pH_array(west_indices, 8), twosd_array(west_indices, 8), ...
          'LineStyle', 'none', 'LineWidth', linewidth_error, 'HandleVisibility', 'off');      
      e.Color = uk_west_color;
      e.CapSize = errorcapsize;  
      
    % West, TEX86
      scatter(pH_array(west_indices, 1)-offset, pH_array(west_indices, 2), marker_size, '*', 'MarkerEdgeColor',...
          TEX_west_color, 'LineWidth', 1.25)
      e = errorbar(pH_array(west_indices, 1)-offset, pH_array(west_indices, 2), twosd_array(west_indices, 2), ...
          'LineStyle', 'none', 'LineWidth', linewidth_error, 'HandleVisibility', 'off');      
      e.Color = TEX_west_color;
      e.CapSize = errorcapsize;
      
    % West, LinOrb - Mg/Ca ORB. Calb, Linear SW Corrn
      e = errorbar(pH_array(west_indices, 1), pH_array(west_indices, 4), twosd_array(west_indices, 4), ...
          'LineStyle', 'none', 'LineWidth', linewidth_error, 'HandleVisibility', 'off');      
      e.Color = MgCa_lin_west_color;
      e.CapSize = errorcapsize;
      hold on
      scatter(pH_array(west_indices, 1), pH_array(west_indices, 4), marker_size, 'o', 'MarkerEdgeColor',...
          MgCa_lin_west_color, 'MarkerFaceColor', MgCa_lin_west_color, 'LineWidth', 0.75)

    % West, PowOrb - Mg/Ca Orb Calb, POWER SW Corrn
      e = errorbar(pH_array(west_indices, 1)+offset, pH_array(west_indices, 6), twosd_array(west_indices, 6), ...
          'LineStyle', 'none', 'LineWidth', linewidth_error, 'HandleVisibility', 'off');      
      e.Color = MgCa_pow_west_color;
      e.CapSize = errorcapsize;
      scatter(pH_array(west_indices, 1)+offset, pH_array(west_indices, 6), marker_size, '^', 'MarkerEdgeColor',...
          MgCa_pow_west_color, 'MarkerFaceColor', MgCa_pow_west_color, 'LineWidth', 0.75)
 
  

    if i == 1
        xlim([0.75 1.15]);
        ylabel('\fontsize{20}pH', 'FontWeight', 'bold');
    else if i == 2
            xlim([2.65 3.05]);
            legend('U^{k''}_{37}', 'TEX_{86}', 'Mg/Ca Linear SW Correction','Mg/Ca Power SW Correction', ...
                    'FontSize', 11.75, 'NumColumns', 4, 'Position',[0.312259171597633 0.0915 0.4003 0.0558])
        else if i == 3
                xlim([5.75 6.1]);
                
            end
        end
    end
    
    ylim([7.75 8.2])
    set(gca,'XMinorTick','on','YMinorTick','on')
    set(gca,'FontSize', 12)
    set(gca,'box','on')
    grid on
    xlabel('\fontsize{15}Age \fontsize{11}(Ma)', 'FontWeight', 'bold');
    title(title_string, 'FontSize', 18)
    
end

letteroffset= 0.002;
  
annotation('textbox',...
    [left_panel1+letteroffset 0.937349228611501 0.018 0.0499999999999999],...
    'VerticalAlignment','middle',...
    'String','d',...
    'HorizontalAlignment','center',...
    'FontWeight','bold',...
    'FontSize',18,...
    'FitBoxToText','off',...
    'BackgroundColor','none', ...
    'EdgeColor', 'none');
  
annotation('textbox',...
    [left_panel2+letteroffset 0.937349228611501 0.018 0.0499999999999999],...
    'VerticalAlignment','middle',...
    'String','e',...
    'HorizontalAlignment','center',...
    'FontWeight','bold',...
    'FontSize',18,...
    'FitBoxToText','off',...
    'BackgroundColor','none', ...
    'EdgeColor', 'none');

annotation('textbox',...
    [left_panel3+letteroffset 0.937349228611501 0.018 0.0499999999999999],...
    'VerticalAlignment','middle',...
    'String','f',...
    'HorizontalAlignment','center',...
    'FontWeight','bold',...
    'FontSize',18,...
    'FitBoxToText','off',...
    'BackgroundColor','none', ...
    'EdgeColor', 'none');

