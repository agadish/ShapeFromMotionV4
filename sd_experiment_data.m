function [data] = sd_experiment_data()
    % SD experiment
    sd_exp__sd_values = [[1.5, 0.1] ; [2, 0.7] ; [0.3, 0.9]; [1.3, 0.3]; [2.5, 1]; [0.1, 1]]';
    sd_exp__mean_values = [5, 10, 15];
    data = zeros(size(sd_exp__sd_values, 1) + size(sd_exp__mean_values, 1),...
        size(sd_exp__sd_values, 2) * size(sd_exp__mean_values, 2));
    
    
    for i = 1:size(sd_exp__sd_values, 2)
        for j = 1:size(sd_exp__mean_values, 2)
            entry = [sd_exp__sd_values(:, i) ; sd_exp__mean_values(:, j)];
            data(:, (i - 1) * size(sd_exp__sd_values, 2) + j) = entry;
        end
    end
end