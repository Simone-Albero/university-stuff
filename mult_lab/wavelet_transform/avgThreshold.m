function [out] = avgThreshold(sub)
sub_avg = mean(mean(sub));

out = sub;
out(sub < sub_avg) = sub_avg;
end