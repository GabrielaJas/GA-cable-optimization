function population = initialize_population(populationSize, startPoint, endPoint, gridSize)
    population = cell(populationSize, 1);
    numPoints = 10;

    for i = 1:populationSize
        path = zeros(numPoints, 3);
        for j = 1:3
            path(:, j) = round(linspace(startPoint(j), endPoint(j), numPoints));
        end

        % Dodaj lekkie losowe odchylenie
        jitter = randi([-1 1], numPoints, 3);
        path = path + jitter;

        % Ogranicz do siatki voxel
        path = max(1, min(repmat(gridSize([2 1 3]), numPoints, 1), path));

        % Ustaw pierwszy i ostatni punkt dokładnie
        path(1, :) = startPoint;
        path(end, :) = endPoint;

        population{i} = path;
    end
end
