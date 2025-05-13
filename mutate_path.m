function mutated = mutate_path(path, gridSize, obstacleGrid)
    idx = randi(size(path, 1)-2) + 1;  % nie ruszaj startu ani końca
    maxTries = 10;

    for t = 1:maxTries
        delta = randi([-1, 1], 1, 3);
        new_point = max(1, min(gridSize, path(idx, :) + delta));
        if ~obstacleGrid(new_point(2), new_point(1), new_point(3))
            path(idx, :) = new_point;
            break;
        end
    end

    mutated = path;
end
