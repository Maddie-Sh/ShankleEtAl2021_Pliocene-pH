%% ED5abcd: Modern pH-Depth Profiles Compilation
% Madison Shankle
% 14-09-2021

% Plots depth profiles of pH compiled from all available cruise ship data
% taken within 5deg latitude and longtude of our study sites, as available
% from the GLODAP, GLODAPv2, PACIFICA, and WOCE databases.

% Note, this script also needs the 
% "ED5abcd_ED5abcd_func_interp_pH_one_meters.m",
% "ED5abcd_plot_all_stations.m", and 
% "ED5abcd_ED5abcd_pH_depth_profiles_plot_aesthetics.m" functions in the 
% working directory.
 
% References:
%   Key, R. M. et al. A global ocean carbon climatology: Results from 
%     Global Data Analysis Project (GLODAP). Global Biogeochem. Cycles 18, 
%     (2004).
%   Olsen, A. et al. GLODAPv2. 2020–the second update of GLODAPv2. Earth 
%     Syst. Sci. Data (2020).
%   Suzuki, T. et al. PACIFICA data synthesis project. ORNL/CDIAC-159, 
%     NDP-092, Carbon Dioxide Inf. Anal. Center, Oak Ridge Natl. Lab. US 
%     Dep. Energy, Oak Ridge, TN, USA (2013).
%   Schlitzer, R. Electronic atlas of WOCE hydrographic and tracer data now 
%     available. Eos Trans. 81, 45 (2000).



%% LOAD IN DATA

clearvars
close all
clc

input = readtable('ED5abcd_Shankle_modern_pH_compilation.txt' , 'HeaderLines', 2);
input = table2array(input);

% Info on the table loaded above:
% 23 cruises are compiled into this table. Each cruise has 5 columns
%   associated with it, as described below. Note, each cruise had multiple
%   stations at which pH with depth was measured. The subsequent stations
%   are listed in the "Station" column, and the depths and pHs are listed
%   for each station one after another in the "Depth" and "pH" columns. You
%   will need to separate out the separate stations in the "Depth" and "pH"
%   columns by referencing the "Station" column.
% Every 5th column (starting at column 1) is "Approximate Depth" (m) for an
%   average pH-depth profile (an average of all stations on a given 
%   cruise.
% Every 5th column (starting at column 2) is "Average pH" at the depths
%    given in "Approximate Depth" (for an average pH-depth profile).
% Every 5th column (starting at column 3) is "Station"  (station number on
%    the cruise).
% Every 5th column (starting at column 4) is "Depth" (in meters).
% Every 5th column (starting at column 5) is "pH".
% i = 1:23 cruise 1 2  3   4       23
% 1:5:111  (i.e. 1, 6, 11, 16, ... 111)     Appox_Depth [m]
% 2:5:112  (i.e. 2, 7, 12, 17, ... 112)     Avg_pH
% 3:5:113  (i.e. 3, 8, 13, 18, ... 113)     Station
% 4:5:114  (i.e. 4, 9, 14, 19, ... 114)     Depth [m]
% 5:5:115  (i.e. 5, 10, 15, 20, ... 115)    pH



%% ORGANIZE THE DATA

approx_depth_indices = [1:5:111]; % columns with Approx_Depth data
avg_pH_indices       = [2:5:112]; % columns


% Separate out cruises taken in El Nino, La Nina, or neutral years

% 23 different cruises (all with multiple stations/depth-pH profiles)
% NOTE: do not include cruises: 
%    (1)&(2) for being outside +-5 deg of the study sites
%    (4)&(5) for being not from obsv. but from gridded TALK+TCO2 database

neutral_cruises_east = [7]; % [1, 4, 7]; % not 1, not 4
neutral_cruises_west = [3, 8, 10, 13, 15]; % [2, 3, 5, 8, 10, 13, 15]; % not 2, not 5

nino_cruises_east = [6]; 
nino_cruises_west = [11, 12, 16, 23];

nina_cruises_east = [19]; % Note, bad ~20deg W of study site
nina_cruises_west = [9, 14, 17, 18, 20, 21, 22];



% Selected Station, Depth, and pH columns for each cruise
cruise1 = input(1:101,3:5);
cruise2 = input(1:46,8:10);
cruise3 = input(1:38,13:15);
cruise4 = input(1:112,18:20);
cruise5 = input(1:112,23:25);
cruise6 = input(1:56,28:30);
cruise7 = input(1:98,33:35);
cruise8 = input(1:23,38:40);
cruise9 = input(1:20,43:45);
cruise10 = input(1:22,48:50);
cruise11 = input(1:7,53:55);
cruise12 = input(1:18,58:60);
cruise13 = input(1:18,63:65);
cruise14 = input(1:11,68:70);
cruise15 = input(1:16,73:75);
cruise16 = input(1:21,78:80);
cruise17 = input(1:15,83:85);
cruise18 = input(1:12,88:90);
cruise19 = input(:,93:95);
cruise20 = input(1:18,98:100);
cruise21 = input(1:18,103:105);
cruise22 = input(1:18,108:110);
cruise23 = input(1:18,113:115);


%% MORE DATA QUALITY MANAGEMENT
% Cut off rows 1:16 of cruise6 to cut out bad stations 351 and 355 which
% are outside the 5deg limit (~6-8deg) (this will also cut out stations
% with a single observations: 352, 353, 354, 356, 357, and 358)

cruise6 = cruise6(17:end,:); % now 40 long, now 26>18 stations (though some still only 1 obsv)


%% INTERPOLATE DATA ONTO REGULAR 1m DEPTH INTERVALS

% For every cruise, interpolate onto 1m depths, 1:1:110.
% Then, when every station of every cruise has been put onto 1:1:110m
%   depths, can average together all east cruises/stations (6, 7, 19) (n=3)
%   and all west cruises/stations (cruises 3, 8-18, 20-23) (n = 16)

% 110 rows. Row1=0m. Row2=1m. Row3=2m. Row_i = i-1m. Depth_m = row m+1.
% Max depth: cruise7or9?, 109.1700m. Need 110 rows (1:1:110)
% # cols? How many total stations in eastern cruises: 52. 
    east_pHs_to_avg = nan(110,52); 
    station_count = 1; % also the column you'll want to put the pHs into
    
    [station_count east_pHs_to_avg] = ED5abcd_func_interp_pH_one_meters(cruise6, east_pHs_to_avg, station_count);
    [station_count east_pHs_to_avg] = ED5abcd_func_interp_pH_one_meters(cruise7, east_pHs_to_avg, station_count);
    [station_count east_pHs_to_avg] = ED5abcd_func_interp_pH_one_meters(cruise19, east_pHs_to_avg, station_count);

    
% Now do west. Total stations in western cruises: 59.
    west_pHs_to_avg = nan(110,59); % Max depth: cruise7or9?, 109.1700m. Need 110 rows (0:1:109)
    station_count = 1; % also the column you'll want to put the pHs into
    [station_count west_pHs_to_avg] = ED5abcd_func_interp_pH_one_meters(cruise3, west_pHs_to_avg, station_count);
% Now do for every other western cruise (8-18, 20-23)    
    [station_count west_pHs_to_avg] = ED5abcd_func_interp_pH_one_meters(cruise8, west_pHs_to_avg, station_count);
    [station_count west_pHs_to_avg] = ED5abcd_func_interp_pH_one_meters(cruise9, west_pHs_to_avg, station_count);
    [station_count west_pHs_to_avg] = ED5abcd_func_interp_pH_one_meters(cruise10, west_pHs_to_avg, station_count);
    [station_count west_pHs_to_avg] = ED5abcd_func_interp_pH_one_meters(cruise11, west_pHs_to_avg, station_count);
    [station_count west_pHs_to_avg] = ED5abcd_func_interp_pH_one_meters(cruise12, west_pHs_to_avg, station_count);
    [station_count west_pHs_to_avg] = ED5abcd_func_interp_pH_one_meters(cruise13, west_pHs_to_avg, station_count);
    [station_count west_pHs_to_avg] = ED5abcd_func_interp_pH_one_meters(cruise14, west_pHs_to_avg, station_count);
    [station_count west_pHs_to_avg] = ED5abcd_func_interp_pH_one_meters(cruise15, west_pHs_to_avg, station_count);
    [station_count west_pHs_to_avg] = ED5abcd_func_interp_pH_one_meters(cruise16, west_pHs_to_avg, station_count);
    [station_count west_pHs_to_avg] = ED5abcd_func_interp_pH_one_meters(cruise17, west_pHs_to_avg, station_count);
    [station_count west_pHs_to_avg] = ED5abcd_func_interp_pH_one_meters(cruise18, west_pHs_to_avg, station_count);
    [station_count west_pHs_to_avg] = ED5abcd_func_interp_pH_one_meters(cruise20, west_pHs_to_avg, station_count);
    [station_count west_pHs_to_avg] = ED5abcd_func_interp_pH_one_meters(cruise21, west_pHs_to_avg, station_count);
    [station_count west_pHs_to_avg] = ED5abcd_func_interp_pH_one_meters(cruise22, west_pHs_to_avg, station_count);
    [station_count west_pHs_to_avg] = ED5abcd_func_interp_pH_one_meters(cruise23, west_pHs_to_avg, station_count);
    
    

%% MORE DATA PROCESSING

% AVERAGES - Average together profiles from El Nino years, La Nina years,
% and neutral years.
% Getting average east and west profiles
cols_neutral_east = 19:30; % cruise7
cols_neutral_west = [1:15, 16:18, 21:23, 31:36, 39:40]; % cruise3, 8, 10, 13, 15 (3 has NaNs really n=7)
cols_ElNino_east = 1:18;   % cruise6 (has NaNs, really n=7)
cols_ElNino_west = [24, 25:30, 41:43, 54:59]; % cruise11, 12, 16, 23
cols_LaNina_east = 31:52;  % cruise19 (note 20deg off from site)
cols_LaNina_west = [19:20, 37:38, 44:45, 46:47, 48:49, 50:51, 52:53]; % cruise9, 14, 17, 18, 20, 21, 22
% East
pH_mean_profile_east_allprofs = mean(east_pHs_to_avg, 2, 'omitnan');
pH_mean_profile_east_allprofs_not19 = mean(east_pHs_to_avg(:,1:31), 2, 'omitnan'); % excluding cols 39-60 which come from bad cruise19
pH_mean_profile_east_neutral = mean(east_pHs_to_avg(:, cols_neutral_east), 2, 'omitnan');
pH_mean_profile_east_ElNino  = mean(east_pHs_to_avg(:, cols_ElNino_east), 2, 'omitnan');
pH_mean_profile_east_LaNina  = mean(east_pHs_to_avg(:, cols_LaNina_east), 2, 'omitnan');
pH_2sd_profile_east_allprofs = 2*std(east_pHs_to_avg, 0, 2, 'omitnan'); % 0 for w, 2 for dim
pH_2sd_profile_east_allprofs_not19 = 2*std(east_pHs_to_avg(:,1:31), 0, 2, 'omitnan');
pH_2sd_profile_east_neutral = 2*std(east_pHs_to_avg(:, cols_neutral_east), 0, 2, 'omitnan'); % 0 for w, 2 for dim
pH_2sd_profile_east_ElNino  = 2*std(east_pHs_to_avg(:, cols_ElNino_east), 0, 2, 'omitnan');
pH_2sd_profile_east_LaNina  = 2*std(east_pHs_to_avg(:, cols_LaNina_east), 0, 2, 'omitnan');
% West
pH_mean_profile_west_allprofs = mean(west_pHs_to_avg, 2, 'omitnan');
pH_mean_profile_west_neutral = mean(west_pHs_to_avg(:, cols_neutral_west), 2, 'omitnan');
pH_mean_profile_west_ElNino  = mean(west_pHs_to_avg(:, cols_ElNino_west), 2, 'omitnan');
pH_mean_profile_west_LaNina  = mean(west_pHs_to_avg(:, cols_LaNina_west), 2, 'omitnan');
pH_2sd_profile_west_allprofs = 2*std(west_pHs_to_avg, 0, 2, 'omitnan'); % 0 for w, 2 for dim
pH_2sd_profile_west_neutral = 2*std(west_pHs_to_avg(:, cols_neutral_west), 0, 2, 'omitnan'); % 0 for w, 2 for dim
pH_2sd_profile_west_ElNino  = 2*std(west_pHs_to_avg(:, cols_ElNino_west), 0, 2, 'omitnan');
pH_2sd_profile_west_LaNina  = 2*std(west_pHs_to_avg(:, cols_LaNina_west), 0, 2, 'omitnan');


% GRADIENTS
% West minus east. NOTE: "allprofs" does NOT include La Nina EAST, but DOES
% include La Nina WEST
gradient_allprofs = pH_mean_profile_west_allprofs - pH_mean_profile_east_allprofs;
gradient_allprofs_not19 = pH_mean_profile_west_allprofs - pH_mean_profile_east_allprofs_not19;
gradient_neutral = pH_mean_profile_west_neutral - pH_mean_profile_east_neutral;
gradient_ElNino = pH_mean_profile_west_ElNino - pH_mean_profile_east_ElNino;
gradient_LaNina = pH_mean_profile_west_LaNina - pH_mean_profile_east_LaNina;


% FIND AVERAGE DEPTH PROFILE FOR EACH CRUISE (n=23 cruises)
cruise6_interp_pHs  = mean(east_pHs_to_avg(:,1:18), 2, 'omitnan');
cruise7_interp_pHs  = mean(east_pHs_to_avg(:,19:30), 2, 'omitnan');
cruise19_interp_pHs = mean(east_pHs_to_avg(:,31:52), 2, 'omitnan');

cruise3_interp_pHs  = mean(west_pHs_to_avg(:,1:15), 2, 'omitnan');
cruise8_interp_pHs  = mean(west_pHs_to_avg(:,16:18), 2, 'omitnan');
cruise9_interp_pHs  = mean(west_pHs_to_avg(:,19:20), 2, 'omitnan');
cruise10_interp_pHs  = mean(west_pHs_to_avg(:,21:23), 2, 'omitnan');
cruise11_interp_pHs  = mean(west_pHs_to_avg(:,24), 2, 'omitnan');
cruise12_interp_pHs  = mean(west_pHs_to_avg(:,25:30), 2, 'omitnan');
cruise13_interp_pHs  = mean(west_pHs_to_avg(:,31:36), 2, 'omitnan');
cruise14_interp_pHs  = mean(west_pHs_to_avg(:,37:38), 2, 'omitnan');
cruise15_interp_pHs  = mean(west_pHs_to_avg(:,39:40), 2, 'omitnan');
cruise16_interp_pHs  = mean(west_pHs_to_avg(:,41:43), 2, 'omitnan');
cruise17_interp_pHs  = mean(west_pHs_to_avg(:,44:45), 2, 'omitnan');
cruise18_interp_pHs  = mean(west_pHs_to_avg(:,46:47), 2, 'omitnan');
cruise20_interp_pHs  = mean(west_pHs_to_avg(:,48:49), 2, 'omitnan');
cruise21_interp_pHs  = mean(west_pHs_to_avg(:,50:51), 2, 'omitnan');
cruise22_interp_pHs  = mean(west_pHs_to_avg(:,52:53), 2, 'omitnan');
cruise23_interp_pHs  = mean(west_pHs_to_avg(:,54:59), 2, 'omitnan');



%% Get a list of n=60 stations in east (although note don't include bad 
% cruise19 which will be the last n=22 cols, i.e. cols 39:60)
% AND a list of n=59stations in the west to give pH vals avgd. 25-50m 

east_pHs_2550mavg = nan(1,52);
west_pHs_2550mavg = nan(1,59);

for ii = 1:length(east_pHs_2550mavg) % for every col in east_pHs_to_avg
    east_pHs_2550mavg(ii) = mean(east_pHs_to_avg(25:50,ii)); % produces list of 52 pH values (avgs25-50m) (with nans)
end
east_pHs_2550mavg_ElNino = east_pHs_2550mavg(cols_ElNino_east);
%Get rid of nans in eastElNino record (18>5)
east_pHs_2550mavg_ElNino = east_pHs_2550mavg_ElNino(~isnan(east_pHs_2550mavg_ElNino));
east_pHs_2550mavg_neutral= east_pHs_2550mavg(cols_neutral_east);
east_pHs_2550mavg_LaNina = east_pHs_2550mavg(cols_LaNina_east);


for ii = 1:length(west_pHs_2550mavg) % for every col in west_pHs_to_avg
    west_pHs_2550mavg(ii) = mean(west_pHs_to_avg(25:50,ii));
end
west_pHs_2550mavg_ElNino = west_pHs_2550mavg(cols_ElNino_west); % no NaNs, n=16
west_pHs_2550mavg_neutral = west_pHs_2550mavg(cols_neutral_west);
%Get rid of nans in westElNino record (29>21)
west_pHs_2550mavg_neutral = west_pHs_2550mavg_neutral(~isnan(west_pHs_2550mavg_neutral));
west_pHs_2550mavg_LaNina = west_pHs_2550mavg(cols_LaNina_west); % no NaNs, n=14

% save these relevant pH values (25-50m avgs from all the different depth
% profiles) for use later
save('obsvd_pH_vals_2550mavg.mat', 'east_pHs_2550mavg_ElNino', ...
    'east_pHs_2550mavg_neutral', 'east_pHs_2550mavg_LaNina', ...
    'west_pHs_2550mavg_ElNino', 'west_pHs_2550mavg_neutral', ...
    'west_pHs_2550mavg_LaNina');




% Avg. West (neutral years) east_pHs_2550mavg([cols_ElNino_east cols_neutral_east])
mean(west_pHs_2550mavg_neutral)
% 1sd West (neutral years)
std(west_pHs_2550mavg_neutral)

% Avg. East (neutral years)
mean(east_pHs_2550mavg_neutral)
% 1sd East (neutral years)
std(east_pHs_2550mavg_neutral)

% Max. West (neutral years)
max(west_pHs_2550mavg_neutral)
% Min. West (neutral years)
min(west_pHs_2550mavg_neutral)

% Max. East (neutral years)
max(east_pHs_2550mavg_neutral)
% Min. East (neutral years)
min(east_pHs_2550mavg_neutral)


% All years
% West
mean([west_pHs_2550mavg_neutral west_pHs_2550mavg_ElNino west_pHs_2550mavg_LaNina])
std([west_pHs_2550mavg_neutral west_pHs_2550mavg_ElNino west_pHs_2550mavg_LaNina])
% East
mean([east_pHs_2550mavg_neutral east_pHs_2550mavg_ElNino])
std([east_pHs_2550mavg_neutral east_pHs_2550mavg_ElNino])



%% PLOTTING
clc
close all

% Aesthetics
symbols = {'o', '^', 's', 'd', 'p', 'h', 'x'};
symbols2 = {'-o', '-^', '-s', '-d', '-p', '-h', '-x'}; % + p h % For average lines
default_font_size = 10;
axes_font_size = 12;
legend_font_size = 8;
x_limits = [7.55 8.2];
y_limits = [0 100];

figure
frame_h = get(handle(gcf),'JavaFrame');
set(frame_h,'Maximized',1);

% (A) NEUTRAL YEARS
subplot(1,4,1)
    % Neutral Years - EAST (cruise 7) %%% (cruises 1, 4, 7)
    ED5abcd_plot_all_stations(cruise7, symbols{1}, 'blue');
    % Neutral Years - WEST (cruises 3, 8, 10, 13, 15) %%% (cruises 2,3,5,8,10,13,15)
    ED5abcd_plot_all_stations(cruise3, symbols{2}, 'red');
    ED5abcd_plot_all_stations(cruise8, symbols{4}, 'red');
    ED5abcd_plot_all_stations(cruise10, symbols{5}, 'red');
    ED5abcd_plot_all_stations(cruise13, symbols{6}, 'red');
    ED5abcd_plot_all_stations(cruise15, symbols{7}, 'red');
    % Plot the averages
    for ii = 1:length(neutral_cruises_east)
        plot(input(:,avg_pH_indices(neutral_cruises_east(ii))), ...
            input(:,approx_depth_indices(neutral_cruises_east(ii))), ...
            symbols2{ii}, 'Color', 'blue', 'MarkerEdgeColor', 'blue', ...
            'LineWidth', 2) ;
        hold on
    end
    for ii = 1:length(neutral_cruises_west)
        plot(input(:,avg_pH_indices(neutral_cruises_west(ii))), ...
            input(:,approx_depth_indices(neutral_cruises_west(ii))), ...
            symbols2{ii}, 'Color', 'red', 'MarkerEdgeColor', 'red', ...
            'LineWidth', 2) ;
        hold on
    end    
    % Aesthetics
    ED5abcd_pH_depth_profiles_plot_aesthetics(x_limits, y_limits, axes_font_size);
    title('Neutral Years')        
    legend('Nov 1992 (n=12)', ...
        'Oct 1992 (n=7)', ...
        'May 1995 (n=3)', 'Feb 2002 (n=3)', 'Feb 2007 (n=6)', 'Jul 2009 (n=2)', ...
        'Location', 'northwest', ...
        'FontSize', legend_font_size, 'Box', 'off');   
   
annotation('textbox',...
    [0.105387029288703 0.906878306878308 0.0156443514644352 0.0730158730158732],...
    'String',{'a'},...
    'FontWeight','bold',...
    'FontSize',14,...
    'FitBoxToText','off',...
    'EdgeColor','none');



% (B) EL NINO YEARS
subplot(1,4,2)
    % El Nino Years - EAST (cruises 6)
    ED5abcd_plot_all_stations(cruise6, symbols{1}, 'blue');
    % El Nino Years - WEST (cruises 11, 12, 16, 23)
    ED5abcd_plot_all_stations(cruise11, symbols{1}, 'red');
    ED5abcd_plot_all_stations(cruise12, symbols{2}, 'red');
    ED5abcd_plot_all_stations(cruise16, symbols{3}, 'red');
    ED5abcd_plot_all_stations(cruise23, symbols{4}, 'red');
    % Plot the averages
    for ii = 1:length(nino_cruises_east)
        plot(input(:,avg_pH_indices(nino_cruises_east(ii))), ...
            input(:,approx_depth_indices(nino_cruises_east(ii))), ...
            symbols2{ii}, 'Color', 'blue', 'MarkerEdgeColor', 'blue', ...
            'LineWidth', 2) ;
        hold on
    end
    for ii = 1:length(nino_cruises_west)
        plot(input(:,avg_pH_indices(nino_cruises_west(ii))), ...
            input(:,approx_depth_indices(nino_cruises_west(ii))), ...
            symbols2{ii}, 'Color', 'red', 'MarkerEdgeColor', 'red', ...
            'LineWidth', 2) ;
        hold on
    end    
    % Aesthetics
    ED5abcd_pH_depth_profiles_plot_aesthetics(x_limits, y_limits, axes_font_size)
    title('El Nino Years')
    legend('Apr 1993 (n=5)', 'Jan 2003 (n=1)', 'Dec 2004 (n=6)', ...
        'Feb 2010 (n=3)', 'Dec 2004 (n=6)', ...
        'Location', 'northwest', 'FontSize', legend_font_size, 'Box', 'off');
annotation('textbox',...
    [0.311176778242678 0.906878306878308 0.0156443514644352 0.0730158730158732],...
    'String',{'b'},...
    'FontWeight','bold',...
    'FontSize',14,...
    'FitBoxToText','off',...
    'EdgeColor','none');



% (C) LA NINA YEARS
subplot(1,4,3)
    % La Nina Years - EAST (cruises 19)
    ED5abcd_plot_all_stations(cruise19, symbols{1}, 'blue');
    % La Nina Years - WEST (cruises 9, 14, 17, 18, 20, 21, 22)
    ED5abcd_plot_all_stations(cruise9, symbols{1}, 'red');
    ED5abcd_plot_all_stations(cruise14, symbols{2}, 'red');
    ED5abcd_plot_all_stations(cruise17, symbols{3}, 'red');
    ED5abcd_plot_all_stations(cruise18, symbols{4}, 'red');
    ED5abcd_plot_all_stations(cruise20, symbols{5}, 'red');
    ED5abcd_plot_all_stations(cruise21, symbols{6}, 'red');
    ED5abcd_plot_all_stations(cruise22, symbols{7}, 'red');
    % Plot the averages
    for ii = 1:length(nina_cruises_east)
        plot(input(:,avg_pH_indices(nina_cruises_east(ii))), ...
            input(:,approx_depth_indices(nina_cruises_east(ii))), ...
            symbols2{ii}, 'Color', 'blue', 'MarkerEdgeColor', 'blue', ...
            'LineWidth', 2) ;
        hold on
    end
    for ii = 1:length(nina_cruises_west)
        plot(input(:,avg_pH_indices(nina_cruises_west(ii))), ...
            input(:,approx_depth_indices(nina_cruises_west(ii))), ...
            symbols2{ii}, 'Color', 'red', 'MarkerEdgeColor', 'red', ...
            'LineWidth', 2) ;
        hold on
    end  
    % Aesthetics
    ED5abcd_pH_depth_profiles_plot_aesthetics(x_limits, y_limits, axes_font_size)
    title('La Nina Years')
    legend('Dec 2007 (n=22)\newline{\it(20\circ west of study site)}', 'Jan 1999 (n=2)', 'Jul 2007 (n=2)', 'Feb 2009 (n=2)', ... 
        'Feb 2018 (n=2)', 'Jan 1999 (n=2)', 'Feb 2008 (n=2)', 'Jul 2008 (n=2)', ...
        'Location', 'northwest', 'FontSize', legend_font_size, 'Box', 'off');
annotation('textbox',...
    [0.51706328451883 0.906878306878308 0.0156443514644352 0.0730158730158732],...
    'String',{'c'},...
    'FontWeight','bold',...
    'FontSize',14,...
    'FitBoxToText','off',...
    'EdgeColor','none');


depths = [1:1:110]; 
% (D) Average, all stations from Neutral Years
subplot(1,4,4)
    % Patch for depth habitat of O. univ.
    patch( [7.55 8.2 8.2 7.55], [25 25 50 50], 'k', ...
        'EdgeColor', 'none', 'FaceAlpha', 0.05);
    hold on
    % Average from Neutral Years - EAST
    plot(pH_mean_profile_east_neutral, depths, 'blue', 'LineWidth', 2);
    hold on
    east_mins = pH_mean_profile_east_neutral - pH_2sd_profile_east_neutral;
    east_maxs = pH_mean_profile_east_neutral + pH_2sd_profile_east_neutral;
    patch( [east_mins; flip(east_maxs)], [depths' ; flip(depths')], ...
        'b', 'EdgeColor', 'none','FaceAlpha', 0.1);
    % Average from Neutral Years - WEST
    plot(pH_mean_profile_west_neutral, depths, 'red', 'LineWidth', 2);
    hold on
    west_mins = pH_mean_profile_west_neutral - pH_2sd_profile_west_neutral;
    west_maxs = pH_mean_profile_west_neutral + pH_2sd_profile_west_neutral;    
    patch( [west_mins; flip(west_maxs)], [depths' ; flip(depths')], ...
        'r', 'EdgeColor', 'none','FaceAlpha', 0.3);
    % Aesthetics
    ED5abcd_pH_depth_profiles_plot_aesthetics(x_limits, y_limits, axes_font_size)
    title('Average Profiles from Neutral Years')
    legend('{\itO. universa} depth habitat', 'East', '2\sigma', 'West', '2\sigma', ...
        'Location', 'northwest', 'FontSize', legend_font_size, 'Box', 'off');


annotation('textbox',...
    [0.72409780334729 0.906878306878308 0.0156443514644352 0.0730158730158732],...
    'String',{'d'},...
    'FontWeight','bold',...
    'FontSize',14,...
    'FitBoxToText','off',...
    'EdgeColor','none');
