function ts_dot = dot_product_timeseries(ts1,ts2)
%calc_timeseries_dot_product Sample-wise dot product of two timeseries
%   ts_dot = calc_timeseries_dot_product(ts1,ts2)
%   Given the two timeseries objects with an equal number of samples and
%   values per sample, returns a timeseries object containing the dot
%   product of each sample.

% ts_dot = timeseries(zeros(size(ts1.time)),ts1.time);
% for i = 1:size(ts1.time)
%     ts_dot.Data(i) = dot(ts1.Data(i,:),ts2.Data(i,:));
% end

ts_dot = timeseries(sum(ts1.Data.*ts2.Data,2), ts1.time);

