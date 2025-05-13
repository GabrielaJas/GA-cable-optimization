function fitness = evaluate_fitness(population, obstacleGrid)
    fitness = zeros(length(population), 1);
    gridSize = size(obstacleGrid);

    for i = 1:length(population)
        path = population{i};
        cost = 0;
        hasCollision = false;

        for j = 1:size(path, 1) - 1
            segment = bresenham3d(path(j, :), path(j+1, :));

            for k = 1:size(segment, 1)
                idx = segment(k, :);

                if any(idx < 1) || ...
                   idx(1) > gridSize(2) || ...
                   idx(2) > gridSize(1) || ...
                   idx(3) > gridSize(3) || ...
                   obstacleGrid(idx(2), idx(1), idx(3))
                    % Kolizja lub wyjście poza siatkę
                    cost = cost + 10000;
                    hasCollision = true;
                else
                    cost = cost + 1;
                end
            end
        end

        % Opcjonalnie: odrzuć kolizyjne trasy (bardziej bezwzględnie)
        if hasCollision
            cost = cost + 1e5;
        end

        fitness(i) = cost;
    end
end
