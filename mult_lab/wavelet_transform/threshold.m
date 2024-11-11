function [out] = threshold(sub)
sub_avg = mean(mean(sub));
avg_mask = sub >= sub_avg;

out = sub .* avg_mask;
end