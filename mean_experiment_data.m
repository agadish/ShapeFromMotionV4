function [data] = mean_experiment_data()
    % Mean experiment
    mean_exp__mean_values = [[7, 7.7]; [8, 10] ; [10, 12] ; [14, 8]; [5.5, 6.5]; [6.6, 6.5]; [10, 7.5]; [6, 3.5]]';
    mean_exp__sd_values = [0.1, 0.7, 1.5];
    data = zeros(size(mean_exp__mean_values, 1) + size(mean_exp__sd_values, 1),...
        size(mean_exp__mean_values, 2) * size(mean_exp__sd_values, 2));
    for i = 1:size(mean_exp__mean_values, 2)
        for j = 1:size(mean_exp__sd_values, 2)
            entry = [mean_exp__mean_values(:, i) ; mean_exp__sd_values(:, j)];
            data(:, (i - 1) * size(mean_exp__sd_values, 2) + j) = entry;
        end
    end
end
