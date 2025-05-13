function bestPaths = route_ga_solver(obstacleGrid, startPoints, endPoints, voxelSizeMM)
% Rozszerzenie przeszkód o 1 voxel w każdą stronę
obstacleGrid = imdilate(obstacleGrid, ones(3,3,3));

    % Parametry GA
    numGenerations = 100;
    populationSize = 50;
    mutationRate = 0.2;

    numCables = size(startPoints, 1);
    gridSize = size(obstacleGrid);
    bestPaths = cell(numCables, 1);

    for i = 1:numCables
        startPoint = startPoints(i, :);
        endPoint = endPoints(i, :);
        fprintf('Optymalizacja trasy dla kabla %d...\n', i);

        % Inicjalizacja populacji
        population = initialize_population(populationSize, startPoint, endPoint, gridSize);


        for gen = 1:numGenerations
            fitness = evaluate_fitness(population, obstacleGrid);

            % Przekazanie obstacleGrid do evolve_population
            [population, bestFitness] = evolve_population(population, fitness, mutationRate, startPoint, endPoint, gridSize, obstacleGrid);

            progress = (gen / numGenerations) * 100;
            fprintf('Kabel %d | Generacja %d/%d (%.1f%%), najlepsza ocena: %.2f\n', ...
                i, gen, numGenerations, progress, min(fitness));
        end

        bestPaths{i} = population{1};  % najlepsza ścieżka
    end

    % --- Wizualizacja ---
    fprintf('\nRysowanie wynikowych tras...\n');
    [sy, sx, sz] = size(obstacleGrid);
    x = (0:sx-1) * voxelSizeMM;
    y = (0:sy-1) * voxelSizeMM;
    z = (0:sz-1) * voxelSizeMM;

    figure;
    rotate3d on;
    dcm = datacursormode(gcf);
    set(dcm, 'DisplayStyle', 'datatip', 'SnapToDataVertex', 'off', 'Enable', 'on');

    % Model voxelowy (przeszkody)
    p = patch(isosurface(x, y, z, obstacleGrid, 0.5));
    p.FaceColor = [0.8 0.2 0.2];
    p.EdgeColor = 'none';
    p.FaceAlpha = 0.2;

    daspect([1 1 1]);
    view(3);
    axis tight;
    camlight;
    lighting gouraud;
    xlabel('X [mm]');
    ylabel('Y [mm]');
    zlabel('Z [mm]');
    title('Trasy kabli na tle voxelowego modelu');

    hold on;

    % Rysowanie tras kabli
    colors = lines(numel(bestPaths));
    legendEntries = cell(numel(bestPaths), 1);
    h = gobjects(numel(bestPaths), 1);  % uchwyty do linii

    for i = 1:numel(bestPaths)
        path = bestPaths{i};
        scaledPath = path * voxelSizeMM;

        h(i) = plot3(scaledPath(:,1), scaledPath(:,2), scaledPath(:,3), ...
                     '-', 'Color', colors(i,:), 'LineWidth', 2);
        scatter3(scaledPath(1,1), scaledPath(1,2), scaledPath(1,3), ...
                 60, colors(i,:), 'filled');
        scatter3(scaledPath(end,1), scaledPath(end,2), scaledPath(end,3), ...
                 60, colors(i,:), 'o');
        legendEntries{i} = ['Kabel ', num2str(i)];
    end

    legend(h, legendEntries, 'Location', 'northeastoutside');
end
