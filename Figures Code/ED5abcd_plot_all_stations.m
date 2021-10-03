function ED5abcd_plot_all_stations(data, symbol, mycolor)
% Madison Shankle, 14-09-2021

    stations = unique(data(:,1));
    for ii = 1:length(stations)
        scatter1 = scatter(data(data(:,1) == stations(ii),3), ... % x = pH
            data(data(:,1) == stations(ii), 2), ... % y = depth
            symbol, 'MarkerEdgeColor', mycolor, 'HandleVisibility', 'off');
        scatter1.MarkerEdgeAlpha = 0.2;
        hold on
        plot1 = plot(data(data(:,1) == stations(ii),3), ... % x = pH
            data(data(:,1) == stations(ii), 2), ... % y = depth
            'Color', mycolor, 'HandleVisibility', 'off');
        plot1.Color(4) = 0.2;
%         if ii <= 9
%             % line style is solid
%             plot1 = plot(data(data(:,1) == stations(ii),3), ... % x = pH
%                 data(data(:,1) == stations(ii), 2), ... % y = depth
%                 'Color', mycolor);
%             plot1.Color(4) = 0.2;
%             hold on            
%         end
%         if ii > 9 & ii < 19
%             % line style is dashed
%             plot1 = plot(data(data(:,1) == stations(ii),3), ... % x = pH
%                 data(data(:,1) == stations(ii), 2), ... % y = depth
%                 '--', 'Color', mycolor);
%             plot1.Color(4) = 0.2;
%             hold on
%         end
%         if ii >= 19
%             % line style is dotted (thicken up the line)
%             plot1 = plot(data(data(:,1) == stations(ii),3), ... % x = pH
%                 data(data(:,1) == stations(ii), 2), ... % y = depth
%                 ':', 'Color', mycolor, 'LineWidth', 1);
%             plot1.Color(4) = 0.2;
%             hold on
%         end
    end