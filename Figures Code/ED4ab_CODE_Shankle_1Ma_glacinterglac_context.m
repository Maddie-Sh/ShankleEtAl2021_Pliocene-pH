%% ED4ab: Glacial-Interglacial Conext of 1Ma Samples
% Madison Shankle
% 13-09-2021

% Plots the ages of this study's 1Ma data (as vertical lines) over high-res
% SST records, to provide the glacial-interglacial context of these
% samples.

% Note, requires the "ED4ab_stackplot_MS.m" function to be in your working
% directory or added to Matlab's path.

% References:
% Medina-Elizalde, M. & Lea, D. W. The mid-Pleistocene transition in the 
%  tropical Pacific. Science 310, 1009–1012 (2005).
% Liu, Z. & Herbert, T. D. High-latitude influence on the eastern 
%  equatorial Pacific climate in the early Pleistocene epoch. Nature 427, 
%  720–723 (2004).



%% LOAD IN DATA 

clearvars
close all
clc

% G. ruber Mg/Ca SST, d18O, WEP ODP806B
table_WEP_806B = readtable('ED4ab_Medina-Elizalde_Lea_2005_806B_MgCaSST_ODP806B.xlsx');

% Alkenone SST data, EEP ODP846
table_EEP_846 = readtable('ED4ab_Liu2004_AlkenoneSST_ODP846.xls');

thisstudy_WEP_806 = [0.800, 0.900, 1.000, 1.100];
thisstudy_EEP_846 = [0.800, 0.952, 1.003, 1.048];



%% PLOTTING

close all
clc

% Aesthetics
    limage = [0 1.4];   % x-axis age limits, ka
    lim = limage;
    ageticks = [0:0.2:1.4];
  
    red_color = [0.8 0 0];
    blue_color = [0 0.3 0.75];
    green_color = [0.15 0.85 0.5];
    green_linewidth = 2;
    
    numplots = 2;       % number of panels
    handles = ED4ab_stackplot_MS(numplots);
       
    
% --- Panel 1 (top): WEP 806 (Medina-Elizade & Lea, 2005, ... ----------- %
% --- ... G. ruber Mg/Ca SST -------------------------------------------- %
    h = numplots;       % i.e. 2, top panel
    hold(handles(h), 'on');

    plot(table_WEP_806B.Age_kyr/1000, table_WEP_806B.SST, 'LineWidth', 1, ...
        'Color', red_color);
    hold on
    for ii = 1:length(thisstudy_WEP_806)
        xline(thisstudy_WEP_806(ii), 'LineWidth', green_linewidth, 'Color', green_color);
    end

    xlim(lim)
    ylim([25 31])
    ylabel('SST \fontsize{9}[\circC]', 'FontWeight', 'bold', 'Color', red_color);
        
    dim = [0.352 0.839 0.176 0.095]; % 1st #: 0.36 % [.15 .65 .3 .3];
    str = 'WEP (ODP 806B)^{115}\newline ({\itG. ruber} Mg/Ca)';
    annotation('textbox',dim,'String',str,'FitBoxToText','on', ...
         'EdgeColor', 'none', 'FontSize', 6.5);
    
    annotation('textbox', [0.07 0.912 0.041 0.057],...
    'VerticalAlignment','middle',...
    'String','a',...
    'HorizontalAlignment','center',...
    'FitBoxToText','off', ...
    'EdgeColor', 'none', ...
    'FontWeight', 'bold');
   

%
% --- Panel 2 (bottom): EEP 846 (Liu & Herbert, 2005, ... --------------- %
% --- ... alkenones SST ------------------------------------------------- %    
    h = h-1; % 1
    hold(handles(h), 'on');
    
    plot(table_EEP_846.Time_kyr/1000, table_EEP_846.Temp_C, 'LineWidth', 1, ...
        'Color', blue_color, 'Parent', handles(h));
    hold on
    for ii = 1:length(thisstudy_EEP_846)
        xline(thisstudy_EEP_846(ii), 'LineWidth', green_linewidth, 'Color', ...
            green_color, 'Parent', handles(h));
    end    

    set(handles(h), 'xlim', lim);
    yticks(handles(h), [20 21 22 23 24 25 26])
    ylabel('SST \fontsize{9}[\circC]', 'FontWeight', 'bold', 'Color', blue_color, ...
        'Rotation', 270, 'VerticalAlignment', 'bottom', 'Parent', handles(h));
    xlabel('Age \fontsize{9}[Ma]', 'FontWeight', 'bold', 'Parent', handles(h));
    
    dim = [0.24 0.369 0.137 0.099]; % dim + [0.09 -0.49 0 0]; % above: [.15 .65 .3 .3];
    str = 'EEP (ODP 846)^{116}\newline   (Alkenones)';
    annotation('textbox',dim,'String',str,'FitBoxToText','on', ...
         'EdgeColor', 'none', 'FontSize', 7);

    annotation('textbox', [0.07 0.412 0.041 0.057],...
    'VerticalAlignment','middle',...
    'String','b',...
    'HorizontalAlignment','center',...
    'FitBoxToText','off', ...
    'EdgeColor', 'none', ...
    'FontWeight', 'bold');
    

% Shift panels around/up down
%[left bottom width height]
% bottom panel/panel 2:
    shiftup = 0.045; % 0.035; 
    
    axpos = get(handles(1),'Position');
    set(handles(1), 'Position', [axpos(1) axpos(2)+shiftup axpos(3) axpos(4)])
    
    
% 2nd-to-bottom panel/panel 5:
    shiftdown = -0.009; % -0.01; 
    
    axpos = get(handles(2),'Position');
    set(handles(2), 'Position', [axpos(1) axpos(2)+shiftdown axpos(3) axpos(4)])
  
   