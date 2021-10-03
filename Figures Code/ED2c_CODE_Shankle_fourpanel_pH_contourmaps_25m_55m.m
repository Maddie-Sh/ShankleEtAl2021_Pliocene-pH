%% ED2c: pH Contour Maps, 4panel: PlioMio and Anomaly at 25m, 55m Depth
% Madison Shankle
% 13-09-2021

% Plots a four-paneled figure of contour maps of model-output pH and pH
% anomaly at ~6Ma, with proxy data overlain as colored circles at locations
% of study sites and saves the figure as a PDF. Shows model output at 25m
% depth and 55m depth specifically, rather than the average of the model
% output over this range.



%% LOAD IN/SET UP DATA


% Clear any variables currently in workspace, close any figures currently
% open, and clear Command Window
clearvars 
close all
clc

% This study's data.
%   Loads in a 24x2 array ('pH_final) where the columns are pH and 2sd on 
%   pH, respectively. Ages not given but first 12 are WEP and last 12 are 
%   EEP. Within WEP or EEP, grouped in three groups of four giving data 
%   from ~1Ma, then ~3Ma, then ~6Ma. I.e., rows 9-12 are the four ~6Ma WEP 
%   data points from this study, corresponding to ages 5.800Ma, 5.852Ma, 
%   5.899Ma, and 6.000Ma, and rows 21-24 are the four ~6Ma EEP data points
%   corresponding to ages 5.844Ma, 5.873Ma, 5.907Ma, and 6.077Ma
load('ED2c_Shankle_Pliocene_pH_results.mat', 'pH_final');
c_proxydata = pH_final([9:12, 21:24]); % 'c' b/c circles will be colored by pH value
clear pH_final;

% NOTE: these netcdf files are available online on NOAA's Paleocliamte data
% repository: https://www.ncdc.noaa.gov/paleo/study/33252 (see Data & Code
% Availability Statement in the main text)
% vardata = ncread(source,variable_name)
lon = ncread('PlioB17_ciso.nc', 'lon');    % 0:359 degrees_E               [360] (steps of 1)
lat = ncread('PlioB17_ciso.nc', 'lat');    % -89.5000:89.5000 degrees_N    [180] (steps of 1)
depth = ncread('PlioB17_ciso.nc', 'z_t');  % 500:537500 cm                 [60] (steps of 1000) depth from surface to midpoint of layer

pH_PlioMio = ncread('PlioB17_ciso.nc', 'pH_3D');
pH_PreInd = ncread('PreInd_ciso_T31_gx3v7_ALL_2901-3000_Reg1DegGrid.nc', 'pH_3D');


%%

pH_25m_PlioMio = pH_PlioMio(:,:,find(depth == 2500));
pH_25m_PreInd = pH_PreInd(:,:,find(depth == 2500));

pH_35m_PlioMio = pH_PlioMio(:,:,find(depth == 3500)); % <---
pH_35m_PreInd = pH_PreInd(:,:,find(depth == 3500));

pH_45m_PlioMio = pH_PlioMio(:,:,find(depth == 4500));
pH_45m_PreInd = pH_PreInd(:,:,find(depth == 4500));

pH_55m_PlioMio = pH_PlioMio(:,:,find(depth == 5500));
pH_55m_PreInd = pH_PreInd(:,:,find(depth == 5500));



% !!!!!!
PlioMio_minus_pH_25m_PreInd = pH_25m_PlioMio - pH_25m_PreInd;
PlioMio_minus_pH_55m_PreInd = pH_55m_PlioMio - pH_55m_PreInd;




%% SETTING UP FOR PLOT

% Aesthetics
color_limits_6Ma = [7.8 8.2];
color_limits_diff = [-0.25 0];



% pH Anomaly: Modern pH MINUS this study's ~6Ma data, (+) = more acidic in 
%   this study's my 6Ma data
% 8 points b/c will plot the 8 ~6Ma data points from this study (4 from the
%   west and 4 from the east)
% For details on modern pH values, see Methods.
c_diffs = c_proxydata - [8.067 8.067 8.067 8.067 8.007 8.007 8.007 8.007];


% Now, pt.1,2,3,4 (5.7, 5.8, 5.9, 6.0Ma) will START AT correct position as
% TOP RIGHT square and go CLOCKWISE. So point 2 is dropped 1.4 degree.
% Point 3 is dropped 1.4 degree and shifted left 7 degrees. Point 4 is 
% shifted left 7 degrees.
lon_shift = 7; % prev 5
longs = [159.362 159.362 159.362-lon_shift 159.362-lon_shift 269.182 269.182 269.182-lon_shift 269.182-lon_shift];
lat_shift = 1.4;
lats = [0 0-lat_shift 0-lat_shift 0 -3 -3-lat_shift -3-lat_shift -3];



%% PLOTTING

close all

figure

for i = 1:4
    if i == 1
        x = pH_25m_PlioMio;            % (1) TOP LEFT - 6Ma, 25m
        subplot('Position',[0.0749218750000001 0.5509 0.3705 0.3738])
        color_limits = color_limits_6Ma;
        c = c_proxydata;
    else if i == 2                      % (2) TOP RIGHT -  6Ma-PreInd, 25m
            x = PlioMio_minus_pH_25m_PreInd;
            subplot('Position',[0.561003125 0.5509 0.3705 0.3738])
            color_limits = color_limits_diff;
            c = c_diffs;                % Colors (modern minus this study's data)
        else if i == 3
                x = pH_55m_PlioMio;     % (3) BOTTOM LEFT - 6Ma, 55m
                subplot('Position',[0.072578125 0.0774 0.3705 0.3738])
                color_limits = color_limits_6Ma;
                c = c_proxydata;
            else if i == 4              % (4) BOTTOM RIGHT - 6Ma-PreInd, 55m
                    x = PlioMio_minus_pH_55m_PreInd;
                    subplot('Position',[0.561003125 0.0774 0.3705 0.3738])
                    color_limits = color_limits_diff;
                    c = c_diffs;        % Colors (modern minus this study's data)
                end
            end
        end
    end
    
    % Plot contour maps    
    h = pcolor(lon,lat,x'); shading interp
    set(h, 'EdgeColor', 'none');
    xlim([90 290])          % 90E to 70W (-110E, 180+110)
    ylim([-10 10])

    % Aesthetics
    xlabel('\fontsize{14}Lon \fontsize{12}(\circE)')
    set(gca, 'FontSize',12, 'TickDir','out')
    ylabel('\fontsize{14}Lat \fontsize{12}(\circN)')


    caxis(color_limits)

    if i == 3
        cb = colorbar('Position', [0.45919739583 0.0753 0.01900 0.8531], 'FontSize', 13);
        title(cb, 'pH', 'FontWeight', 'Bold', 'FontSize', 13)
    end
    if i == 4
        cb = colorbar('Position', [0.9477 0.0753 0.019 0.8531], 'FontSize', 13);
        title(cb, '\DeltapH', 'FontWeight', 'Bold', 'FontSize', 13)
    end
    
    % Add color bar
    ax = gca;
    colormap(ax, flipud(parula))

        
    hold on
    % Plot this study's data points; WEP ODP-806, EEP ODP-846
    s = scatter(longs, lats, 250, c, 'o', 'filled', 'MarkerEdgeColor', [0 0 0], 'LineWidth', 1.5);


end

% Add Annotations to the figure
a1 = text('String', '25m Depth', 'Position', [-203.52027 21.0741 1.421086e-14],...
    'FontSize', 28, 'FontWeight', 'Bold');
set(a1,'Rotation',90)

a2 = text('String', '55m Depth', 'Position', [-203.52027 -8.1426 1.421085e-14],...
    'FontSize', 28, 'FontWeight', 'Bold');
set(a2,'Rotation',90)

a3 = text('String', '~6Ma', 'Position',[-86.80823 38.4828 1.421085e-14],...
    'FontSize', 28, 'FontWeight', 'Bold');

a4 = text('String', '~6Ma - Modern', 'Position',[157.0979 38.4828 1.42109e-14],...
    'FontSize', 28, 'FontWeight', 'Bold');

