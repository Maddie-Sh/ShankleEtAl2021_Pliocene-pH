%EXTENDED DATA 2A: pH-LONGITUDE LINES
% MADISON Shankle
% 09-Sept-2021

% Plots equatorial (0.5 degN) pH, averaged over the 25-55m depth range,
% from model output (the control and experimental early Pliocene/late 
% Miocene runs). Also overlays modern pH and pH from boron isotopes (this
% study).




%% READ IN VARIABLES
% Model output available online; see data availability statement in text.

clearvars
close all
clc

lon = ncread('Plio_ciso_T31_gx3v7_ALL_2901-3000_Reg1DegGrid.nc', 'lon');    % 0:359 degrees_E               [360] (steps of 1)
lat = ncread('Plio_ciso_T31_gx3v7_ALL_2901-3000_Reg1DegGrid.nc', 'lat');    % -89.5000:89.5000 degrees_N    [180] (steps of 1)
depth = ncread('Plio_ciso_T31_gx3v7_ALL_2901-3000_Reg1DegGrid.nc', 'z_t');  % 500:537500 cm                 [60] (steps of 1000) depth from surface to midpoint of layer


pH_PlioMio = ncread('PlioB17_ciso.nc', 'pH_3D');
pH_PreInd = ncread('PreInd_ciso_T31_gx3v7_ALL_2901-3000_Reg1DegGrid.nc', 'pH_3D');


%% TAKE LON-DEPTH PROFILE ALONG EQUATOR (LAT == 0)
%
% 'depth from surface to midpoint of layer',  units = 'centimeters'

% Can't do lat==0 because goes in half-degree steps
% squeeze command gets rid of dimensions of length 1
eqtr_pH_PlioMio = squeeze(pH_PlioMio(:,find(lat == -0.5),:));
eqtr_pH_PreInd = squeeze(pH_PreInd(:,find(lat == -0.5),:));


% 25, 55, 75, & 105m depth
eqtr_25m_pH_PlioMio = eqtr_pH_PlioMio(:,find(depth == 2500));
eqtr_25m_pH_PreInd = eqtr_pH_PreInd(:,find(depth == 2500));

eqtr_55m_pH_PlioMio = eqtr_pH_PlioMio(:,find(depth == 5500));
eqtr_55m_pH_PreInd = eqtr_pH_PreInd(:,find(depth == 5500));

eqtr_75m_pH_PlioMio = eqtr_pH_PlioMio(:,find(depth == 7500));
eqtr_75m_pH_PreInd = eqtr_pH_PreInd(:,find(depth == 7500));



%% READ IN PROXY DATA

proxy_pH = xlsread('ED2a_proxy_pH_by_longitude.xlsx'); % 3 columns, lon(degE), pH, age(Ma)
           % ~1Ma = 1:4 & 13:16. ~3Ma = 5:8 & 17:20. ~6Ma = 9:12 & 21:25

% WEST (rows 1:4) FOLLOWED BY EAST (rows 5:8)
proxy_pH_6Ma = zeros(8,3);      
proxy_pH_6Ma(1:4,:) = proxy_pH(9:12,1:3);       % cols 1:3 = lon, pH, twosd
proxy_pH_6Ma(5:end,:) = proxy_pH(21:24,1:3);

proxy_pH_3Ma = zeros(8,3);
proxy_pH_3Ma(1:4,:) = proxy_pH(5:8,1:3);        % cols 1:3 = lon, pH, twosd
proxy_pH_3Ma(5:end,:) = proxy_pH(17:20,1:3);
proxy_pH_3Ma(:,1) = proxy_pH_3Ma(:,1) -2;  % & offset left by 2deg so easier to see

proxy_pH_1Ma = zeros(8,3);
proxy_pH_1Ma(1:4,:) = proxy_pH(1:4,1:3);        % cols 1:3 = lon, pH, twosd
proxy_pH_1Ma(5:end,:) = proxy_pH(13:16,1:3);
proxy_pH_1Ma(:,1) = proxy_pH_1Ma(:,1) -4;  % & offset left by 4deg so easier to see




%% MODERN pH DATA

% pH as found from modern observations from east and west equatorial 
% Pacific, see Methods for full details.

mod_east_pH = 8.007;   
mod_east_pH_lon = 263;
mod_west_pH = 8.067;    
mod_west_pH_lon = 155;

mod_pH = zeros(2,2);
mod_pH(1,1) = mod_east_pH_lon;
mod_pH(2,1) = mod_west_pH_lon;
mod_pH(1,2) = mod_east_pH;
mod_pH(2,2) = mod_west_pH;



%% PLOTTING

% Aesthetics
mod_pH_size = 120;
plio_pH_size =  50;
mod_linewidth = 3.5;     % MODERN marker thicknesses
plio_linewidth = 2;
plio_err_linewidth = 1.5;
model_linewidth = 3;

color_modern = [0.99 0.75 0.15]; % yellow
color_1Ma = [0.50 0.21 0.69]; % [0.45 0.21 0.64]; % purple
color_3Ma = [0.34 0.66 0.11]; % green
color_6Ma = [0.31 0.69 0.94];  % blue

range_transparency = 0.3;



figure

      
% Pre-Ind Model Control: Plot range of pH, 25-50m
  x = lon;
  y = eqtr_55m_pH_PreInd;
  dy_neg = eqtr_55m_pH_PreInd - eqtr_75m_pH_PreInd;
  dy_pos = eqtr_25m_pH_PreInd - eqtr_55m_pH_PreInd;
  y(isnan(y))=0;
  dy_neg(isnan(dy_neg))=0;
  dy_pos(isnan(dy_pos))=0;

  % Shaded area to show range of pH between 25m and 75m depth:
  f = fill([x;flipud(x)],[y-dy_neg;flipud(y+dy_pos)],'blue','linestyle','none',...
            'HandleVisibility', 'on');
  set(f,'facealpha',range_transparency)

  % Plot model output at 55m depth
  hold on
  plot(lon,eqtr_55m_pH_PreInd,':','LineWidth', model_linewidth, 'Color', 'blue')

  
% PlioMio Model Experiment: Plot range of pH, 25-50m
  x = lon;
  y = eqtr_55m_pH_PlioMio;
  dy_neg = eqtr_55m_pH_PlioMio - eqtr_75m_pH_PlioMio;
  dy_pos = eqtr_25m_pH_PlioMio - eqtr_55m_pH_PlioMio;
  y(isnan(y))=0;
  dy_neg(isnan(dy_neg))=0;
  dy_pos(isnan(dy_pos))=0;

  % Shaded area to show range of pH between 25m and 75m depth
  f = fill([x;flipud(x)],[y-dy_neg;flipud(y+dy_pos)],'red','linestyle','none',...
            'HandleVisibility', 'on');
  set(f,'facealpha',range_transparency)

  % Plot model output at 55m depth
  hold on
  plot(lon,eqtr_55m_pH_PlioMio,'LineWidth', model_linewidth, 'Color', 'red')
  

% Proxy Data
  % Error bars
  e = errorbar(proxy_pH_1Ma(:,1),proxy_pH_1Ma(:,2),proxy_pH_1Ma(:,3), 'LineStyle','none', 'LineWidth', plio_err_linewidth);
  e.Color = color_1Ma;
  e = errorbar(proxy_pH_3Ma(:,1),proxy_pH_3Ma(:,2),proxy_pH_3Ma(:,3), 'LineStyle','none', 'LineWidth', plio_err_linewidth);
  e.Color = color_3Ma;
  e = errorbar(proxy_pH_6Ma(:,1),proxy_pH_6Ma(:,2),proxy_pH_6Ma(:,3), 'LineStyle','none', 'LineWidth', plio_err_linewidth);
  e.Color = color_6Ma;
  % Points
  scatter(proxy_pH_1Ma(:,1),proxy_pH_1Ma(:,2), plio_pH_size, 'o', 'MarkerFaceColor', [1 1 1],...
      'MarkerEdgeColor', color_1Ma, 'LineWidth', plio_linewidth, 'HandleVisibility', 'off')
  scatter(proxy_pH_3Ma(:,1),proxy_pH_3Ma(:,2), plio_pH_size, 'o', 'MarkerFaceColor', [1 1 1],...
      'MarkerEdgeColor', color_3Ma, 'LineWidth', plio_linewidth, 'HandleVisibility', 'off')
  scatter(proxy_pH_6Ma(:,1),proxy_pH_6Ma(:,2), plio_pH_size, 'o', 'MarkerFaceColor', [1 1 1],...
      'MarkerEdgeColor', color_6Ma, 'LineWidth', plio_linewidth, 'HandleVisibility', 'off')
  
  
% MODERN POINTS (yellow)
  plot([162 270],[mod_west_pH mod_east_pH], '--x', 'LineWidth', mod_linewidth-0.5, ...
      'Color', color_modern, 'MarkerSize', mod_pH_size-105)

% Error bars on modern points (yellow) to show range from 50m (low pH) to 
% 25m (high pH) depth
% neg error = diff btw avg and 50m (the lower pH)
yneg_west = mod_west_pH - 8.063; % pH @50m
yneg_east = mod_east_pH - 7.964;
% pos error = diff btw avg and 25m (the higher pH)
ypos_west = 8.069 - mod_west_pH; % pH @25m
ypos_east = 8.039 - mod_east_pH;
% plot:
errorbar([162 270],[mod_west_pH mod_east_pH], [yneg_west yneg_east], ...
    [ypos_west ypos_east], 'Color', color_modern,...
    'LineStyle','none', 'LineWidth', mod_linewidth-0.5);



xlim([145 275])          % 90E to 70W (-110E, 180+110)
ylim([7.75 8.2])

% Legend
legend(' Pre-Ind. pH (model),\fontsize{11} 25-75m Depth', ' Pre-Ind. pH (model),\fontsize{11} 55m Depth', ...
    ' Plio. pH (model),\fontsize{11} 25-75m Depth', ' Plio. pH (model),\fontsize{11} 55m Depth', ...
    ' ~1Ma pH\fontsize{11} (\delta\fontsize{9.5}^1^1\fontsize{11}B)', ...
    ' ~3Ma pH\fontsize{11} (\delta\fontsize{9.5}^1^1\fontsize{11}B)', ...
    ' ~6Ma pH\fontsize{11} (\delta\fontsize{9.5}^1^1\fontsize{11}B)',...%'Pre-Ind. Surface pH\fontsize{11} (Feely et al., 2009)', ...   %%% % 2021-02-21 updated now using pH as found from modern observations
    ' Modern pH,\fontsize{11} avg. 25-50m depth', ...
    ' Modern pH range,\fontsize{11} 25-50m depth', ...
    'FontSize', 13,  'Location', 'southwest')


% Other Aesthetics
xlabel('\fontsize{17}Lon \fontsize{13}(\circE)', 'FontWeight',  'bold')
set(gca, 'FontSize',13, 'TickDir','out')
ylabel('\fontsize{17}pH', 'FontWeight',  'bold')
grid on
