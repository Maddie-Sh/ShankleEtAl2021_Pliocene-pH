function [station_count_output pHs_to_avg_output] = ED5abcd_func_interp_pH_one_meters(cruise_data, pHs_to_avg_input, station_count_input)
% Madison Shankle, 14-09-2021
% cruise_data = ###x3 array giving Station, Depth, pH in cols of one cruise
% pHs_to_avg: the array of nans that's depths x no. stations in size
% station_count: will start at 1 before feeding first cruise into this
%                function, then will be updated as this function goes
%                through every station in that cruise. Whatever the final
%                station_count is, feed it into the next one when you run
%                this function for the next subsequent cruise.

stations = unique(cruise_data(:,1)); %(n=23 stations in cruise1)
for ii = 1:length(stations) % for every station on the given cruise (cruise_data)
    ii
    
    % Get the pHs and depths (double-checked, good)
    pHs_from_that_station    = cruise_data(cruise_data(:,1) == stations(ii),3); % all rows of that station, and col 3
    depths_from_that_station = cruise_data(cruise_data(:,1) == stations(ii),2);

    if length(pHs_from_that_station) > 1 % if only 1 data point, ignore and leave col as NaNss
        % Interpolate them on to regular depths (1:1:110m)
        new_interp_pH = interp1(depths_from_that_station, pHs_from_that_station, [1:1:110], 'linear', 'extrap');

        % Take that new list of 110 interpolated pHs (on depths 1:1:110m) and
        % put into the appropriate column of pHs_to_avg_input (each col = one
        % station from a cruise) (pHs_to_avg_input = 110rows x 60 cols)

        pHs_to_avg_input(:, station_count_input) = new_interp_pH;            
    end
    
    station_count_input = station_count_input + 1;
end

pHs_to_avg_output = pHs_to_avg_input;
station_count_output = station_count_input;