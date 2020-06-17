function ts_mag = calc_timeseries_magnitude(ts)
%CALC_TIMESERIES_MAGNITUDE Calculates the Euclidean norm of a time series
%   ts_mag = calc_timeseries_magnitude(ts)
%   Accepts a timeseries object input, outputs a timeseries object with
%   one column containing the Euclidean norm of the input object's data
%   rows. The output has the same time data as the input timeseries.

ts_mag = timeseries(sqrt(sum(ts.Data.^2,2)), ts.Time);
end