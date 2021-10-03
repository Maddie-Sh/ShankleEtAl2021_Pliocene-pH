function ED5abcd_pH_depth_profiles_plot_aesthetics(x_limits, y_limits, axes_font_size)
% Madison Shankle, 14-09-2021

set(gca, 'YDir', 'reverse');
ylim(y_limits);
xlim(x_limits);
xlabel('pH', 'FontSize', axes_font_size, 'FontWeight', 'bold');
ylabel('Depth [m]', 'FontSize', axes_font_size, 'FontWeight', 'bold');