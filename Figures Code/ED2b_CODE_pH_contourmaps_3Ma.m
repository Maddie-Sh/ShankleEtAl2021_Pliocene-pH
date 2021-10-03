%% ED 2b: pH Contour Maps from Model Output w/ 3Ma proxy pH data
% Madison Shankle
% 13-09-2021

% Plots a two-paneled figure of contour maps of model-output pH and pH
% anomaly at ~3Ma, with proxy data overlain as colored circles at locations
% of study sites and saves the figure as a PDF.


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
%   from ~1Ma, then ~3Ma, then ~6Ma. I.e., rows 5:8 are the four ~3Ma WEP 
%   data points from this study, corresponding to ages 2.699Ma, 2.800Ma, 
%   2.9009Ma, and 2.999Ma, and rows 17:20 are the four ~3Ma EEP data points
%   corresponding to ages 2.700Ma, 2.856Ma, 2.900Ma, and 3.000Ma
load('ED2b_Shankle_Pliocene_pH_results.mat', 'pH_final');
c_mydata = pH_final([5:8, 17:20]); % 'c' b/c circles will be colored by pH value
clear pH_final;

% NOTE: these netcdf files are available online on NOAA's Paleocliamte data
% repository: https://www.ncdc.noaa.gov/paleo/study/33252 (see Data & Code
% Availability Statement in the main text)
% vardata = ncread(source,variable_name)
lon = ncread('PlioB17_ciso.nc', 'lon');    % 0:359 degrees_E               [360] (steps of 1)
lat = ncread('PlioB17_ciso.nc', 'lat');    % -89.5000:89.5000 degrees_N    [180] (steps of 1)
depth = ncread('PlioB17_ciso.nc', 'z_t');  % 500:537500 cm                 [60] (steps of 1000) depth from surface to midpoint of layer
depth_wvel = ncread('PlioB17_ciso.nc', 'z_w_top'); % 0:5.2500e5 cm         [60] (steps of 0.01 e+5) depth from surface to top of layer

pH_PlioMio = ncread('PlioB17_ciso.nc', 'pH_3D');
pH_PreInd = ncread('PreInd_ciso_T31_gx3v7_ALL_2901-3000_Reg1DegGrid.nc', 'pH_3D');




%% READ IN pH DATA (MODEL OUTPUT) AT SPECIFIC DEPTHS

pH_25m_PlioMio = pH_PlioMio(:,:,find(depth == 2500));
pH_25m_PreInd = pH_PreInd(:,:,find(depth == 2500));

pH_35m_PlioMio = pH_PlioMio(:,:,find(depth == 3500));
pH_35m_PreInd = pH_PreInd(:,:,find(depth == 3500));

pH_45m_PlioMio = pH_PlioMio(:,:,find(depth == 4500));
pH_45m_PreInd = pH_PreInd(:,:,find(depth == 4500));

pH_55m_PlioMio = pH_PlioMio(:,:,find(depth == 5500));
pH_55m_PreInd = pH_PreInd(:,:,find(depth == 5500));


% Average pH surfaces of 25, 35, 45, and 55m depth
pH_all_depths = cat(3, pH_25m_PlioMio, pH_35m_PlioMio, pH_45m_PlioMio, pH_55m_PlioMio);
% Now avg. across 3rd dimension to get pH avg. across 25, 35, 45, 55m depth
avg_pH_2555m = mean(pH_all_depths,3);
% Now do for Pre-Ind
pH_all_depths = cat(3, pH_25m_PreInd, pH_35m_PreInd, pH_45m_PreInd, pH_55m_PreInd);
% Now avg. across 3rd dimension to get pH avg. across 25, 35, 45, 55m depth
avg_pH_PreInd_2555m = mean(pH_all_depths,3);
% Now find Plio-PreInd diff
avg_pH_Diff_2555m = avg_pH_2555m - avg_pH_PreInd_2555m;

% Extract pH at approximate lat/lon of study sites
note_wep_pH_2555avg = avg_pH_PreInd_2555m(find(lon == 159), find(lat == 0.5))
note_eep_pH_2555avg = avg_pH_PreInd_2555m(find(lon == 269), find(lat == -2.5))



%% SETTING UP FOR PLOT

% Aesthetics
color_limits_3Ma = [7.8 8.2];
color_limits_diff = [-0.25 0];



% pH Anomaly: Modern pH MINUS this study's ~3Ma data, (+) = more acidic in 
%   this study's my 3Ma data relative to modern
% 8 points b/c will plot the 8 ~3Ma data points from this study (4 from the
%   west and 4 from the east)
c_diffs = c_mydata - [8.067 8.067 8.067 8.067 8.007 8.007 8.007 8.007];



% Now, pt.1,2,3,4 (2.7, 2.8, 2.9, 3.0Ma) will START AT correct position as
% TOP RIGHT square and go CLOCKWISE. So point 2 is dropped 1.5 degree.
% Point 3 is dropped 1.5 degree and shifted left 6.5 degrees. Point 4 is 
% shifted left 6.5 degrees.
lon_shift = 6.5;
longs = [159.362 159.362 159.362-lon_shift 159.362-lon_shift 269.182 269.182 269.182-lon_shift 269.182-lon_shift];
lat_shift = 1.5;
lats = [0 0-lat_shift 0-lat_shift 0 -3 -3-lat_shift -3-lat_shift -3]; % prev -1 -1


%% Now make ED2b: 2 panel, pH avg over 25-55m, top: 3Ma bottom: 3Ma 
% minus modern pH anomaly

figure('Position', [150 42 930 845]);

for i = 1:2
    if i == 1
        x = avg_pH_2555m;           % (1) TOP LEFT - 3Ma, 25m
        subplot(211)
        color_limits = color_limits_3Ma;
        c = c_mydata;
    else if i == 2                  % (2) TOP RIGHT -  3Ma-PreInd, 25m
            x = avg_pH_Diff_2555m;
            subplot(212)
            color_limits = color_limits_diff;
            c = c_diffs;            % Colors (modern minus this study's data)
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

    if i == 1
        cb = colorbar;
        title(cb, 'pH', 'FontWeight', 'Bold', 'FontSize', 13)
    end
    if i == 2
        cb = colorbar;
        title(cb, '\DeltapH', 'FontWeight', 'Bold', 'FontSize', 13)
    end
    
    % Add color bar
    ax = gca;
    colormap(ax, flipud(parula))

    
    hold on
    % Plot this study's data points; WEP ODP-806, EEP ODP-846
    s = scatter(longs, lats, 250, c, 'o', 'filled', 'MarkerEdgeColor', [0 0 0], 'LineWidth', 1.5);
    
    if i == 1
        title('~3Ma', 'FontSize', 18, 'FontWeight', 'Bold')
    else if i == 2
            title('~3Ma - Modern', 'FontSize', 18, 'FontWeight', 'Bold')
        end
    end

end

% Add Annotations ('a', 'b' panels)
annotation('textbox',[0.0619 0.912731205984302 0.03 0.035], ... % [0.0396875 0.931181390486147 0.017 0.035],...
    'VerticalAlignment','middle',...
    'String',{'a'},...
    'HorizontalAlignment','center',...
    'FontWeight','bold',...
    'FontSize',14,...
    'FitBoxToText','off',...
    'BackgroundColor','none', ...
    'EdgeColor', 'none');
annotation('textbox',[0.0618811677631579 0.438359259799155 0.03 0.035], ... % [0.5250390625 0.931242760062729 0.017 0.035],...
    'VerticalAlignment','middle',...
    'String','b',...
    'HorizontalAlignment','center',...
    'FontWeight','bold',...
    'FontSize',14,...
    'FitBoxToText','off',...
    'BackgroundColor','none', ...
    'EdgeColor', 'none');



