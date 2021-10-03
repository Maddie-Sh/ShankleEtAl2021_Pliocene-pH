% EXTENDED DATA 8: Different Mg/Ca_sw Records and Their Effect on SSTs & pH
% Madison Shankle
% 02-10-2021

% Plots (a) different Mg/Ca_sw records (O'Brien et al., 2014; Evans et al.,
% 2016; Tierney et al., 2019; Fantle & DePaolo, 2006; Coggon et al., 2010;
% Rausch et al., 2013; Lowenstein et al., 2001; and Horita et al., 2002);
% (b) SSTs derived from Wara et al. (2005) T. sacculifer Mg/Ca data using
%   these different Mg/Ca_sw records, 
% (c) SSTs derived from this study's O. universa Mg/Ca data using these
%   different Mg/Ca_sw records, 
% and (d) pH derived from SSTs derived from this study's O. universa Mg/Ca 
%   data using these different Mg/Ca_sw records, 

% References:
% O'Brien, C. L. et al. High sea surface temperatures in tropical warm 
%   pools during the Pliocene. Nat. Geosci. 7, 606–611 (2014).
% Evans, D., Brierley, C., Raymo, M. E., Erez, J. & Müller, W. Planktic 
%   foraminifera shell 905 chemistry response to seawater chemistry: 
%   Pliocene–Pleistocene seawater Mg/Ca, temperature and sea level 
%   change. Earth Planet. Sci. Lett. 438, 139–148 (2016).
% Tierney, J. E., Malevich, S. B., Gray, W., Vetter, L. & Thirumalai, K. 
%   Bayesian calibration of the Mg/Ca paleothermometer in planktic 
%   foraminifera. Paleoceanogr. Paleoclimatology 828 (2019).
% Fantle, M. S. & DePaolo, D. J. Sr isotopes and pore fluid chemistry in 
%   carbonate sediment of the Ontong Java Plateau: Calcite 
%   recrystallization rates and evidence for a rapid rise in seawater 
%   Mg over the last 10 million years. Geochim. Cosmochim. Acta 70, 
%   3883–3904 810 (2006).
% Coggon, R. M., Teagle, D. A. H., Smith-Duque, C. E., Alt, J. C. & Cooper, 
%   M. J. Reconstructing past seawater Mg/Ca and Sr/Ca from mid-ocean 
%   ridge flank calcium 909 carbonate veins. Science 327, 1114–1117 (2010).
% Rausch, S., Böhm, F., Bach, W., Klügel, A. & Eisenhauer, A. Calcium 
%   carbonate veins in 911 ocean crust record a threefold increase of 
%   seawater Mg/Ca in the past 30 million years. Earth Planet. Sci. 
%   Lett. 362, 215–224 (2013).
% Lowenstein, T. K., Timofeeff, M. N., Brennan, S. T., Hardie, L. A. & 
%   Demicco, R. V. Oscillations in Phanerozoic seawater chemistry: Evidence 
%   from fluid inclusions. Science 294, 1086–1088 (2001).
% Horita, J., Zimmermann, H. & Holland, H. D. Chemical evolution of 
%   seawater during the Phanerozoic: Implications from the record of marine
%   evaporites. Geochim. Cosmochim. Acta 66, 3733–3756 (2002).
% Wara, M. W., Ravelo, A. C. & Delaney, M. L. Permanent El Niño-like 
%   conditions during the Pliocene warm period. Science 309, 758–761 (2005).



%% LOAD IN DATA

close all
clearvars
clc

% This study's O. universa Mg/Ca data (and Mg/Ca_sw records already 
%  interpolated onto ages of this study's data)
thisstudy_input = readtable('ED8_MgCasw_compilation.xlsx');

% Wara T. sacculifer data
wara_eep846 = readtable('ED8_Wara05_sacculifer_MgCa_EEP847.xlsx', 'Range', 'A:B');
wara_wep806 = readtable('ED8_Wara05_sacculifer_MgCa_WEP806.xlsx', 'Range', 'A:B');

% Full MgCa_sw records (will need to interpolate these SW values onto the
%  ages of the Wara data, done later)
sw_BAYMAG   = readtable('ED8_sw-rec_BAYMAG.xlsx', 'Range', 'A:C');
sw_Evans16  = readtable('ED8_sw-rec_Evans16.xlsx', 'Range', 'A:D');
sw_FDP06    = readtable('ED8_sw-rec_FDP06.xlsx', 'Range', 'A:B');
sw_OBrien14 = readtable('ED8_sw-rec_OBrien14.xlsx', 'Range', 'A:C');

% MgCa_sw from proxy data
sw_proxies = readtable('ED8_MgCasw_compilation_fluid-inclusions.xlsx', 'Range', 'A1:D5');


% This study's pH data
thisstudy_pHs = readtable('ED8_thisstudy_pH_diff_MgCasw-recs.xlsx', 'Range', '1:25');



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
wara_eep846.Evans16 = interp1(sw_Evans16.Age_Ma, sw_Evans16.MgCa_sw, wara_eep846.Age_Ma);
wara_eep846.FDP06 = interp1(sw_FDP06.Age_Ma, sw_FDP06.MgCa_sw, wara_eep846.Age_Ma);
wara_eep846.OBrien14 = interp1(sw_OBrien14.Age_Ma, sw_OBrien14.MgCa_sw, wara_eep846.Age_Ma);

wara_wep806.BAYMAG = interp1(sw_BAYMAG.Age_Ma, sw_BAYMAG.MgCa_sw, wara_wep806.Age_Ma);
wara_wep806.Evans16 = interp1(sw_Evans16.Age_Ma, sw_Evans16.MgCa_sw, wara_wep806.Age_Ma);
wara_wep806.FDP06 = interp1(sw_FDP06.Age_Ma, sw_FDP06.MgCa_sw, wara_wep806.Age_Ma);
wara_wep806.OBrien14 = interp1(sw_OBrien14.Age_Ma, sw_OBrien14.MgCa_sw, wara_wep806.Age_Ma);

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



%% CALC SST on Wara T. sacc Mg/Ca Data
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
wara_eep846.SST_Evans = ((log(wara_eep846.MgCa./(B_sacc*(wara_eep846.Evans16./mod_MgCa))))/A_orb) - (C_sacc*eep_co32);
wara_eep846.SST_FDP = ((log(wara_eep846.MgCa./(B_sacc*(wara_eep846.FDP06./mod_MgCa))))/A_orb) - (C_sacc*eep_co32);
wara_eep846.SST_OBrien = ((log(wara_eep846.MgCa./(B_sacc*(wara_eep846.OBrien14./mod_MgCa))))/A_orb) - (C_sacc*eep_co32);

% West
wara_wep806.SST_BAYMAG = ((log(wara_wep806.MgCa./(B_sacc*(wara_wep806.BAYMAG./mod_MgCa))))/A_orb) - (C_sacc*wep_co32);
wara_wep806.SST_Evans = ((log(wara_wep806.MgCa./(B_sacc*(wara_wep806.Evans16./mod_MgCa))))/A_orb) - (C_sacc*wep_co32);
wara_wep806.SST_FDP = ((log(wara_wep806.MgCa./(B_sacc*(wara_wep806.FDP06./mod_MgCa))))/A_orb) - (C_sacc*wep_co32);
wara_wep806.SST_OBrien = ((log(wara_wep806.MgCa./(B_sacc*(wara_wep806.OBrien14./mod_MgCa))))/A_orb) - (C_sacc*wep_co32);




%% AESTHETICS

 blue_4 = [0.1 0 0.5];
 blue_3 = [0.04 0.5 0.81];
 blue_2 = [0.07 0.62 1];
 blue_1 = [0.67 0.82 0.98];

 red_4 = [0.5 0 0];
 red_3 = [0.7 0.16 0.16];
 red_2 = [0.92 0 0];
 red_1 = [0.95 0.61 0.61]; 
 
 line_width = 1.25;
 


%% PLOTTING - Compilation of Different Mg/Ca_sw records

figure('Position', [200 150 1400 605]);

line_width = 2.0;

% Plot (going top to bottom) O'Brien14, FDP06, Evans16, BAYMAG 19
% errorbar(sw_OBrien14.Age_Ma, sw_OBrien14.MgCa_sw, sw_OBrien14.MgCa_1sd);
% O'Brien 14
  x = sw_OBrien14.Age_Ma(152:2232);
  y = sw_OBrien14.MgCa_sw(152:2232);
  dy_neg = sw_OBrien14.MgCa_1sd(152:2232);
  dy_pos = dy_neg;
  
  plot(x, y, 'LineWidth', line_width);
  hold on
  f = fill([x;flipud(x)],[y-dy_neg;flipud(y+dy_pos)], [0 0.4470 0.7410], 'linestyle','none',...
            'HandleVisibility', 'off');
  set(f,'facealpha',0.5)
  
  
% Evans16
  x = sw_Evans16.Age_Ma(2:end);
  y = sw_Evans16.MgCa_sw(2:end);
  dy_neg = sw_Evans16.MgCa_sw(2:end)-sw_Evans16.lower95(2:end);
  dy_pos = sw_Evans16.upper95(2:end)-sw_Evans16.MgCa_sw(2:end);  
  
  plot(x, y, 'LineWidth', line_width, 'Color', [0.49 0.18 0.56]);  
  hold on

  g = fill([x;flipud(x)],[y-dy_neg;flipud(y+dy_pos)], [0.49 0.18 0.56], 'linestyle','none',...
            'HandleVisibility', 'off');
  set(g,'facealpha',0.25)
  
 
% BAYMAG  25 28 65
  x = sw_BAYMAG.Age_Ma;
  y = sw_BAYMAG.MgCa_sw;
  dy_neg = 2*sw_BAYMAG.MgCa_1sd;
  dy_pos = dy_neg;
  
  errorbar(x, y, dy_neg, dy_pos, '-s', 'LineWidth', line_width, 'Color', ...
      [0.25 0.28 0.65], 'MarkerFaceColor', [0.25 0.28 0.65]);
  
  
  
% FDP06
  x = sw_FDP06.Age_Ma(2:end);
  y = sw_FDP06.MgCa_sw(2:end);
  plot(x, y, 'LineWidth', line_width*1.5, 'Color', [0.93 0.69 0.13]);    
  
   
proxy_color = [0.89 0.36 0.04];
% Proxies - 1.65Ma CCV  Coggon et al., 2010 ridge flanks 85 33 01
% (ridge-flank CCVs)
  n = 1; 
  errorbar(sw_proxies.Age_Ma(n), sw_proxies.MgCa_sw(n), sw_proxies.Error(n), ...
      sw_proxies.Error(n), '^', 'LineWidth', line_width, 'Color', ...
      proxy_color, 'MarkerFaceColor', proxy_color, 'MarkerSize', 8);

% Proxies - 3.2Ma fluid inclusions  Rausch et al., 2013 CCV
  n = 2; 
  scatter(sw_proxies.Age_Ma(n), sw_proxies.MgCa_sw(n), 95,...
      'd', 'MarkerFaceColor', proxy_color, 'MarkerEdgeColor', proxy_color);  
  
% Proxies - 4.7Ma fluid inclusions  Lowenstein et al., 2001 fluid incl
  n = 3; 
  errorbar(sw_proxies.Age_Ma(n), sw_proxies.MgCa_sw(n), sw_proxies.Error(n), ...
      sw_proxies.Error(n), 'o', 'LineWidth', line_width, 'Color', ...
      proxy_color, 'MarkerFaceColor', proxy_color, ...
      'MarkerSize', 8);   
  
% Proxies - 5Ma fluid inclusions  Horita et al., 2012 fluid incl
  n = 4; 
  scatter(sw_proxies.Age_Ma(n), sw_proxies.MgCa_sw(n), 105,...
      's', 'MarkerFaceColor', proxy_color, 'MarkerEdgeColor', proxy_color);    
  

set(gca, 'FontSize', 14)

hleg = legend(' O''Brien et al., 2014^{11} (1\sigma)', ' Evans et al., 2016^{121} (95% C.I.)', ...
      ' BAYMAG (Tierney et al., 2019^{88}) (1\sigma)', ' Fantle & DePaolo, 2006^{81}', ...
      ' Coggon et al., 2010^{122}', ' Rausch et al., 2013^{123}', ...
      ' Lowenstein et al., 2001^{82}', ' Horita et al., 2002^{83}', ...
      'Location', 'eastoutside', 'FontSize', 12, 'Box', 'off');
htitle = get (hleg, 'Title'); 
set(htitle, 'String', 'Mg/Ca_S_W Records')
  
xlabel('Age [Ma]', 'FontWeight', 'bold', 'FontSize', 16);
ylabel('Mg/Ca_s_w [mol/mol]', 'FontWeight', 'bold', 'FontSize', 16);



%% PLOTTING - 3-panel, T. sacc Mg/Ca SSTs (Wara et al, 2005), O. univ Mg/Ca 
% SSTs (this study), pH from O. univ SSTs (this study)
 
% More Aesthetics
default_fontsize = 10;
y_fontsize = 12;
x_fontsize = 12;
leg_fontsize = 9;
line_widtha = 0.75;

panel1_position = [0.13 0.709 0.505 0.259];
panel2_position = [0.13 0.387 0.505 0.259];
panel3_position = [0.13 0.065 0.505 0.259];
leg1_position = [0.655 0.739 0.255 0.206];
leg2_position = [0.655 0.431 0.255 0.206];
leg3_position = [0.655 0.121 0.255 0.206];



figure('Position', [400 50 1000 825]);

subplot('Position', panel1_position)

    x = wara_eep846.Age_Ma;
    y = wara_eep846;
    plot(x, y.SST_OBrien, 'LineWidth', line_widtha, 'Color', blue_1);
    hold on
    plot(x, y.SST_FDP, 'LineWidth', line_widtha, 'Color', blue_2);
    plot(x, y.SST_Evans, 'LineWidth', line_widtha, 'Color', blue_3);
    plot(x, y.SST_BAYMAG, 'LineWidth', line_widtha, 'Color', blue_4);


    x = wara_wep806.Age_Ma;
    y = wara_wep806;
    plot(x, y.SST_OBrien, 'LineWidth', line_widtha, 'Color', red_1);
    hold on
    plot(x, y.SST_FDP, 'LineWidth', line_widtha, 'Color', red_2);
    plot(x, y.SST_Evans, 'LineWidth', line_widtha, 'Color', red_3);
    plot(x, y.SST_BAYMAG, 'LineWidth', line_widtha, 'Color', red_4);

    set(gca, 'FontSize', default_fontsize)

    ylim([15 39]);    
    
    leg = legend('O''Brien et al., 2014^{11} (ends ~4.8Ma)', 'Fantle and DePaolo, 2006^{81}', ...
        'Evans et al., 2016^{121} (ends ~5Ma)', 'BAYMAG (Tierney et al., 2019)^{88}', ...
        'O''Brien et al., 2014^{11} (ends ~4.8Ma)', 'Fantle and DePaolo, 2006^{81}', ...
        'Evans et al., 2016^{121} (ends ~5Ma)', 'BAYMAG (Tierney et al., 2019)^{88}',...
        'Box', 'off', 'FontSize', leg_fontsize, 'Position', leg1_position);
    legtitle = get(leg,'Title');
    set(legtitle,'String','Mg/Ca_s_w Records')

    ylabel('SST [\circC]', 'FontWeight', 'bold', 'FontSize', y_fontsize);
    title('{\itT. sacculifer} Mg/Ca SSTs (Wara et al., 2005)^1')

    
subplot('Position', panel2_position)
    % This study's data - East
    range = [13:24];
    marker_size = 60;
    scatter(thisstudy_input.Age(range), thisstudy_input.SST_OBrien(range), marker_size, 'MarkerEdgeColor', 'k', ...
        'MarkerFaceColor', blue_1);
    hold on
    scatter(thisstudy_input.Age(range), thisstudy_input.SST_FDP(range), marker_size, 'MarkerEdgeColor', 'k', ...
         'MarkerFaceColor', blue_2);
    scatter(thisstudy_input.Age(range), thisstudy_input.SST_Evans(range), marker_size, 'MarkerEdgeColor', 'k', ...
         'MarkerFaceColor', blue_3);
    scatter(thisstudy_input.Age(range), thisstudy_input.SST_BAYMAG(range), marker_size, 'MarkerEdgeColor', 'k', ...
         'MarkerFaceColor', blue_4);

    % This study's data - West
    range = [1:12];
    scatter(thisstudy_input.Age(range), thisstudy_input.SST_OBrien(range), marker_size, 'MarkerEdgeColor', 'k', ...
        'MarkerFaceColor', red_1);
    scatter(thisstudy_input.Age(range), thisstudy_input.SST_FDP(range), marker_size, 'MarkerEdgeColor', 'k', ...
         'MarkerFaceColor', red_2);
    scatter(thisstudy_input.Age(range), thisstudy_input.SST_Evans(range), marker_size, 'MarkerEdgeColor', 'k', ...
         'MarkerFaceColor', red_3);
    scatter(thisstudy_input.Age(range), thisstudy_input.SST_BAYMAG(range), marker_size, 'MarkerEdgeColor', 'k', ...
         'MarkerFaceColor', red_4);
     
     
    ylim([18 31]);
    
    set(gca, 'FontSize', default_fontsize)

    leg = legend('O''Brien et al., 2014^{11} (ends ~4.8Ma)', 'Fantle and DePaolo, 2006^{81}', ...
        'Evans et al., 2016^{121} (ends ~5Ma)', 'BAYMAG (Tierney et al., 2019)^{88}', ...
        'O''Brien et al., 2014^{11} (ends ~4.8Ma)', 'Fantle and DePaolo, 2006^{81}', ...
        'Evans et al., 2016^{121} (ends ~5Ma)', 'BAYMAG (Tierney et al., 2019)^{88}',...
        'Box', 'off', 'FontSize', leg_fontsize, 'Position', leg2_position);
    legtitle = get(leg,'Title');
    set(legtitle,'String','Mg/Ca_s_w Records')

    ylabel('SST [\circC]', 'FontWeight', 'bold', 'FontSize', y_fontsize);
    title('{\itO. universa} Mg/Ca SSTs (This Study)')

    box on

    
subplot('Position', panel3_position)
        
    marker_size = 10;

    % Plot the 8 6Ma points (east and west) from FDP & BAYMAG records with
    % error bars
    % 6Ma Error Bars East
    range = (9:12);
    e = errorbar(thisstudy_pHs.Age(range), thisstudy_pHs.pH_FDP(range), thisstudy_pHs.pH2sd_FDP(range), ...
        thisstudy_pHs.pH2sd_FDP(range), 'Color', red_1, 'HandleVisibility', 'off');
    e.LineWidth = 1.25;
    hold on
    e = errorbar(thisstudy_pHs.Age(range), thisstudy_pHs.pH_BAYMAG(range), thisstudy_pHs.pH2sd_BAYMAG(range), ...
        thisstudy_pHs.pH2sd_BAYMAG(range), 'Color', red_2, 'HandleVisibility', 'off');
    e.LineWidth = 1.25;
    % 6Ma Error Bars West
    range = (21:24);
    e = errorbar(thisstudy_pHs.Age(range), thisstudy_pHs.pH_FDP(range), thisstudy_pHs.pH2sd_FDP(range), ...
        thisstudy_pHs.pH2sd_FDP(range), 'Color', blue_1, 'HandleVisibility', 'off');
    e.LineWidth = 1.25;
    e = errorbar(thisstudy_pHs.Age(range), thisstudy_pHs.pH_BAYMAG(range), thisstudy_pHs.pH2sd_BAYMAG(range), ...
        thisstudy_pHs.pH2sd_BAYMAG(range), 'Color', blue_2, 'HandleVisibility', 'off');
    e.LineWidth = 1.25;

    % Western points
    range = [1:12];
    
    plot(thisstudy_pHs.Age(range), thisstudy_pHs.pH_FDP(range), '-p', 'Color', red_1, ...
        'MarkerSize', marker_size, 'MarkerEdgeColor', 'k', 'MarkerFaceColor', red_1);
    hold on
    plot(thisstudy_pHs.Age(range), thisstudy_pHs.pH_BAYMAG(range), '-^', 'Color', red_2,  ...
        'MarkerSize', marker_size*0.75, 'MarkerEdgeColor', 'k', 'MarkerFaceColor', red_2);
    plot(thisstudy_pHs.Age(range), thisstudy_pHs.pH_Evans(range), '-s', 'Color', red_3,  ...
        'MarkerSize', marker_size*0.75, 'MarkerEdgeColor', 'k', 'MarkerFaceColor', red_3);
    plot(thisstudy_pHs.Age(range), thisstudy_pHs.pH_OBrien(range), '-o', 'Color', red_4,  ...
        'MarkerSize', marker_size*0.75, 'MarkerEdgeColor', 'k', 'MarkerFaceColor', red_4);



    % Eastern points
    range = [13:24];
    plot(thisstudy_pHs.Age(range), thisstudy_pHs.pH_FDP(range), '-p', 'Color', blue_1, ...
        'MarkerSize', marker_size, 'MarkerEdgeColor', 'k', 'MarkerFaceColor', blue_1);
    hold on
    plot(thisstudy_pHs.Age(range), thisstudy_pHs.pH_BAYMAG(range), '-^', 'Color', blue_2, ...
        'MarkerSize', marker_size*0.75, 'MarkerEdgeColor', 'k', 'MarkerFaceColor', blue_2);
    plot(thisstudy_pHs.Age(range), thisstudy_pHs.pH_Evans(range), '-s', 'Color', blue_3, ...
        'MarkerSize', marker_size*0.75, 'MarkerEdgeColor', 'k', 'MarkerFaceColor', blue_3);
    plot(thisstudy_pHs.Age(range), thisstudy_pHs.pH_OBrien(range), '-o', 'Color', blue_4, ...
        'MarkerSize', marker_size*0.75, 'MarkerEdgeColor', 'k', 'MarkerFaceColor', blue_4);


    set(gca, 'FontSize', default_fontsize)

    leg = legend('O''Brien et al., 2014^{11} (ends ~4.8Ma)', 'Fantle and DePaolo, 2006^{81}', ...
        'Evans et al., 2016^{121} (ends ~5Ma)', 'BAYMAG (Tierney et al., 2019)^{88}', ...
        'O''Brien et al., 2014^{11} (ends ~4.8Ma)', 'Fantle and DePaolo, 2006^{81}', ...
        'Evans et al., 2016^{121} (ends ~5Ma)', 'BAYMAG (Tierney et al., 2019)^{88}',...
        'Box', 'off', 'FontSize', leg_fontsize, 'Position', leg3_position);
    legtitle = get(leg,'Title');
    set(legtitle,'String','Mg/Ca_s_w Records')

    xlabel('Age [Ma]', 'FontWeight', 'bold', 'FontSize', x_fontsize);
    ylabel('pH', 'FontWeight', 'bold', 'FontSize', y_fontsize);
    ylim([7.77 8.2]);
    title('pH from {\itO. universa} SSTs (This Study)')

