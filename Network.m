function [input_big, input_small, output_big, output_small] = Network(name)
path = 'output/ML/';
    
% [file1, ~] = uigetfile([path, 'fish/*.*']);
file1 = name;

input_path = [path, 'fish/', file1(1:findstr(file1, '.')), 'txt'];
output_path = [path, 'force/', file1(1:findstr(file1, '.')), 'txt'];

T1 = readtable(input_path);

T2 = readtable(input_path);

input_data = table2array(T1(:,1:3));
timeline_input = table2array(T1(:,4));
i=2;
while i<length(timeline_input)
    if timeline_input(i) == timeline_input(i-1)
        timeline_input(i) = [];
        input_data(i, :) = [];
    else 
        i= i+1;
    end
    
end
output_data = table2array(T2(:,5:7));
timeline_output = table2array(T2(:,4));
i=2;
while i<length(timeline_output)
    if timeline_output(i) == timeline_output(i-1)
        timeline_output(i) = [];
        output_data(i, :) = [];
    else 
        i= i+1;
    end
end

correction = intersect(timeline_input, timeline_output);
[is1, ~] = ismember(timeline_input, correction);
in_data = [];
for i=1:length(timeline_input)
    if is1(i) == true
        in_data = [in_data; i];
    end
end
out1 = timeline_input(in_data);

[is2, ~] = ismember(timeline_output, correction);
out_data = [];
for i=1:length(timeline_output)
    if is2(i) == true
        out_data = [out_data; i];
    end
end
out2 = timeline_output(out_data);

input_data = input_data(in_data, :);
big_range = round(length(input_data)*3/4);
input_big = input_data(:, :);
input_small = input_data(big_range:length(input_data), :);

output_data = output_data(out_data, :);
output_big = output_data(:, :);
output_small = output_data(big_range:length(output_data), :);
disp('Done');