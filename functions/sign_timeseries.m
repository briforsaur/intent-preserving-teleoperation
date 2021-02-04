function ts_sign = sign_timeseries(ts)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

ts_sign = timeseries(sign(ts.Data),ts.Time);
end

