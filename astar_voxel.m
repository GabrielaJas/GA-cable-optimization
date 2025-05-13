function path = astar_voxel(startPoint, endPoint, obstacleGrid)
    gridSize = size(obstacleGrid);
    startNode = sub2ind(gridSize, startPoint(2), startPoint(1), startPoint(3));
    goalNode  = sub2ind(gridSize, endPoint(2), endPoint(1), endPoint(3));

    % A* setup
    cameFrom = containers.Map('KeyType', 'uint32', 'ValueType', 'uint32');
    gScore = containers.Map('KeyType', 'uint32', 'ValueType', 'double');
    fScore = containers.Map('KeyType', 'uint32', 'ValueType', 'double');

    gScore(startNode) = 0;
    fScore(startNode) = heuristic(startPoint, endPoint);

    openSet = java.util.PriorityQueue();
    openSet.add({fScore(startNode), startNode});

    visited = false(gridSize);

    % Ruchy: 6 sąsiadów (4 jeśli chcesz prostszy ruch)
    moves = [
        1 0 0; -1 0 0;
        0 1 0; 0 -1 0;
        0 0 1; 0 0 -1
    ];

    while ~openSet.isEmpty()
        current = openSet.remove();
        currentNode = current{2};
        [y, x, z] = ind2sub(gridSize, currentNode);
        currentPos = [x y z];

        if currentNode == goalNode
            path = reconstruct_path(cameFrom, currentNode, gridSize);
            return;
        end

        visited(y, x, z) = true;

        for m = 1:size(moves, 1)
            neighborPos = currentPos + moves(m, :);
            if any(neighborPos < 1) || any(neighborPos > gridSize)
                continue;
            end
            nx = neighborPos(1);
            ny = neighborPos(2);
            nz = neighborPos(3);
            if obstacleGrid(ny, nx, nz)
                continue;
            end

            neighborNode = sub2ind(gridSize, ny, nx, nz);
            if visited(ny, nx, nz)
                continue;
            end

            tentative_gScore = gScore(currentNode) + 1;

            if ~isKey(gScore, neighborNode) || tentative_gScore < gScore(neighborNode)
                cameFrom(neighborNode) = currentNode;
                gScore(neighborNode) = tentative_gScore;
                fScore(neighborNode) = tentative_gScore + heuristic(neighborPos, endPoint);
                openSet.add({fScore(neighborNode), neighborNode});
            end
        end
    end

    % Jeśli brak ścieżki
    path = [];
    warning('A* nie znalazł ścieżki.');
end

function h = heuristic(p1, p2)
    h = norm(p1 - p2);  % euklidesowa
end

function path = reconstruct_path(cameFrom, currentNode, gridSize)
    path = [];
    while isKey(cameFrom, currentNode)
        [y, x, z] = ind2sub(gridSize, currentNode);
        path = [ [x y z]; path ];  %#ok<AGROW>
        currentNode = cameFrom(currentNode);
    end
    [y, x, z] = ind2sub(gridSize, currentNode);
    path = [ [x y z]; path ];  % start node
end
