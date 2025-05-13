function path = astar_voxel3d(startPoint, endPoint, obstacleGrid)

    startPoint = round(startPoint);
    endPoint = round(endPoint);
    gridSize = size(obstacleGrid);

    % Sprawdź, czy start lub koniec są w przeszkodzie
    if obstacleGrid(startPoint(2), startPoint(1), startPoint(3)) || ...
       obstacleGrid(endPoint(2), endPoint(1), endPoint(3))
        path = [];
        return;
    end

    % Heurystyka: odległość euklidesowa
    heuristic = @(a, b) norm(a - b);

    % Listy A*
    openSet = containers.Map;
    key = mat2str(startPoint);
    openSet(key) = 0;

    cameFrom = containers.Map;

    gScore = containers.Map;
    gScore(key) = 0;

    fScore = containers.Map;
    fScore(key) = heuristic(startPoint, endPoint);

    % Kierunki: 6 sąsiadów
    directions = [1 0 0; -1 0 0; 0 1 0; 0 -1 0; 0 0 1; 0 0 -1];

    while ~isempty(openSet)
        keys = openSet.keys;
        [~, idx] = min(cellfun(@(k) fScore(k), keys));
        currentKey = keys{idx};
        current = str2num(currentKey); %#ok<ST2NM>

        if isequal(current, endPoint)
            path = current;
            while isKey(cameFrom, mat2str(current))
                current = str2num(cameFrom(mat2str(current))); %#ok<ST2NM>
                path = [current; path];
            end
            return;
        end

        remove(openSet, currentKey);

        for i = 1:size(directions,1)
            neighbor = current + directions(i,:);
            if any(neighbor < 1) || ...
               neighbor(1) > gridSize(2) || ...
               neighbor(2) > gridSize(1) || ...
               neighbor(3) > gridSize(3)
                continue;
            end

            if obstacleGrid(neighbor(2), neighbor(1), neighbor(3))
                continue;
            end

            neighborKey = mat2str(neighbor);
            tentativeG = gScore(currentKey) + 1;

            if ~isKey(gScore, neighborKey) || tentativeG < gScore(neighborKey)
                cameFrom(neighborKey) = currentKey;
                gScore(neighborKey) = tentativeG;
                fScore(neighborKey) = tentativeG + heuristic(neighbor, endPoint);
                openSet(neighborKey) = 1;
            end
        end
    end

    % Jeśli nie znaleziono ścieżki
    path = [];
end
