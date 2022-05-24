function [data] = mean_experiment_data()
    % Mean experiment
%     mean_exp__mean_values = [[7, 7.7]; [8, 10] ; [10, 12] ; [14, 8]; [5.5, 6.5]; [6.6, 6.5]; [10, 7.5]; [6, 3.5]]';
    mean_exp__mean_values = [[5,6];[8,6];[10,8];[8,13];[6.5,11];[8,12];[14,8];[9,18]; [7,17]; [11,3]; [7,3]; [11,3]; [7,3]; [11,17]; [8,13]; [8,14]; [3,11]; [3,7]; [17,11]; [6,5]; [17,7]; [8,10]];
    mean_exp__sd_values = [0.25, 0.5, 0.8, 1.2];
    data = zeros(size(mean_exp__mean_values, 1) + size(mean_exp__sd_values, 1),...
        size(mean_exp__mean_values, 2) * size(mean_exp__sd_values, 2));
    for i = 1:size(mean_exp__mean_values, 2)
        for j = 1:size(mean_exp__sd_values, 2)
            entry = [mean_exp__mean_values(:, i) ; mean_exp__sd_values(:, j)];
            data(:, (i - 1) * size(mean_exp__sd_values, 2) + j) = entry;
        end
    end
end
